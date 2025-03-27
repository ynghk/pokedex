import 'package:flutter/material.dart';
import 'package:poke_master/models/pokedex_entry.dart';
import 'package:poke_master/models/pokemon_type_colors.dart';
import 'package:poke_master/repositories/pokemon_repository.dart';
import 'package:poke_master/views/screens/pokedex_screen.dart';
import 'package:provider/provider.dart';

// 정렬 방식 열거형
enum SortOption {
  numberAscending, // 번호 오름차순 (기본값)
  numberDescending, // 번호 내림차순
  nameAscending, // 이름 오름차순
  nameDescending, // 이름 내림차순
}

class PokemonListViewModel with ChangeNotifier {
  final PokemonRepository _repository;
  final List<PokedexEntry> _allPokemons = [];
  List<PokedexEntry> _pokemons = [];
  String _searchQuery = '';
  String _selectedRegion = 'Kanto';
  String _selectedLanguage = 'English';
  bool _isDarkMode = false; // 다크모드 상태 추가
  bool isLoading = true;
  String? error; // 에러 상태 추가
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // 필터링 및 정렬 관련 변수
  final List<String> _availableTypes = [
    'normal',
    'fire',
    'water',
    'electric',
    'grass',
    'ice',
    'fighting',
    'poison',
    'ground',
    'flying',
    'psychic',
    'bug',
    'rock',
    'ghost',
    'dark',
    'dragon',
    'steel',
    'fairy',
  ];
  final Set<String> _selectedTypes = {}; // 선택된 타입들
  SortOption _sortOption = SortOption.numberAscending; // 기본 정렬: 번호 오름차순

  final Map<int, List<String>> typeCache = {};

  // 지역별 캐시
  final Map<String, List<PokedexEntry>> _regionCache = {};

  // 생성자 변경
  PokemonListViewModel(this._repository) : _selectedRegion = '' {
    // 검색어 변경 리스너 추가
    _textController.addListener(_onSearchChanged);
  }

  // 검색어 변경 감지 메서드
  void _onSearchChanged() {
    updateSearchQuery(_textController.text);
  }

  // 검색어 업데이트 메서드
  void updateSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    print('Search query: $_searchQuery, All pokemons: ${_allPokemons.length}');
    notifyListeners();
  }

  // 검색 초기화 메서드
  void clearSearch() {
    _textController.clear();
    _searchQuery = '';
    notifyListeners();
  }

  // 타입 필터 토글
  void toggleTypeFilter(String type) {
    if (_selectedTypes.contains(type)) {
      _selectedTypes.remove(type);
    } else {
      _selectedTypes.add(type);
    }
    notifyListeners();
  }

  // 타입 필터 초기화
  void clearTypeFilters() {
    _selectedTypes.clear();
    notifyListeners();
  }

  // 정렬 옵션 변경
  void updateSortOption(SortOption option) {
    _sortOption = option;
    notifyListeners();
  }

  // 타입 별 캐시 미리 로드
  Future<void> preloadTypeCache() async {
    for (var pokemon in _allPokemons) {
      // _pokemons 대신 _allPokemons 사용
      if (!typeCache.containsKey(pokemon.getPokemonId())) {
        try {
          final types = await getPokemonTypes(pokemon.getPokemonId());
          // 비동기 작업 중 dispose 됐을 수 있으므로 체크
          if (types.isNotEmpty) {
            typeCache[pokemon.getPokemonId()] = types;
          }
        } catch (e) {
          print('Failed to load types for ${pokemon.name}: $e');
        }
      }
    }
    // 모든 타입 로드 후 갱신
    notifyListeners();
  }

  // 검색 UI 스타일 - 텍스트 스타일
  TextStyle getSearchTextStyle(BuildContext context) {
    final isDark =
        Theme.of(context).colorScheme.surface.computeLuminance() <= 0.5;
    return TextStyle(color: isDark ? Colors.white : Colors.black);
  }

  // 검색 UI 스타일 - 입력창 데코레이션
  InputDecoration getSearchDecoration(BuildContext context) {
    final isDark =
        Theme.of(context).colorScheme.surface.computeLuminance() <= 0.5;
    return InputDecoration(
      hintText: 'Search for Pokemon',
      hintStyle: TextStyle(color: isDark ? Colors.grey[300] : Colors.grey[600]),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: isDark ? Colors.white : Colors.black,
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: isDark ? Colors.white : Colors.black,
          width: 2.0,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      suffixIcon: IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          clearSearch();
        },
      ),
    );
  }

  // Getters
  TextEditingController get textController => _textController;
  ScrollController get scrollController => _scrollController;
  List<PokedexEntry> get pokemons => _pokemons;
  String get searchQuery => _searchQuery;
  String get selectedRegion => _selectedRegion;
  String get selectedLanguage => _selectedLanguage;
  bool get isDarkMode => _isDarkMode;
  // 타입 및 정렬 관련 getter
  List<String> get availableTypes => _availableTypes;
  Set<String> get selectedTypeChip => _selectedTypes;
  SortOption get sortOption => _sortOption;

  // 필터링된 포켓몬 리스트
  List<PokedexEntry> get filteredPokemons {
    // 검색어가 있으면 전체 포켓몬에서 검색 (지역 제한 없음)
    List<PokedexEntry> allPokemons =
        _regionCache.values.expand((pokemons) => pokemons).toSet().toList();

    List<PokedexEntry> filtered =
        _searchQuery.isEmpty
            ? List.from(_pokemons) // 검색어 없을 때는 현재 지역 포켓몬만
            : allPokemons // 검색어 있을 때는 모든 지역 포켓몬에서 검색
                .where(
                  (pokemon) =>
                      pokemon.name.toLowerCase().contains(_searchQuery) ||
                      pokemon.id.toString().contains(_searchQuery),
                )
                .toList();

    // 타입 필터 적용 (필터가 선택된 경우)
    if (_selectedTypes.isNotEmpty) {
      filtered =
          filtered.where((pokemon) {
            // 포켓몬의 타입 확인 (캐시에 있으면 사용, 없으면 비동기 로드 필요)
            if (!typeCache.containsKey(pokemon.getPokemonId())) {
              return false; // 타입을 모르면 일단 표시하지 않음
            }

            // 포켓몬이 선택된 타입 중 하나라도 가지고 있으면 포함
            List<String> pokemonTypes = typeCache[pokemon.getPokemonId()]!;
            return _selectedTypes.any(
              (type) => pokemonTypes
                  .map((t) => t.toLowerCase())
                  .contains(type.toLowerCase()),
            );
          }).toList();
    }

    // 포켓몬 정렬 적용
    switch (_sortOption) {
      case SortOption.numberAscending:
        filtered.sort((a, b) => a.id.compareTo(b.id));
        break;
      case SortOption.numberDescending:
        filtered.sort((a, b) => b.id.compareTo(a.id));
        break;
      case SortOption.nameAscending:
        filtered.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
        break;
      case SortOption.nameDescending:
        filtered.sort(
          (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()),
        );
        break;
    }
    return filtered;
  }

  @override
  void dispose() {
    _textController.removeListener(_onSearchChanged);
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // 스크롤 상단으로 이동 버튼
  void scrollToTop() {
    if (scrollController.hasClients) {
      // 연결된 뷰가 있는지 확인
      scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // 키보드 내리기
  VoidCallback unfocusKeyboard(BuildContext context) {
    return () {
      if (!FocusScope.of(context).hasFocus) return;
      FocusScope.of(context).unfocus();
    };
  }

  // 스크롤 시 키보드 숨기기
  bool Function(ScrollNotification) handleScrollNotification(
    BuildContext context,
  ) {
    return (ScrollNotification notification) {
      if (notification is ScrollUpdateNotification) {
        // 스크롤 방향에 상관없이 키보드 숨기기
        if (notification.scrollDelta != null &&
            notification.scrollDelta != 0 &&
            FocusScope.of(context).hasFocus) {
          FocusScope.of(context).unfocus();
        }
      }
      return false;
    };
  }

  // 초기 Kanto 지방 로드
  Future<void> loadInitialPokemons() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final kantoPokemons = await _repository.getPokemonsByRegion('Kanto');
      print('Raw Kanto data from API: ${kantoPokemons.length} pokemons');
      _pokemons = kantoPokemons;
      _regionCache['Kanto'] = _pokemons;
      _selectedRegion = 'Kanto';
      print('Initial load completed: ${_pokemons.length} pokemons for Kanto');

      final regions = [
        'Johto',
        'Hoenn',
        'Sinnoh',
        'Unova',
        'Kalos',
        'Alola',
        'Galar',
        'Paldea',
        'Hisui',
      ];
      for (var region in regions) {
        await _preloadRegion(region);
      }
    } catch (e) {
      error = e.toString();
      print('Error loading initial pokemons: $e');
    } finally {
      isLoading = false;
      notifyListeners();
      preloadTypeCache();
    }
  }

  Future<void> _preloadRegion(String region) async {
    if (_regionCache.containsKey(region)) return;
    try {
      final pokemons = await _repository.getPokemonsByRegion(region);
      _regionCache[region] = pokemons;
      print('Preloaded $region: ${pokemons.length} pokemons');
    } catch (e) {
      print('Error preloading $region: $e');
    }
  }

  Future<void> loadPokemons() async {
    if (_regionCache.containsKey(_selectedRegion)) {
      _pokemons = _regionCache[_selectedRegion]!;
      print(
        'Loaded from cache: ${_pokemons.length} pokemons for $_selectedRegion',
      );
      notifyListeners();
      return;
    }

    isLoading = true;
    error = null;
    notifyListeners();
    try {
      _pokemons = await _repository.getPokemonsByRegion(_selectedRegion);
      _regionCache[_selectedRegion] = _pokemons;
      print('Refreshed ${_pokemons.length} pokemons for $_selectedRegion');
    } catch (e) {
      error = e.toString();
      print('Error refreshing pokemons: $e');
    } finally {
      isLoading = false;
      notifyListeners();
      preloadTypeCache();
    }
  }

  // 지역 선택
  void selectRegion(
    String region,
    VoidCallback scrollToTop,
    BuildContext context,
  ) async {
    _selectedRegion = region;
    _selectedTypes.clear();
    if (_regionCache.containsKey(region)) {
      _pokemons = _regionCache[region]!;
      print('Selected from cache: ${_pokemons.length} pokemons for $region');
      notifyListeners();
      scrollToTop();
      clearSearch();
    } else {
      await loadPokemons();
      scrollToTop();
      clearSearch();
    }
  }

  Future<List<String>> getPokemonTypes(int pokemonId) async {
    if (typeCache.containsKey(pokemonId)) {
      return typeCache[pokemonId]!;
    }

    final detail = await _repository.getPokemonDetail(pokemonId);
    typeCache[pokemonId] = detail.types;
    return detail.types;
  }

  Widget buildTypeChips(int pokemonId, BuildContext context) {
    return FutureBuilder<List<String>>(
      future: getPokemonTypes(pokemonId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(width: 60, height: 20);
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SizedBox(width: 60, height: 20);
        }

        // 타입 칩 생성
        final types = snapshot.data!;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children:
              types
                  .map(
                    (type) => Padding(
                      padding: const EdgeInsets.only(right: 3.0),
                      child: Chip(
                        label: Text(
                          getPokemonType(type),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color:
                                getTypeColor(type).computeLuminance() > 0.5
                                    ? Colors.black
                                    : Colors.white,
                          ),
                        ),
                        backgroundColor: getTypeColor(type),
                        labelPadding: EdgeInsets.symmetric(horizontal: 4),
                        padding: EdgeInsets.all(0),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  )
                  .toList(),
        );
      },
    );
  }

  // 포켓몬 타입 이름 가져오기
  String getPokemonType(String type) {
    return type.capitalize();
  }

  void updateLanguage(String newLanguage) {
    _selectedLanguage = newLanguage;
    notifyListeners();
  }

  // UI 관련 메서드들
  BoxDecoration getDrawerHeaderDecoration() {
    return const BoxDecoration(color: Color(0xFF702fc8));
  }

  TextStyle getRegionTextStyle() {
    return const TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
  }

  // 선택된 지역을 빨간색으로 표시
  TextStyle? getRegionTextColor(String region) {
    return region == _selectedRegion
        ? const TextStyle(
          color: Color(0xFF702fc8),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        )
        : TextStyle(
          color: _isDarkMode ? Colors.white : Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        );
  }

  // 설정 타일 색상 반환
  Color getSettingsTileColor(BuildContext context) {
    final isDark =
        Theme.of(context).colorScheme.surface.computeLuminance() <= 0.5;
    return isDark ? Colors.grey.shade800 : Colors.black12;
  }

  // 포켓몬 타입 색상 반환
  Color getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'normal':
        return Color(0xFFA8A77A);
      case 'fire':
        return Color(0xFFEE8130);
      case 'water':
        return Color(0xFF6390F0);
      case 'electric':
        return Color(0xFFF7D02C);
      case 'grass':
        return Color(0xFF7AC74C);
      case 'ice':
        return Color(0xFF96D9D6);
      case 'fighting':
        return Color(0xFFC22E28);
      case 'poison':
        return Color(0xFFA33EA1);
      case 'ground':
        return Color(0xFFE2BF65);
      case 'flying':
        return Color(0xFFA98FF3);
      case 'psychic':
        return Color(0xFFF95587);
      case 'bug':
        return Color(0xFFA6B91A);
      case 'rock':
        return Color(0xFFB6A136);
      case 'ghost':
        return Color(0xFF735797);
      case 'dragon':
        return Color(0xFF6F35FC);
      case 'dark':
        return Color(0xFF705746);
      case 'steel':
        return Color(0xFFB7B7CE);
      case 'fairy':
        return Color(0xFFD685AD);
      default:
        return Colors.grey;
    }
  }

  // 설정 다이얼로그 스타일
  BoxDecoration getSettingsHeaderDecoration() {
    return const BoxDecoration(
      color: Color(0xFF702fc8),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    );
  }

  TextStyle getSettingsTitleStyle() {
    return const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
  }

  TextStyle getSettingsItemStyle() {
    return const TextStyle(fontSize: 15, fontWeight: FontWeight.bold);
  }

  // 리스트 아이템 포켓몬 이름 스타일
  TextStyle getListItemStyle() {
    return const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  }

  EdgeInsets getListItemPadding() {
    return const EdgeInsets.symmetric(horizontal: 5);
  }

  String getPokemonImageUrl(int pokemonId) {
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$pokemonId.png';
  }

  // 네비게이션 메서드
  void navigateToDetail(BuildContext context, PokedexEntry pokemon) {
    final repository = Provider.of<PokemonRepository>(context, listen: false);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => Provider<PokemonRepository>.value(
              value: repository,
              child: PokedexScreen(pokedex: pokemon, isDarkMode: _isDarkMode),
            ),
      ),
    );
  }

  // 다크모드 상태 초기화
  void initDarkMode(bool isDark) {
    _isDarkMode = isDark;
    notifyListeners();
  }

  // 다크모드 토글
  void toggleDarkMode(bool value, Function(bool) onThemeChanged) {
    _isDarkMode = value;
    onThemeChanged(value);
    notifyListeners();
  }

  // 설정 다이얼로그 표시
  void showSettingsDialog(
    BuildContext context,
    bool isDarkMode,
    Function(bool) onThemeChanged,
  ) {
    // 다이얼로그가 열릴 때 현재 다크모드 상태 동기화
    initDarkMode(isDarkMode);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            titlePadding: EdgeInsets.zero,
            title: Container(
              decoration: getSettingsHeaderDecoration(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Settings', style: getSettingsTitleStyle()),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text('Dark Mode', style: getSettingsItemStyle()),
                    const Spacer(),
                    Switch(
                      activeColor: Color(0xFF702fc8),
                      value: _isDarkMode, // ViewModel의 상태 사용
                      onChanged:
                          (value) => toggleDarkMode(value, onThemeChanged),
                    ),
                  ],
                ),
                const Divider(height: 1, color: Colors.grey),
                Row(
                  children: [
                    Text('Language', style: getSettingsItemStyle()),
                    const Spacer(),
                    DropdownButton<String>(
                      value: selectedLanguage,
                      items:
                          ['English'].map((String lang) {
                            return DropdownMenuItem<String>(
                              value: lang,
                              child: Text(lang),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          updateLanguage(newValue);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }
}

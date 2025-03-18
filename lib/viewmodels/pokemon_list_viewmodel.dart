import 'package:flutter/material.dart';
import 'package:pokedex_app/models/pokedex_entry.dart';
import 'package:pokedex_app/models/pokemon_type_colors.dart';
import 'package:pokedex_app/repositories/pokemon_repository.dart';
import 'package:pokedex_app/views/screens/pokedex_screen.dart';
import 'package:provider/provider.dart';

class PokemonListViewModel with ChangeNotifier {
  final PokemonRepository _repository;
  List<PokedexEntry> _allPokemons = [];
  List<PokedexEntry> _pokemons = [];
  String _searchQuery = '';
  String _selectedRegion = 'Kanto'; // 기본 지역
  String _selectedLanguage = 'English';
  bool _isDarkMode = false; // 다크모드 상태 추가
  bool isLoading = true;
  String? error; // 에러 상태 추가
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final Map<int, List<String>> typeCache = {};

  // 생성자 변경
  PokemonListViewModel(this._repository) {
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
    notifyListeners();
  }

  // 검색 초기화 메서드
  void clearSearch() {
    _textController.clear();
    _searchQuery = '';
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

  // 필터링된 포켓몬 리스트
  List<PokedexEntry> get filteredPokemons {
    if (_searchQuery.isEmpty) {
      return _pokemons;
    }

    return _allPokemons
        .where(
          (pokemon) =>
              pokemon.name.toLowerCase().contains(_searchQuery) ||
              pokemon.id.toString().contains(_searchQuery),
        )
        .toList();
  }

  @override
  void dispose() {
    _textController.removeListener(_onSearchChanged);
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    } else {
      print('ScrollController is not attached to any scroll views.');
    }
  }

  VoidCallback unfocusKeyboard(BuildContext context) {
    return () {
      if (!FocusScope.of(context).hasFocus) return;
      FocusScope.of(context).unfocus();
    };
  }

  bool Function(ScrollNotification) handleScrollNotification(
    BuildContext context,
  ) {
    return (ScrollNotification notification) {
      if (notification is ScrollUpdateNotification) {
        // 스크롤 방향에 상관없이 스크롤이 발생하면 키보드 내리기
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
      _allPokemons = await _repository.getPokemonsByRegion('Kanto');
      _pokemons =
          _allPokemons
              .where((p) => _getRegionForPokemon(p.id) == _selectedRegion)
              .toList();
      print('Initial load: ${_pokemons.length} pokemons for $_selectedRegion');
      print('Total loaded: ${_allPokemons.length}');
      if (_allPokemons.length < 1025) {
        print('Warning: Not all pokemons loaded, expected 1025');
      }
    } catch (e) {
      error = e.toString();
      print('Error loading initial pokemons: $e');
      print('Stacktrace: ${StackTrace.current}');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 지역 선택
  void selectRegion(
    String region,
    VoidCallback scrollToTop,
    BuildContext context,
  ) async {
    _selectedRegion = region;
    isLoading = true;
    notifyListeners();
    try {
      if (_allPokemons.length < 1025 && region != 'Kanto') {
        _allPokemons = await _repository.getPokemonsByRegion(region); // 전체 로드
      }
      _pokemons =
          _allPokemons
              .where((p) => _getRegionForPokemon(p.id) == region)
              .toList();
      print('Selected $region - Pokemons: ${_pokemons.length}');
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
      scrollToTop();
      clearSearch();
    }
  }

  String _getRegionForPokemon(int id) {
    if (id <= 151) return 'Kanto';
    if (id <= 251) return 'Johto';
    if (id <= 386) return 'Hoenn';
    if (id <= 493) return 'Sinnoh';
    if (id <= 649) return 'Unova';
    if (id <= 721) return 'Kalos';
    if (id <= 809) return 'Alola';
    if (id <= 898) return 'Galar';
    if (id <= 905) return 'Hisui';
    if (id <= 1010) return 'Paldea';
    return 'Paldea';
  }

  Future<List<String>> getPokemonTypes(int pokemonId) async {
    // 캐시에 있으면 캐시에서 반환
    if (typeCache.containsKey(pokemonId)) {
      return typeCache[pokemonId]!;
    }

    final detail = await _repository.getPokemonDetail(pokemonId);
    typeCache[pokemonId] = detail.types; // 캐시에 저장
    return detail.types;
  }

  Widget buildTypeChips(int pokemonId, BuildContext context) {
    return FutureBuilder<List<String>>(
      future: getPokemonTypes(pokemonId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(width: 60, height: 20); // 로딩 중 빈 공간
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SizedBox(width: 60, height: 20); // 데이터 없을 때 빈 공간
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
    return const BoxDecoration(color: Colors.red);
  }

  TextStyle getRegionTextStyle() {
    return const TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
  }

  // 선택된 지역을 빨간색으로 표시
  TextStyle? getRegionTextColor(String region) {
    return region == _selectedRegion
        ? const TextStyle(
          color: Colors.red,
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
      color: Colors.red,
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
                      activeColor: Colors.red,
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
                          ['English', '한국어'].map((String lang) {
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

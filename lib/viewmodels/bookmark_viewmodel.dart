// lib/viewmodels/bookmark_viewmodel.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pokedex_app/models/pokedex_entry.dart';
import 'package:pokedex_app/models/pokemon_type_colors.dart';
import 'package:pokedex_app/repositories/pokemon_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 정렬 방식 열거형
enum BookmarkSortOption {
  dateAddedNewest, // 추가 시간 내림차순(최신순)
  dateAddedOldest, // 추가 시간 오름차순(오래된순)
  numberAscending, // 번호 오름차순 (기본값)
  numberDescending, // 번호 내림차순
  nameAscending, // 이름 오름차순
  nameDescending, // 이름 내림차순
}

// 북마크된 포켓몬 아이템 클래스
class BookmarkedItem {
  final PokedexEntry pokemon;
  final DateTime dateAdded;

  BookmarkedItem({required this.pokemon, required this.dateAdded});

  factory BookmarkedItem.fromJson(Map<String, dynamic> json) {
    return BookmarkedItem(
      pokemon: PokedexEntry(
        id: json['pokemon']['id'],
        name: json['pokemon']['name'],
        url: json['pokemon']['url'],
      ),
      dateAdded: DateTime.parse(json['dateAdded']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pokemon': pokemon.toJson(),
      'dateAdded': dateAdded.toIso8601String(),
    };
  }
}

class BookmarkViewModel with ChangeNotifier {
  final PokemonRepository repository;
  final List<BookmarkedItem> _bookmarkedItems = [];
  bool _isInitialized = false;

  // 검색 관련 변수들 추가
  final TextEditingController textController = TextEditingController();
  String _searchQuery = '';

  // 정렬 관련 변수
  BookmarkSortOption _sortOption =
      BookmarkSortOption.numberAscending; // 기본값: 번호 오름차순

  // 타입 캐시 추가
  final Map<int, List<String>> _typeCache = {};

  BookmarkViewModel({required this.repository}) {
    _init();
    // 검색어 변경 리스너 추가
    textController.addListener(_onSearchChanged);
  }

  // 정렬 옵션 getter
  BookmarkSortOption get sortOption => _sortOption;

  // 정렬 옵션 업데이트 메서드
  void updateSortOption(BookmarkSortOption option) {
    _sortOption = option;
    notifyListeners();
  }

  // 검색어 변경 감지 메서드
  void _onSearchChanged() {
    updateSearchQuery(textController.text);
  }

  // 검색어 업데이트 메서드
  void updateSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  // 검색 초기화 메서드
  void clearSearch() {
    textController.clear();
    _searchQuery = '';
    notifyListeners();
  }

  // 북마크된 포켓몬 목록 getter (BookmarkedItem에서 PokedexEntry 추출)
  List<PokedexEntry> get bookmarkedPokemons {
    // 초기화되지 않았으면 빈 리스트 반환
    if (!_isInitialized) return [];

    // 먼저 BookmarkedItem 리스트 필터링 및 정렬
    List<BookmarkedItem> filteredItems = _getFilteredAndSortedItems();

    // 필터링 및 정렬된 BookmarkedItem에서 PokedexEntry만 추출하여 반환
    return List.unmodifiable(
      filteredItems.map((item) => item.pokemon).toList(),
    );
  }

  // 필터링 및 정렬된 BookmarkedItem 목록 반환
  List<BookmarkedItem> _getFilteredAndSortedItems() {
    // 검색 필터링
    List<BookmarkedItem> filtered =
        _searchQuery.isEmpty
            ? List.from(_bookmarkedItems)
            : _bookmarkedItems
                .where(
                  (item) =>
                      item.pokemon.name.toLowerCase().contains(_searchQuery) ||
                      item.pokemon.id.toString().contains(_searchQuery),
                )
                .toList();

    // 정렬 적용
    switch (_sortOption) {
      case BookmarkSortOption.numberAscending:
        filtered.sort((a, b) => a.pokemon.id.compareTo(b.pokemon.id));
        break;
      case BookmarkSortOption.numberDescending:
        filtered.sort((a, b) => b.pokemon.id.compareTo(a.pokemon.id));
        break;
      case BookmarkSortOption.nameAscending:
        filtered.sort(
          (a, b) => a.pokemon.name.toLowerCase().compareTo(
            b.pokemon.name.toLowerCase(),
          ),
        );
        break;
      case BookmarkSortOption.nameDescending:
        filtered.sort(
          (a, b) => b.pokemon.name.toLowerCase().compareTo(
            a.pokemon.name.toLowerCase(),
          ),
        );
        break;
      case BookmarkSortOption.dateAddedNewest:
        filtered.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
        break;
      case BookmarkSortOption.dateAddedOldest:
        filtered.sort((a, b) => a.dateAdded.compareTo(b.dateAdded));
        break;
    }

    return filtered;
  }

  // 북마크 원본 목록 (필터링 전)
  List<PokedexEntry> get allBookmarkedPokemons {
    return List.unmodifiable(
      _bookmarkedItems.map((item) => item.pokemon).toList(),
    );
  }

  @override
  void dispose() {
    textController.removeListener(_onSearchChanged);
    textController.dispose();
    super.dispose();
  }

  // 초기화 메서드
  Future<void> _init() async {
    try {
      await _loadBookmarks();
    } catch (e) {
      print("북마크 로드 실패: $e");
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  // 북마크 로드
  Future<void> _loadBookmarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? bookmarkData = prefs.getString('bookmarked_pokemons');

      if (bookmarkData != null && bookmarkData.isNotEmpty) {
        final List<dynamic> jsonList = jsonDecode(bookmarkData);
        _bookmarkedItems.clear();

        // 형식 확인 및 변환
        if (jsonList.isNotEmpty &&
            jsonList[0] is Map &&
            jsonList[0].containsKey('dateAdded')) {
          // 새 형식 (BookmarkedItem)
          _bookmarkedItems.addAll(
            jsonList.map((json) => BookmarkedItem.fromJson(json)).toList(),
          );
        } else {
          // 기존 형식 (PokedexEntry)에서 변환 - 현재 시간 사용
          _bookmarkedItems.addAll(
            jsonList
                .map(
                  (json) => BookmarkedItem(
                    pokemon: PokedexEntry(
                      id: json['id'],
                      name: json['name'],
                      url: json['url'],
                    ),
                    dateAdded: DateTime.now(),
                  ),
                )
                .toList(),
          );
        }
      }
    } catch (e) {
      print("북마크 데이터 파싱 오류: $e");
    }
  }

  // 북마크 저장
  Future<void> _saveBookmarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = _bookmarkedItems.map((item) => item.toJson()).toList();
      await prefs.setString('bookmarked_pokemons', jsonEncode(jsonList));
    } catch (e) {
      print("북마크 저장 오류: $e");
    }
  }

  // 북마크 추가/제거
  Future<void> toggleBookmark(PokedexEntry pokemon) async {
    if (isBookmarked(pokemon)) {
      _bookmarkedItems.removeWhere((item) => item.pokemon.id == pokemon.id);
    } else {
      _bookmarkedItems.add(
        BookmarkedItem(pokemon: pokemon, dateAdded: DateTime.now()),
      );
    }
    await _saveBookmarks();
    notifyListeners();
  }

  // 북마크 여부 확인
  bool isBookmarked(PokedexEntry pokemon) {
    return _bookmarkedItems.any((item) => item.pokemon.id == pokemon.id);
  }

  // 포켓몬 타입 가져오기
  Future<List<String>> getPokemonTypes(int pokemonId) async {
    // 캐시에 있으면 캐시에서 반환
    if (_typeCache.containsKey(pokemonId)) {
      return _typeCache[pokemonId]!;
    }

    final detail = await repository.getPokemonDetail(pokemonId);
    _typeCache[pokemonId] = detail.types; // 캐시에 저장
    return detail.types;
  }

  // 타입 칩 위젯 생성
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
                          type.capitalize(),
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

  TextStyle getSearchTextStyle(BuildContext context) {
    final isDark =
        Theme.of(context).colorScheme.surface.computeLuminance() <= 0.5;
    return TextStyle(color: isDark ? Colors.white : Colors.black);
  }

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
}

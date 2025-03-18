// lib/views/screens/bookmark_screen.dart
import 'package:flutter/material.dart';
import 'package:poke_master/viewmodels/bookmark_viewmodel.dart';
import 'package:poke_master/viewmodels/pokemon_list_viewmodel.dart';
import 'package:provider/provider.dart';

class BookmarkScreen extends StatelessWidget {
  final bool isDarkMode;

  const BookmarkScreen({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF702fc8),
        centerTitle: true,
        title: Image.asset('assets/bookmark.png', width: 170),
        iconTheme: IconThemeData(color: Colors.white, size: 30),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.chevron_left_rounded, size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          InkWell(
            onTap: () {
              // 정렬 옵션 다이얼로그 표시
              _showSortOptionsDialog(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Icon(Icons.sort_rounded, size: 40),
            ),
          ),
        ],
      ),
      body: Consumer<BookmarkViewModel>(
        builder: (context, bookmarkViewModel, child) {
          return Column(
            children: [
              // 검색창 추가
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: TextField(
                  controller: bookmarkViewModel.textController,
                  onChanged: bookmarkViewModel.updateSearchQuery,
                  style: bookmarkViewModel.getSearchTextStyle(context),
                  decoration: bookmarkViewModel.getSearchDecoration(context),
                ),
              ),
              SizedBox(height: 12),

              // 북마크 목록 (Expanded로 감싸야 함)
              Expanded(child: _buildBookmarkList(context, bookmarkViewModel)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBookmarkList(
    BuildContext context,
    BookmarkViewModel bookmarkViewModel,
  ) {
    final bookmarks = bookmarkViewModel.bookmarkedPokemons;

    if (bookmarks.isEmpty) {
      // 북마크가 없거나 검색 결과가 없는 경우
      if (bookmarkViewModel.allBookmarkedPokemons.isEmpty) {
        // 북마크가 아예 없는 경우
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/pokeball_icon_shade.png',
                width: 100,
                height: 100,
              ),
              SizedBox(height: 20),
              Text(
                'Empty Pokéball',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Add Pokémon to your bookmarks\nfrom the Pokédex screen',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      } else {
        // 검색 결과가 없는 경우
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/pikachu_shadow.png', width: 100, height: 100),
              SizedBox(height: 20),
              Text(
                'No Pokémon found',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Try a different search term',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ],
          ),
        );
      }
    }

    // RefreshIndicator로 ListView를 감싸 당겨서 새로고침 기능 추가 및 스크롤 시 키보드 숨김처리
    return NotificationListener<ScrollNotification>(
      onNotification: handleScrollNotification(context),
      child: RefreshIndicator(
        color: Color(0xFF702fc8),
        onRefresh: () async {
          await bookmarkViewModel.refreshBookmarks();
        },
        child: ListView.separated(
          itemCount: bookmarks.length,
          separatorBuilder:
              (context, index) => Divider(height: 1, color: Colors.grey),
          itemBuilder: (context, index) {
            final pokemon = bookmarks[index];

            // Dismissible 위젯으로 감싸서 스와이프 삭제 기능 구현
            return Dismissible(
              key: Key(pokemon.id.toString()),
              background: Container(
                color: Color(0xFF702fc8),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.delete, color: Colors.white),
              ),
              direction: DismissDirection.startToEnd, // 왼쪽에서 오른쪽으로 스와이프
              onDismissed: (direction) {
                bookmarkViewModel.toggleBookmark(pokemon);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Color(0xFF702fc8),
                    content: Center(
                      child: Text(
                        '${pokemon.name.capitalize()} removed from Pokéball',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(milliseconds: 500),
                  ),
                );
              },
              child: InkWell(
                onTap: () {
                  final listViewModel = Provider.of<PokemonListViewModel>(
                    context,
                    listen: false,
                  );
                  listViewModel.navigateToDetail(context, pokemon);
                },
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 5),
                  leading: Image.network(
                    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${pokemon.getPokemonId()}.png',
                    width: 60,
                    height: 80,
                    errorBuilder:
                        (context, error, stackTrace) => Image.asset(
                          'assets/pokeball_error.png',
                          width: 80,
                          height: 80,
                        ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '${pokemon.id}. ${pokemon.name.capitalize()}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      bookmarkViewModel.buildTypeChips(
                        pokemon.getPokemonId(),
                        context,
                      ),
                      Icon(Icons.chevron_right, size: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // 스크롤 시 키보드 숨기기
  bool Function(ScrollNotification) handleScrollNotification(
    BuildContext context,
  ) {
    return (ScrollNotification notification) {
      if ((notification is ScrollUpdateNotification ||
              notification is ScrollStartNotification) &&
          FocusScope.of(context).hasFocus) {
        FocusScope.of(context).unfocus();
      }
      return false;
    };
  }

  // 정렬 옵션 다이얼로그
  void _showSortOptionsDialog(BuildContext context) {
    final bookmarkViewModel = Provider.of<BookmarkViewModel>(
      context,
      listen: false,
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            titlePadding: EdgeInsets.zero,
            title: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Color(0xFF702fc8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  Image.asset('assets/sort_title.png', fit: BoxFit.contain),

                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSortOptionTile(
                  context,
                  bookmarkViewModel,
                  'First Added',
                  BookmarkSortOption.dateAddedNewest,
                  Icons.access_time,
                ),
                Divider(height: 1, color: Colors.grey),
                _buildSortOptionTile(
                  context,
                  bookmarkViewModel,
                  'Lastly Added',
                  BookmarkSortOption.dateAddedOldest,
                  Icons.history,
                ),
                Divider(height: 1, color: Colors.grey),
                _buildSortOptionTile(
                  context,
                  bookmarkViewModel,
                  'Number (Ascending)',
                  BookmarkSortOption.numberAscending,
                  Icons.arrow_upward,
                ),
                Divider(height: 1, color: Colors.grey),
                _buildSortOptionTile(
                  context,
                  bookmarkViewModel,
                  'Number (Descending)',
                  BookmarkSortOption.numberDescending,
                  Icons.arrow_downward,
                ),
                Divider(height: 1, color: Colors.grey),
                _buildSortOptionTile(
                  context,
                  bookmarkViewModel,
                  'Name (A to Z)',
                  BookmarkSortOption.nameAscending,
                  Icons.sort_by_alpha,
                ),
                Divider(height: 1, color: Colors.grey),
                _buildSortOptionTile(
                  context,
                  bookmarkViewModel,
                  'Name (Z to A)',
                  BookmarkSortOption.nameDescending,
                  Icons.sort_by_alpha,
                ),
              ],
            ),
          ),
    );
  }

  // 정렬 옵션 타일
  Widget _buildSortOptionTile(
    BuildContext context,
    BookmarkViewModel viewModel,
    String title,
    BookmarkSortOption option,
    IconData icon,
  ) {
    final isSelected = viewModel.sortOption == option;
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Color(0xFF702fc8) : null,
        ),
      ),
      leading: Icon(icon, color: isSelected ? Color(0xFF702fc8) : null),
      trailing:
          isSelected
              ? Icon(Icons.check_circle, color: Color(0xFF702fc8))
              : null,
      onTap: () {
        viewModel.updateSortOption(option);
        // 정렬 옵션 선택 후 다이얼로그 닫기
        Navigator.pop(context);
      },
    );
  }
}

// String 확장 메서드가 없을 경우 추가
extension StringCapitalizeExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

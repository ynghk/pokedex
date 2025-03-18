// lib/views/screens/bookmark_screen.dart
import 'package:flutter/material.dart';
import 'package:pokedex_app/viewmodels/bookmark_viewmodel.dart';
import 'package:pokedex_app/viewmodels/pokemon_list_viewmodel.dart';
import 'package:provider/provider.dart';

class BookmarkScreen extends StatelessWidget {
  final bool isDarkMode;

  const BookmarkScreen({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
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
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Icon(Icons.sort_rounded, size: 40),
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

    return ListView.separated(
      itemCount: bookmarks.length,
      separatorBuilder:
          (context, index) => Divider(height: 1, color: Colors.grey),
      itemBuilder: (context, index) {
        final pokemon = bookmarks[index];

        // Dismissible 위젯으로 감싸서 스와이프 삭제 기능 구현
        return Dismissible(
          key: Key(pokemon.id.toString()),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.startToEnd, // 왼쪽에서 오른쪽으로 스와이프
          onDismissed: (direction) {
            bookmarkViewModel.toggleBookmark(pokemon);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
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

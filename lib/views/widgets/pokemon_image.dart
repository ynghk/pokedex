//포켓몬 이미지 클래스 분리
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex_app/models/pokedex_entry.dart';

class PokemonImage extends StatelessWidget {
  final String imageUrl; // 이미지 URL 전달
  final bool isShiny; // 이로치 상태 전달
  final VoidCallback onToggleShiny; // 버튼 콜백 전달
  final PokedexEntry pokedex;

  const PokemonImage({
    super.key,
    required this.imageUrl,
    required this.isShiny,
    required this.onToggleShiny,
    required this.pokedex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: CachedNetworkImage(
              imageUrl: imageUrl,

              placeholder:
                  (context, url) => const Center(
                    child: CircularProgressIndicator(
                      constraints: BoxConstraints.tightFor(
                        width: 80,
                        height: 80,
                      ),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.blueAccent,
                      ),
                    ),
                  ),
              errorWidget:
                  (context, url, error) =>
                      Image.asset('assets/pokeball_error.png'),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              icon: Image.asset(
                isShiny
                    ? 'assets/shiny_on_icon.png'
                    : 'assets/shiny_off_icon.png',
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
              onPressed: onToggleShiny,
            ),
          ),
          // Positioned(
          //   top: 10,
          //   left: 10,
          //   child: Consumer<BookmarkViewModel>(
          //     builder: (context, bookmarkViewModel, child) {
          //       return InkWell(
          //         splashColor: Colors.transparent,
          //         onTap: () => bookmarkViewModel.toggleBookmark(pokedex),
          //         child: Padding(
          //           padding: const EdgeInsets.only(right: 12.0),
          //           child: Image.asset(
          //             bookmarkViewModel.isBookmarked(pokedex)
          //                 ? 'assets/bookmark_pokeball.png'
          //                 : 'assets/bookmark_pokeball_shadow.png',
          //             width: 50,
          //             height: 50,
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex_app/models/pokemon_list_result.dart';
import 'package:pokedex_app/utils/string_utils.dart';

class PokemonDetailScreen extends StatefulWidget {
  final PokemonListResult pokemon;

  const PokemonDetailScreen({super.key, required this.pokemon});

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  final ShinyPokemon shinyPokemon = ShinyPokemon();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          widget.pokemon.name.capitalize(),
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(128),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  // 길어질 수 있는 이미지 로딩 시간을 Image.network 대신 CachedNetworkImage로 미리 로컬에 이미지를 로드시킴
                  CachedNetworkImage(
                    imageUrl: shinyPokemon.getPokemonImageUrl(widget.pokemon),
                    width: 400,
                    height: 400,
                    fit: BoxFit.contain,
                    placeholder:
                        (context, url) => Center(
                          child: CircularProgressIndicator(
                            constraints: BoxConstraints.tightFor(
                              width: 80,
                              height: 80,
                            ),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.blueAccent,
                            ),
                          ),
                        ), //이미지 로딩중 프로그레스바 나타냄
                    // 이미지를 불러오지 못했을 경우 에러표시
                    errorWidget: (context, url, error) {
                      return Image.asset(
                        'assets/pokeball_error.png',
                        width: 400,
                        fit: BoxFit.contain,
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    // 이로치 포켓몬 이미지 전환 활성화 버튼 위해 우측 상단 배치
                    child: IconButton(
                      icon: Image.asset(
                        shinyPokemon.isShiny
                            ? 'assets/shiny_on_icon.png'
                            : 'assets/shiny_off_icon.png',
                        width: 30,
                        height: 30,
                        fit: BoxFit.contain,
                      ),
                      onPressed: () {
                        setState(() {
                          shinyPokemon.toggleShiny();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Text(
              'No. ${widget.pokemon.getPokemonId()}',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Text(
              'Name: ${widget.pokemon.name.capitalize()}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            // 타입, 약점, 스탯, 설명, 진화, 특성 PokeAPI에서 더 가져와야 함
          ],
        ),
      ),
    );
  }
}

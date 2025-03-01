import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex_app/models/pokedex_entry.dart';
import 'package:pokedex_app/models/pokemon_detail.dart';
import 'package:pokedex_app/services/api_service.dart';
import 'package:pokedex_app/utils/string_utils.dart';

class PokemonDetailScreen extends StatefulWidget {
  final PokedexEntry pokedex;

  const PokemonDetailScreen({super.key, required this.pokedex});

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  final ShinyPokemon shinyPokemon = ShinyPokemon();
  late Future<PokemonDetail> _pokemonDetail;

  @override
  void initState() {
    super.initState();
    _pokemonDetail = ApiService().getPokemonDetail(widget.pokedex.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PokemonDetail>(
      future: _pokemonDetail,
      builder: (context, snapshot) {
        // 데이터가 없으면 기본 AppBar와 로딩 표시
        Color appBarColor = Colors.red; // 기본값
        Color textColor = Colors.black;
        if (snapshot.hasData) {
          appBarColor =
              pokemonTypeColors[snapshot.data!.types[0].toLowerCase()] ??
              Colors.red;
          textColor =
              appBarColor.computeLuminance() > 0.5
                  ? Colors.black
                  : Colors.white;
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: appBarColor, // 동적 색상 적용
            title: Text(
              widget.pokedex.name.capitalize(),
              style: TextStyle(
                color: textColor,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body:
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(child: CircularProgressIndicator())
                  : snapshot.hasError
                  ? Center(child: Text('Error: ${snapshot.error}'))
                  : Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
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
                                  imageUrl: shinyPokemon.getPokemonImageUrl(
                                    widget.pokedex,
                                  ),
                                  width: 350,
                                  height: 350,
                                  fit: BoxFit.contain,
                                  placeholder:
                                      (context, url) => Center(
                                        child: CircularProgressIndicator(
                                          constraints: BoxConstraints.tightFor(
                                            width: 80,
                                            height: 80,
                                          ),
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.blueAccent,
                                              ),
                                        ),
                                      ), //이미지 로딩중 프로그레스바 나타냄
                                  // 이미지를 불러오지 못했을 경우 에러표시
                                  errorWidget: (context, url, error) {
                                    return Image.asset(
                                      'assets/pokeball_error.png',
                                      width: 350,
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
                        ),
                        const SizedBox(height: 30),

                        Text(
                          'Height: ${snapshot.data!.height / 10}m, Weight: ${snapshot.data!.weight / 10}kg',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 12),

                        RichText(
                          text: TextSpan(
                            text: 'Types: ',
                            style: const TextStyle(
                              fontSize: 28,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                            children:
                                snapshot.data!.types
                                    .join(', ')
                                    .toTypeColoredText(),
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          'Ability: ------',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          '-Description- \n${snapshot.data!.flavorText}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text('--------Evolution-------'),
                      ],
                    ),
                  ),
        );
      },
    );
  }
}

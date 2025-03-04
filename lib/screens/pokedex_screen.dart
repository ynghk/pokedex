import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex_app/models/evolution_stage.dart';
import 'package:pokedex_app/models/pokedex_entry.dart';
import 'package:pokedex_app/models/pokemon_detail.dart';
import 'package:pokedex_app/services/api_service.dart';
import 'package:pokedex_app/utils/string_utils.dart';

class PokedexScreen extends StatefulWidget {
  final PokedexEntry pokedex;

  const PokedexScreen({super.key, required this.pokedex});

  @override
  State<PokedexScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokedexScreen> {
  final ShinyPokemon shinyPokemon = ShinyPokemon();
  late Future<PokemonDetail> _pokemonDetail;
  late Future<List<EvolutionStage>> _evolutionChain;

  @override
  void initState() {
    super.initState();
    _pokemonDetail = ApiService().getPokemonDetail(widget.pokedex.id);
    _evolutionChain = ApiService().getEvolutionChainForPokemon(
      widget.pokedex.id,
    );
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
              'No.${widget.pokedex.id} ${widget.pokedex.name.capitalize()}',
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
                  : SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Center(
                            child: PokemonImage(
                              imageUrl: shinyPokemon.getPokemonImageUrl(
                                widget.pokedex,
                              ),
                              isShiny: shinyPokemon.isShiny,
                              onToggleShiny: () {
                                setState(() {
                                  shinyPokemon.toggleShiny();
                                });
                              },
                            ),
                          ),
                        ),

                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  child: Text(
                                    'Height: ${snapshot.data!.height / 10}m, Weight: ${snapshot.data!.weight / 10}kg',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'Types: ',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      children:
                                          snapshot.data!.types
                                              .join(', ')
                                              .toTypeColoredText(),
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 5.0,
                                    left: 15,
                                    right: 15,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Text(
                                              '-Ability-',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),

                                          const SizedBox(height: 10),
                                          Center(
                                            child: Text(
                                              snapshot.data!.abilities,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 5.0,
                                    left: 15,
                                    right: 15,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Text(
                                              '-Description-',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),

                                          const SizedBox(height: 10),
                                          Text(
                                            snapshot.data!.flavorText,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 5,
                                    left: 15,
                                    right: 15,
                                    bottom: 15,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: EvolutionStageWidget(
                                      evolutionChain: _evolutionChain,
                                      currentPokemonId: widget.pokedex.id,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
        );
      },
    );
  }
}

class EvolutionStageWidget extends StatelessWidget {
  const EvolutionStageWidget({
    super.key,
    required this.evolutionChain,
    required this.currentPokemonId,
  });

  final Future<List<EvolutionStage>> evolutionChain;
  final int currentPokemonId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EvolutionStage>>(
      future: evolutionChain,
      builder: (context, evoSnapshot) {
        if (evoSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: const CircularProgressIndicator());
        }
        if (evoSnapshot.hasError) {
          return Text('Evolution Error: ${evoSnapshot.error}');
        }
        final stages = evoSnapshot.data!;
        final base = stages[0];

        final currentEvolution = stages.firstWhere(
          (stage) => stage.id == currentPokemonId,
        );
        final currentIndex = stages.indexWhere(
          (stage) => stage.id == currentPokemonId,
        );
        final isBasePokemon = currentIndex == 0; // 1차 포켓몬인지 확인
        final isEeveeEvolution =
            stages.length > 2 &&
            base.name.toLowerCase() == 'eevee'; // 이브이 계열인지 확인

        // 표시할 진화 단계 결정
        List<EvolutionStage> displayStages;
        if (isEeveeEvolution) {
          if (currentPokemonId == base.id) {
            displayStages = stages;
          } else {
            displayStages = [base, currentEvolution];
          }
        } else if (isBasePokemon) {
          // 1차 포켓몬: 모든 단계 표시
          displayStages = stages;
        } else {
          // 중간/최종 진화체: 1차부터 현재까지 표시
          displayStages = stages;
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              '-Evolution-',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (isEeveeEvolution &&
                currentPokemonId == base.id) // Eevee 클릭 시 분기형
              Column(
                children: [
                  Column(
                    children: [
                      Image.network(
                        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${base.id}.png',
                        width: 80,
                        height: 80,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                Image.asset('assets/pokeball_error.png'),
                      ),
                      Text(
                        base.name.capitalize(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      Icon(
                        Icons.arrow_downward_rounded,
                        size: 30,
                        color: Colors.black,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  // 분기 진화 표시
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      childAspectRatio: 1,
                      physics: NeverScrollableScrollPhysics(),
                      children:
                          stages.sublist(1).map((stage) {
                            return Column(
                              children: [
                                Image.network(
                                  'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${stage.id}.png',
                                  width: 80,
                                  height: 80,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          Image.asset(
                                            'assets/pokeball_error.png',
                                            width: 80,
                                          ),
                                ),
                                Text(
                                  stage.name.capitalize(),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '(${stage.item ?? 'Lv.${stage.minLevel}'})',
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ],
                            );
                          }).toList(),
                    ),
                  ),
                ],
              )
            else // 선형 진화
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    displayStages.map((stage) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            children: [
                              Image.network(
                                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${stage.id}.png',
                                width: 80,
                                height: 80,
                                errorBuilder:
                                    (context, error, stackTrace) => Image.asset(
                                      'assets/pokeball_error.png',
                                      width: 80,
                                    ),
                              ),
                              Text(
                                stage.name.capitalize(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (stage != base)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0,
                                  ),
                                  child: Text(
                                    '(${stage.item ?? 'Lv.${stage.minLevel}'})',
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ),
                            ],
                          ),
                          if (stage != displayStages.last)
                            Icon(Icons.arrow_forward_rounded, size: 30),
                        ],
                      );
                    }).toList(),
              ),
          ],
        );
      },
    );
  }
}

//포켓몬 이미지 클래스 분리
class PokemonImage extends StatelessWidget {
  final String imageUrl; // 이미지 URL 전달
  final bool isShiny; // 이로치 상태 전달
  final VoidCallback onToggleShiny; // 버튼 콜백 전달

  const PokemonImage({
    super.key,
    required this.imageUrl,
    required this.isShiny,
    required this.onToggleShiny,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(128),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            width: 400,
            height: 380,
            fit: BoxFit.contain,
            placeholder:
                (context, url) => const Center(
                  child: CircularProgressIndicator(
                    constraints: BoxConstraints.tightFor(width: 80, height: 80),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.blueAccent,
                    ),
                  ),
                ),
            errorWidget:
                (context, url, error) => Image.asset(
                  'assets/pokeball_error.png',
                  width: 350,
                  fit: BoxFit.contain,
                ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: IconButton(
              icon: Image.asset(
                isShiny
                    ? 'assets/shiny_on_icon.png'
                    : 'assets/shiny_off_icon.png',
                width: 30,
                height: 30,
                fit: BoxFit.contain,
              ),
              onPressed: onToggleShiny,
            ),
          ),
        ],
      ),
    );
  }
}

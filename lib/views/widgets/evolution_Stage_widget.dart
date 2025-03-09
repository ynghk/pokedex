import 'package:flutter/material.dart';
import 'package:pokedex_app/models/evolution_stage.dart';
import 'package:pokedex_app/utils/string_utils.dart';

class EvolutionStageWidget extends StatelessWidget {
  const EvolutionStageWidget({
    super.key,
    required this.evolutionChain,
    required this.currentPokemonId,
  });

  final List<EvolutionStage>? evolutionChain;
  final int currentPokemonId;

  @override
  Widget build(BuildContext context) {
    if (evolutionChain == null || evolutionChain!.isEmpty) {
      return Text('No evolution data available');
    }
    final stages = evolutionChain!;
    final base = stages[0];

    final currentEvolution = stages.firstWhere(
      (stage) => stage.id == currentPokemonId,
    );
    final currentIndex = stages.indexWhere(
      (stage) => stage.id == currentPokemonId,
    );
    final isBasePokemon = currentIndex == 0; // 1차 포켓몬인지 확인
    final isEeveeEvolution =
        stages.length > 2 && base.name.toLowerCase() == 'eevee'; // 이브이 계열인지 확인

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
        Text(
          '-Evolution-',
          style: TextStyle(
            color:
                Theme.of(context).colorScheme.surface.computeLuminance() > 0.5
                    ? Colors.black
                    : Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (isEeveeEvolution && currentPokemonId == base.id) // Eevee 클릭 시 분기형
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
                    style: TextStyle(
                      color:
                          Theme.of(
                                    context,
                                  ).colorScheme.surface.computeLuminance() >
                                  0.5
                              ? Colors.black
                              : Colors.white,
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
                                  (context, error, stackTrace) => Image.asset(
                                    'assets/pokeball_error.png',
                                    width: 80,
                                  ),
                            ),
                            Text(
                              stage.name.capitalize(),
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.surface
                                                .computeLuminance() >
                                            0.5
                                        ? Colors.black
                                        : Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '(${stage.item ?? 'Lv.${stage.minLevel}'})',
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.surface
                                                .computeLuminance() >
                                            0.5
                                        ? Colors.black
                                        : Colors.white,
                                fontSize: 10,
                              ),
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
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.surface
                                              .computeLuminance() >
                                          0.5
                                      ? Colors.black
                                      : Colors.white,
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
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.surface
                                                  .computeLuminance() >
                                              0.5
                                          ? Colors.black
                                          : Colors.white,
                                  fontSize: 10,
                                ),
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
  }
}

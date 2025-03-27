import 'package:flutter/material.dart';
import 'package:poke_master/models/evolution_stage.dart';
import 'package:poke_master/models/pokemon_type_colors.dart';
import 'package:poke_master/models/pokedex_entry.dart';
import 'package:poke_master/viewmodels/pokemon_detail_viewmodel.dart';
import 'package:poke_master/views/screens/pokedex_screen.dart';
import 'package:provider/provider.dart';

class EvolutionStageWidget extends StatelessWidget {
  const EvolutionStageWidget({
    super.key,
    required this.evolutionChain,
    required this.currentPokemonId,
  });

  final List<EvolutionStage>? evolutionChain;
  final int currentPokemonId;

  // ViewModel에 의존하지 않는 직접 네비게이션 메서드
  void _navigateToEvolution(BuildContext context, EvolutionStage evolution) {
    final isDark =
        Theme.of(context).colorScheme.surface.computeLuminance() <= 0.5;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => PokedexScreen(
              pokedex: PokedexEntry(
                id: evolution.id,
                name: evolution.name,
                url:
                    'https://pokeapi.co/api/v2/pokemon-species/${evolution.id}/',
              ),
              isDarkMode: isDark,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ViewModel 가져오기
    final viewModel = Provider.of<PokemonDetailViewModel>(context);

    if (evolutionChain == null || evolutionChain!.isEmpty) {
      return Text(
        'No evolution data available',
        style: viewModel.getTextStyle(context),
        textAlign: TextAlign.center,
      );
    }

    final stages = evolutionChain!;
    final base = stages[0];

    // 현재 포켓몬 진화 정보
    final currentIndex = stages.indexWhere(
      (stage) => stage.id == currentPokemonId,
    );
    // 인덱스를 찾지 못했거나, stages 비어있으면 base 사용
    final currentEvolution = currentIndex >= 0 ? stages[currentIndex] : base;

    // 이브이 특별 케이스는 이미 화면에서 처리됨
    final isEevee = base.name.toLowerCase() == 'eevee';
    if (isEevee && base.id == currentPokemonId) {
      // 이브이는 이미 별도 처리되어 이 위젯이 호출되지 않음
      return const Center(child: Text("Eevee's evolutions"));
    }

    // 선형 진화 표시 (간소화 버전)
    // 1. 이브이 진화형이면 [이브이 -> 현재 포켓몬] 만 표시
    // 2. 일반 포켓몬은 표준 진화 라인 표시
    final displayStages = isEevee ? [base, currentEvolution] : stages;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:
            displayStages.map((stage) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      // 현재 포켓몬이 아닌 경우에만 탐색
                      if (stage.id != currentPokemonId) {
                        // ViewModel 대신 로컬 메서드 사용
                        _navigateToEvolution(context, stage);
                      }
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 이미지
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

                        // 포켓몬 이름
                        Text(
                          stage.name.capitalize(),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: viewModel.getTextStyle(
                            context,
                            fontSize: 12,
                            isBold: true,
                          ),
                        ),

                        // 진화 조건 (첫 번째가 아니면)
                        if (stage != base)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
                            child: Text(
                              '(${stage.item ?? 'Lv.${stage.minLevel}'})',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: viewModel.getTextStyle(
                                context,
                                fontSize: 10,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // 화살표 (마지막이 아니면)
                  if (stage != displayStages.last)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Icon(Icons.arrow_forward_rounded, size: 30),
                    ),
                ],
              );
            }).toList(),
      ),
    );
  }
}

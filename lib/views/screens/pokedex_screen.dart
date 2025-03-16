import 'package:flutter/material.dart';
import 'package:pokedex_app/models/pokedex_entry.dart';
import 'package:pokedex_app/models/pokemon_type_colors.dart';
import 'package:pokedex_app/repositories/pokemon_repository.dart';
import 'package:pokedex_app/viewmodels/pokemon_detail_viewmodel.dart';
import 'package:pokedex_app/viewmodels/shiny_pokemon_viewmodel.dart';
import 'package:pokedex_app/views/widgets/evolution_stage_widget.dart';
import 'package:pokedex_app/views/widgets/pokemon_image.dart';
import 'package:provider/provider.dart';

//테오키스 폼, 기라티나 폼, 변경 구현

class PokedexScreen extends StatelessWidget {
  final PokedexEntry pokedex;
  final bool isDarkMode;

  const PokedexScreen({
    super.key,
    required this.pokedex,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final repository = Provider.of<PokemonRepository>(context, listen: false);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PokemonDetailViewModel(repository, pokedex.id),
        ),
        ChangeNotifierProvider(create: (_) => ShinyPokemonViewmodel()),
      ],
      child: Consumer2<PokemonDetailViewModel, ShinyPokemonViewmodel>(
        builder: (context, detailViewModel, shinyViewModel, child) {
          if (detailViewModel.isLoading) {
            return Center(
              child: Image.asset(
                'assets/pokeball_spin.gif',
                width: 300,
                height: 300,
              ),
            );
          }
          if (detailViewModel.error != null) {
            return Center(child: Text('Error: ${detailViewModel.error}'));
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor:
                  detailViewModel.isLoading || detailViewModel.error != null
                      ? Colors
                          .grey // 로딩/에러 시 기본 색상
                      : detailViewModel.getAppBarColor(),
              title: Text(
                detailViewModel.getFormattedTitle(pokedex.name),
                style:
                    detailViewModel.isLoading || detailViewModel.error != null
                        ? TextStyle(color: Colors.white)
                        : detailViewModel.getAppBarTitleStyle(
                          detailViewModel.getAppBarColor(),
                        ),
              ),
              iconTheme: IconThemeData(
                color:
                    detailViewModel.isLoading || detailViewModel.error != null
                        ? Colors.white
                        : detailViewModel.getAppBarColor().computeLuminance() >
                            0.5
                        ? Colors.black
                        : Colors.white,
              ),
            ),
            body: SafeArea(
              child: RefreshIndicator(
                backgroundColor:
                    isDarkMode ? Colors.grey.shade800 : Colors.white,
                color: Colors.red,
                onRefresh: () async {
                  // 새로고침 시 데이터 다시 로드
                  await detailViewModel.fetchData();
                },
                child:
                    detailViewModel.isLoading
                        ? Center(
                          child: Image.asset(
                            'assets/pokeball_spin.gif',
                            width: 300,
                            height: 300,
                          ),
                        )
                        : detailViewModel.error != null
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Error: ${detailViewModel.error}'),
                              SizedBox(height: 10),
                              Text('위로 당겨서 새로고침 해주세요'),
                            ],
                          ),
                        )
                        : _buildPokemonDetail(
                          context,
                          detailViewModel,
                          shinyViewModel,
                        ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPokemonDetail(
    BuildContext context,
    PokemonDetailViewModel detailViewModel,
    ShinyPokemonViewmodel shinyViewModel,
  ) {
    final detail = detailViewModel.pokemonDetail!;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: PokemonImage(
              imageUrl: shinyViewModel.getPokemonImageUrl(pokedex),
              isShiny: shinyViewModel.isShiny,
              onToggleShiny: shinyViewModel.toggleShiny,
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Height: ${detailViewModel.pokemonHeight}, Weight: ${detailViewModel.pokemonWeight}',
                  style: detailViewModel.getTextStyle(
                    context,
                    fontSize: 15,
                    isBold: true,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(12),
                child: RichText(
                  text: TextSpan(
                    text: 'Types: ',
                    style: detailViewModel.getTextStyle(
                      context,
                      fontSize: 24,
                      isBold: true,
                    ),
                    children: detailViewModel.getTypeColoredTextSpans(),
                  ),
                ),
              ),

              Padding(
                padding: detailViewModel.getDefaultSectionPadding(),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            '-Abilities-',
                            style: detailViewModel.getTextStyle(
                              context,
                              fontSize: 15,
                              isBold: true,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            // 일반 어빌리티 섹션
                            if (detail.regularAbilities.isNotEmpty)
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      'Ability:',
                                      style: detailViewModel.getTextStyle(
                                        context,
                                        fontSize: 15,
                                        isBold: true,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    ...detail.regularAbilities.map(
                                      (ability) => Text(
                                        ability,
                                        style: detailViewModel.getTextStyle(
                                          context,
                                          fontSize: 15,
                                        ),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.visible,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            // 구분선
                            if (detail.regularAbilities.isNotEmpty &&
                                detail.hiddenAbilities.isNotEmpty)
                              Container(
                                height: 50,
                                width: 1,
                                color: Colors.grey,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                              ),

                            // 히든 어빌리티 섹션
                            if (detail.hiddenAbilities.isNotEmpty)
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      'Hidden Ability:',
                                      style: detailViewModel.getTextStyle(
                                        context,
                                        fontSize: 15,
                                        isBold: true,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    ...detail.hiddenAbilities.map(
                                      (ability) => Text(
                                        ability,
                                        style: detailViewModel.getTextStyle(
                                          context,
                                          fontSize: 15,
                                        ),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.visible,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: detailViewModel.getDefaultSectionPadding(),
                child: Container(
                  decoration: detailViewModel.getContainerDecoration(),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            '-Description-',
                            style: detailViewModel.getTextStyle(
                              context,
                              fontSize: 18,
                              isBold: true,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            detailViewModel.getFormattedDescription(),
                            style: detailViewModel.getTextStyle(
                              context,
                              fontSize: 15,
                            ),
                            overflow: TextOverflow.visible,
                            textAlign: TextAlign.justify,
                            maxLines: 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: detailViewModel.getLastSectionPadding(),
                child: Container(
                  decoration: detailViewModel.getContainerDecoration(),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '-Evolution-',
                            style: detailViewModel.getTextStyle(
                              context,
                              fontSize: 15,
                              isBold: true,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // 새로운 방식: 이브이와 같은 특별한 진화는 별도 처리
                          if (detailViewModel.isEeveeEvolutionCase(pokedex.id))
                            // 이브이 특별 처리 - 진화형 그리드로 표시
                            Column(
                              children: [
                                Image.network(
                                  detailViewModel.getListImageUrl(
                                    detailViewModel.evolutionChain![0].id,
                                  ),
                                ),
                                Icon(Icons.arrow_downward_rounded),

                                const SizedBox(height: 10),
                                // 이브이 진화 이미지 그리드
                                SizedBox(
                                  height: 190, // 고정 높이
                                  child: GridView.builder(
                                    gridDelegate:
                                        detailViewModel.getEeveeGridDelegate(),
                                    itemCount:
                                        detailViewModel
                                            .getEeveeEvolutions()
                                            .length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(), // 스크롤 방지
                                    itemBuilder: (context, index) {
                                      // 이브이(0번)를 제외한 진화형들
                                      final evolution =
                                          detailViewModel
                                              .getEeveeEvolutions()[index];
                                      return InkWell(
                                        onTap: () {
                                          // ViewModel의 네비게이션 메서드 사용
                                          detailViewModel.navigateToEvolution(
                                            context,
                                            evolution,
                                          );
                                        },
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // 이미지
                                            SizedBox(
                                              width: 50,
                                              height: 50,
                                              child: Image.network(
                                                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${evolution.id}.png',
                                                errorBuilder:
                                                    (_, __, ___) => Image.asset(
                                                      'assets/pokeball_error.png',
                                                      width: 50,
                                                    ),
                                              ),
                                            ),
                                            // 이름
                                            Text(
                                              evolution.name.capitalize(),
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: detailViewModel
                                                  .getTextStyle(
                                                    context,
                                                    fontSize: 10,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )
                          else
                            // 일반 포켓몬 진화
                            ClipRect(
                              child: SizedBox(
                                height: 140,
                                child: EvolutionStageWidget(
                                  evolutionChain:
                                      detailViewModel.evolutionChain,
                                  currentPokemonId: pokedex.id,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

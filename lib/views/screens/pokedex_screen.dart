import 'package:flutter/material.dart';
import 'package:pokedex_app/models/pokedex_entry.dart';
import 'package:pokedex_app/utils/string_utils.dart';
import 'package:pokedex_app/viewmodels/pokemon_detail_viewmodel.dart';
import 'package:pokedex_app/viewmodels/shiny_pokemon_viewmodel.dart';
import 'package:pokedex_app/views/widgets/evolution_Stage_widget.dart';
import 'package:pokedex_app/views/widgets/pokemon_image.dart';
import 'package:provider/provider.dart';

//테오키스 폼, 기라티나 폼, 변경 구현

class PokedexScreen extends StatelessWidget {
  final PokedexEntry pokedex;

  const PokedexScreen({super.key, required this.pokedex});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PokemonDetailViewModel(pokedex.id),
        ),
        ChangeNotifierProvider(create: (_) => ShinyPokemonViewmodel()),
      ],
      child: Consumer2<PokemonDetailViewModel, ShinyPokemonViewmodel>(
        builder: (context, detailViewModel, shinyViewModel, child) {
          if (detailViewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (detailViewModel.error != null) {
            return Center(child: Text('Error: ${detailViewModel.error}'));
          }
          final detail = detailViewModel.pokemonDetail!;
          final appBarColor = detailViewModel.getAppBarColor();
          final textColor =
              appBarColor.computeLuminance() > 0.5
                  ? Colors.black
                  : Colors.white;

          return Scaffold(
            appBar: AppBar(
              backgroundColor: appBarColor, // 동적 색상 적용
              title: Text(
                'No.${pokedex.id} ${pokedex.name.capitalize()}',
                style: TextStyle(
                  color:
                      appBarColor.computeLuminance() > 0.5
                          ? Colors.black
                          : Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              iconTheme: IconThemeData(
                color: textColor, // 뒤로가기 버튼 색상 (흰색으로 예시)
              ),
            ),
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: PokemonImage(
                      imageUrl: shinyViewModel.getPokemonImageUrl(pokedex),
                      isShiny: shinyViewModel.isShiny,
                      onToggleShiny: shinyViewModel.toggleShiny,
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              'Height: ${detail.height / 10}m, Weight: ${detail.weight / 10}kg',
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.surface
                                                .computeLuminance() >
                                            0.5
                                        ? Colors.black
                                        : Colors.white,
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
                                style: TextStyle(
                                  fontSize: 24,
                                  color:
                                      Theme.of(context).colorScheme.surface
                                                  .computeLuminance() >
                                              0.5
                                          ? Colors.black
                                          : Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                                children:
                                    detail.types.join(', ').toTypeColoredText(),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Text(
                                        '-Ability-',
                                        style: TextStyle(
                                          color:
                                              Theme.of(context)
                                                          .colorScheme
                                                          .surface
                                                          .computeLuminance() >
                                                      0.5
                                                  ? Colors.black
                                                  : Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 10),
                                    Center(
                                      child: Text(
                                        detail.abilities,
                                        style: TextStyle(
                                          color:
                                              Theme.of(context)
                                                          .colorScheme
                                                          .surface
                                                          .computeLuminance() >
                                                      0.5
                                                  ? Colors.black
                                                  : Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Text(
                                        '-Description-',
                                        style: TextStyle(
                                          color:
                                              Theme.of(context)
                                                          .colorScheme
                                                          .surface
                                                          .computeLuminance() >
                                                      0.5
                                                  ? Colors.black
                                                  : Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 10),
                                    Text(
                                      detail.flavorText,
                                      style: TextStyle(
                                        color:
                                            Theme.of(context)
                                                        .colorScheme
                                                        .surface
                                                        .computeLuminance() >
                                                    0.5
                                                ? Colors.black
                                                : Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
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
                                evolutionChain: detailViewModel.evolutionChain,
                                currentPokemonId: pokedex.id,
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
      ),
    );
  }
}

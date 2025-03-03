import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokedex_app/models/evolution_stage.dart';
import 'package:pokedex_app/models/pokedex_entry.dart';
import 'package:pokedex_app/models/pokemon_detail.dart';

class ApiService {
  Future<List<PokedexEntry>> getKantoPokemonData() async {
    final response = await http.get(
      Uri.parse('https://pokeapi.co/api/v2/pokedex/1/'),
    );
    final data = jsonDecode(response.body);
    return (data['pokemon_entries'] as List)
        .where((e) => e['entry_number'] <= 151) // 관동만 필터링
        .map((e) => PokedexEntry.fromJson(e))
        .toList();
  }

  Future<PokemonDetail> getPokemonDetail(int id) async {
    final speciesResponse = await http.get(
      Uri.parse('https://pokeapi.co/api/v2/pokemon-species/$id'),
    );
    final pokemonResponse = await http.get(
      Uri.parse('https://pokeapi.co/api/v2/pokemon/$id'),
    );
    if (speciesResponse.statusCode == 200 &&
        pokemonResponse.statusCode == 200) {
      final speciesData = jsonDecode(speciesResponse.body);
      final pokemonData = jsonDecode(pokemonResponse.body);
      final height = pokemonData['height'] as int;
      final weight = pokemonData['weight'] as int;
      final types =
          (pokemonData['types'] as List)
              .map((type) => type['type']['name'] as String)
              .toList();
      final flavorText = (speciesData['flavor_text_entries'] as List)
          .firstWhere(
            (entry) => entry['language']['name'] == 'en',
          )['flavor_text']
          .toString()
          .replaceAll('\n', ' ');
      final abilityList = (pokemonData['abilities'] as List)
          .map((ability) => ability['ability']['name'] as String)
          .join(', ');

      return PokemonDetail(
        height: height,
        weight: weight,
        types: types,
        flavorText: flavorText,
        abilities: abilityList,
      );
    } else {
      throw Exception('Failed to load Pokémon detail');
    }
  }

  Future<List<EvolutionStage>> getEvolutionChainForPokemon(int id) async {
    final speciesResponse = await http.get(
      Uri.parse('https://pokeapi.co/api/v2/pokemon-species/$id'),
    );
    if (speciesResponse.statusCode != 200)
      throw Exception('Failed to load species');

    final speciesData = jsonDecode(speciesResponse.body);
    final chainUrl = speciesData['evolution_chain']['url'];
    final chainResponse = await http.get(Uri.parse(chainUrl));
    if (chainResponse.statusCode != 200)
      throw Exception('Failed to load evolution chain');

    final chainData = jsonDecode(chainResponse.body)['chain'];
    List<EvolutionStage> stages = [];

    // 재귀적으로 파싱
    void parseChain(Map<String, dynamic> chain) {
      stages.add(EvolutionStage.fromJson(chain));
      final evolvesTo = chain['evolves_to'] as List;
      for (var next in evolvesTo) {
        parseChain(next);
      }
    }

    parseChain(chainData);
    return stages;
  }
}

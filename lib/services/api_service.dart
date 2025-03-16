import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokedex_app/models/evolution_stage.dart';
import 'package:pokedex_app/models/pokedex_entry.dart';
import 'package:pokedex_app/models/pokemon_detail.dart';

class ApiService {
  Future<List<PokedexEntry>> getPokemonData({int retries = 3}) async {
  late http.Response response;
  for (int i = 0; i < retries; i++) {
    try {
      response = await http
          .get(Uri.parse('https://pokeapi.co/api/v2/pokedex/1/'))
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) break;
      throw Exception('Failed with status: ${response.statusCode}');
    } catch (e) {
      if (i == retries - 1) throw Exception('All retries failed: $e');
      print('Retry $i failed: $e');
      await Future.delayed(Duration(seconds: 2));
    }
  }
  final data = jsonDecode(response.body);
    if (data is! Map<String, dynamic> || data['pokemon_entries'] == null) {
      throw Exception('Invalid response format: pokemon_entries is missing or null - ${response.body}');
    }

    final entries = data['pokemon_entries'] as List<dynamic>;
    return entries.map((e) => PokedexEntry.fromJson(e)).toList();
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

      final regularAbilities = <String>[];
      final hiddenAbilities = <String>[];
      for (var ability in pokemonData['abilities'] as List) {
        final name = ability['ability']['name'] as String;
        final isHidden = ability['is_hidden'] as bool;
        if (isHidden) {
          hiddenAbilities.add(name.capitalize());
        } else {
          regularAbilities.add(name.capitalize());
        }
      }

      return PokemonDetail(
        height: height,
        weight: weight,
        types: types,
        flavorText: flavorText,
        regularAbilities: regularAbilities,
        hiddenAbilities: hiddenAbilities,
      );
    } else {
      throw Exception('Failed to load Pokémon detail');
    }
  }

  Future<List<EvolutionStage>> getEvolutionStages(int pokemonId) async {
    final speciesResponse = await http.get(
      Uri.parse('https://pokeapi.co/api/v2/pokemon-species/$pokemonId'),
    );
    if (speciesResponse.statusCode != 200) {
      throw Exception('Failed to load species');
    }
    final speciesData = jsonDecode(speciesResponse.body);
    final chainUrl = speciesData['evolution_chain']['url'];
    final chainResponse = await http.get(Uri.parse(chainUrl));
    if (chainResponse.statusCode != 200) {
      throw Exception('Failed to load evolution chain');
    }
    final chainData = jsonDecode(chainResponse.body)['chain'];
    List<EvolutionStage> stages = [];

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

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

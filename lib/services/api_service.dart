import 'dart:convert';
import 'package:http/http.dart' as http;
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

      return PokemonDetail(
        height: height,
        weight: weight,
        types: types,
        flavorText: flavorText,
      );
    } else {
      throw Exception('Failed to load Pokémon detail');
    }
  }
}

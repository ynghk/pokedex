import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokedex_app/models/pokemon_list.dart';
import 'package:pokedex_app/models/pokemon_list_result.dart';

class ApiService {
  final String baseUrl = 'https://pokeapi.co/api/v2/pokemon';
  final String kantoRegion = 'limit=151';

  Future<List<PokemonListResult>> getKantoPokemonData() async {
    List<PokemonListResult> kantoPokemon = [];
    final Uri url = Uri.parse('$baseUrl?$kantoRegion');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final pokemons = PokemonList.fromJson(jsonDecode(response.body));
      List<dynamic> pokemonData = pokemons.results;
      for (var pokemon in pokemonData) {
        final pokemonListResult = PokemonListResult.fromJson(pokemon);
        kantoPokemon.add(pokemonListResult);
      }
    }
    return kantoPokemon;
  }
}

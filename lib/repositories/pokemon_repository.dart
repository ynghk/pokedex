import 'package:poke_master/models/pokedex_entry.dart';
import 'package:poke_master/models/pokemon_detail.dart';
import 'package:poke_master/models/evolution_stage.dart';
import 'package:poke_master/services/api_service.dart';

class PokemonRepository {
  final ApiService _apiService = ApiService();

  Future<List<PokedexEntry>> getPokemonsByRegion(String region) async {
    return _apiService.getPokemonData();
  }

  Future<PokemonDetail> getPokemonDetail(int id) =>
      _apiService.getPokemonDetail(id);
  Future<List<EvolutionStage>> getEvolutionChain(int pokemonId) =>
      _apiService.getEvolutionStages(pokemonId);
}

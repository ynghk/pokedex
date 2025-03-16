import 'package:pokedex_app/models/pokedex_entry.dart';
import 'package:pokedex_app/models/pokemon_detail.dart';
import 'package:pokedex_app/models/evolution_stage.dart';
import 'package:pokedex_app/services/api_service.dart';

class PokemonRepository {
  final ApiService _apiService = ApiService();

  Future<List<PokedexEntry>> getPokemonsByRegion(String region) async {
    switch (region) {
      case 'Kanto':
        return _apiService.getKantoPokemonData();
      case 'Johto':
        return _apiService.getJohtoPokemonData();
      case 'Hoenn':
        return _apiService.getHoennPokemonData();
      case 'Sinnoh':
        return _apiService.getSinnohPokemonData();
      case 'Unova':
        return _apiService.getUnovaPokemonData();
      case 'Kalos':
        return _apiService.getKalosPokemonData();
      case 'Alola':
        return _apiService.getAlolaPokemonData();
      case 'Galar':
        return _apiService.getGalarPokemonData();
      case 'Paldea':
        return _apiService.getPaldeaPokemonData();
      case 'Hisui':
        return _apiService.getHisuiPokemonData();
      default:
        return _apiService.getKantoPokemonData();
    }
  }

  Future<PokemonDetail> getPokemonDetail(int id) {
    return _apiService.getPokemonDetail(id);
  }

  Future<List<EvolutionStage>> getEvolutionChain(int pokemonId) {
    return _apiService.getEvolutionStages(pokemonId);
  }
}

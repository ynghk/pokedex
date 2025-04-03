import 'package:poke_master/models/pokedex_entry.dart';
import 'package:poke_master/models/pokemon_detail.dart';
import 'package:poke_master/models/evolution_stage.dart';
import 'package:poke_master/services/api_service.dart';

class PokemonRepository {
  final ApiService _apiService = ApiService();

  Future<List<PokedexEntry>> getPokemonsByRegion(String region) async {
    final allPokemons = await _apiService.getPokemonData(); // 전체 데이터
    return _filterPokemonsByRegion(allPokemons, region);
  }

  List<PokedexEntry> _filterPokemonsByRegion(
    List<PokedexEntry> pokemons,
    String region,
  ) {
    switch (region) {
      case 'Kanto':
        return pokemons.where((p) => p.id <= 151).toList();
      case 'Johto':
        return pokemons.where((p) => p.id > 151 && p.id <= 251).toList();
      case 'Hoenn':
        return pokemons.where((p) => p.id > 251 && p.id <= 386).toList();
      case 'Sinnoh':
        return pokemons.where((p) => p.id > 386 && p.id <= 493).toList();
      case 'Unova':
        return pokemons.where((p) => p.id > 493 && p.id <= 649).toList();
      case 'Kalos':
        return pokemons.where((p) => p.id > 649 && p.id <= 721).toList();
      case 'Alola':
        return pokemons.where((p) => p.id > 721 && p.id <= 809).toList();
      case 'Galar':
        return pokemons.where((p) => p.id > 809 && p.id <= 898).toList();
      case 'Paldea':
        return pokemons
            .where((p) => p.id > 906 && p.id <= 1003)
            .toList(); // 1010 아님
      case 'Hisui':
        return pokemons.where((p) => _isHisuiVariant(p)).toList();
      default:
        return [];
    }
  }

  bool _isHisuiVariant(PokedexEntry p) {
    const hisuiIds = [899, 900, 901, 902, 903, 904, 905];
    return hisuiIds.contains(p.id);
  }

  Future<PokedexDetail> getPokemonDetail(int id) =>
      _apiService.getPokemonDetail(id);
  Future<List<EvolutionStage>> getEvolutionChain(int pokemonId) =>
      _apiService.getEvolutionStages(pokemonId);
}

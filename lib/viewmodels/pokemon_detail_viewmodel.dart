import 'package:flutter/material.dart';
import 'package:pokedex_app/models/evolution_stage.dart';
import 'package:pokedex_app/models/pokemon_detail.dart';
import 'package:pokedex_app/services/api_service.dart';
import 'package:pokedex_app/utils/string_utils.dart';

class PokemonDetailViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final int pokemonId;
  PokemonDetail? _pokemonDetail;
  List<EvolutionStage>? _evolutionChain;
  bool _isLoading = true;
  String? _error;

  PokemonDetailViewModel(this.pokemonId) {
    fetchData();
  }

  PokemonDetail? get pokemonDetail => _pokemonDetail;
  List<EvolutionStage>? get evolutionChain => _evolutionChain;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _pokemonDetail = await _apiService.getPokemonDetail(pokemonId);
      _evolutionChain = await _apiService.getEvolutionChainForPokemon(pokemonId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Color getAppBarColor() {
    final primaryType = _pokemonDetail?.types[0].toLowerCase();
    return pokemonTypeColors[primaryType] ?? Colors.red;
  }
}
import 'package:flutter/material.dart';
import 'package:pokedex_app/models/pokedex_entry.dart';
import 'package:pokedex_app/services/api_service.dart';

class PokemonListViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<PokedexEntry> _pokemons = [];
  String _searchQuery = '';
  String _selectedRegion = 'Kanto'; // 기본 지역
  String _selectedLanguage = 'English';
  String get selectedLanguage => _selectedLanguage;

  List<PokedexEntry> get pokemons => _pokemons;
  String get searchQuery => _searchQuery;
  String get selectedRegion => _selectedRegion;

  // 필터링된 포켓몬 리스트
  List<PokedexEntry> get filteredPokemons =>
      _pokemons
          .where(
            (p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();

  // 지역별 데이터 로드
  Future<void> loadPokemons(String region) async {
    _selectedRegion = region;
    switch (region) {
      case 'Kanto':
        _pokemons = await _apiService.getKantoPokemonData();
        break;
      case 'Johto':
        _pokemons = await _apiService.getJohtoPokemonData();
        break;
      case 'Hoenn':
        _pokemons = await _apiService.getHoennPokemonData();
        break;
      case 'Sinnoh':
        _pokemons = await _apiService.getSinnohPokemonData();
        break;
      case 'Unova':
        _pokemons = await _apiService.getUnovaPokemonData();
        break;
      case 'Kalos':
        _pokemons = await _apiService.getKalosPokemonData();
        break;
      case 'Alola':
        _pokemons = await _apiService.getAlolaPokemonData();
        break;
      case 'Galar':
        _pokemons = await _apiService.getGalarPokemonData();
        break;
      case 'Paldea':
        _pokemons = await _apiService.getPaldeaPokemonData();
        break;
      case 'Hisui':
        _pokemons = await _apiService.getHisuiPokemonData();
        break;
      default:
        _pokemons = await _apiService.getKantoPokemonData();
    }
    notifyListeners();
  }

  void updateLanguage(String newLanguage) {
    _selectedLanguage = newLanguage;
    notifyListeners();
  }

  // 검색 쿼리 업데이트
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // 검색 초기화
  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }
}

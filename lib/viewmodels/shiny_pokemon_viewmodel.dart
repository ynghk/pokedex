import 'package:flutter/widgets.dart';
import 'package:poke_master/models/pokedex_entry.dart';

class ShinyPokemonViewmodel with ChangeNotifier {
  bool _isShiny = false; // 이로치 상태 기본값 설정
  bool get isShiny => _isShiny;

  //이로치 상태 토글하는 메서드 생성
  void toggleShiny() {
    _isShiny = !_isShiny;
    notifyListeners();
  }

  //포켓몬id로 이미지 url을 반환
  String getPokemonImageUrl(PokedexEntry url) {
    final pokemonId = url.getPokemonId();
    if (isShiny) {
      return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/$pokemonId.png';
    } else {
      return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$pokemonId.png';
    }
  }
}

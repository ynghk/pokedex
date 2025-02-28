import 'package:pokedex_app/models/pokemon_list_result.dart';

extension StringCapitalize on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}

class ShinyPokemon {
  bool isShiny = false; // 이로치 상태 기본값 설정

  //이로치 상태 토글하는 메서드 생성
  void toggleShiny() {
    isShiny = !isShiny;
  }

  //포켓몬id로 이미지 url을 반환
  String getPokemonImageUrl(PokemonListResult pokemon) {
    final pokemonId = pokemon.getPokemonId();
    if (isShiny) {
      return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/$pokemonId.png';
    } else {
      return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$pokemonId.png';
    }
  }
}

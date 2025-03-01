import 'package:pokedex_app/models/pokedex_entry.dart';

extension StringCapitalize on String {
  // 소문자로 시작하면 대문자로 전부 대문자면 앞 글자만 빼고 소문자로 바꿔줌
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  // 쉼표로 구분된 문자열 처리
  String capitalizeList() {
    if (isEmpty) return this;
    // 쉼표와 공백(`, `)으로 나눔
    final words = split(', ');
    // 각 단어를 capitalize()로 변환
    final capitalizedWords = words.map((word) => word.capitalize()).toList();
    // 다시 쉼표와 공백으로 합침
    return capitalizedWords.join(', ');
  }
}

class ShinyPokemon {
  bool isShiny = false; // 이로치 상태 기본값 설정

  //이로치 상태 토글하는 메서드 생성
  void toggleShiny() {
    isShiny = !isShiny;
  }

  //포켓몬id로 이미지 url을 반환
  String getPokemonImageUrl(PokedexEntry id) {
    final pokemonId = id.id;
    if (isShiny) {
      return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/shiny/$pokemonId.png';
    } else {
      return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$pokemonId.png';
    }
  }
}

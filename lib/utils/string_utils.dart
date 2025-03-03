import 'package:flutter/material.dart';
import 'package:pokedex_app/models/pokedex_entry.dart';
import 'package:pokedex_app/models/pokemon_detail.dart';

final pokemonTypeColors = {
  'grass': Colors.green,
  'poison': Colors.purple,
  'fire': Colors.red,
  'water': Colors.blue,
  'electric': Colors.yellow,
  'ice': Colors.cyan,
  'fighting': Colors.orange,
  'psychic': Colors.pink,
  'rock': Colors.brown,
  'ground': Colors.brown[700]!,
  'flying': Colors.lightBlue,
  'bug': Colors.lightGreen,
  'normal': Colors.grey,
  'ghost': Colors.deepPurple,
  'steel': Colors.grey[600]!,
  'dragon': Colors.indigo,
  'dark': Colors.black87,
  'fairy': Colors.pink[200]!,
};

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

  List<TextSpan> toTypeColoredText() {
    if (isEmpty) return [TextSpan(text: this)];

    final words = split(', '); // 타입 나누기
    return words.map((word) {
      final capitalizedWord = word.capitalize();
      final backgroundColor =
          pokemonTypeColors[word.toLowerCase()] ??
          Colors.black; // 타입에 맞는 색상, 없으면 검정
      return TextSpan(
        children: [
          WidgetSpan(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              margin: const EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                capitalizedWord,
                style: TextStyle(
                  color:
                      backgroundColor.computeLuminance() > 0.5
                          ? Colors.black
                          : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      );
    }).toList();
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

Color getAppBarColor(PokemonDetail detail) {
  final primaryType = detail.types[0].toLowerCase();
  return pokemonTypeColors[primaryType] ?? Colors.red;
}

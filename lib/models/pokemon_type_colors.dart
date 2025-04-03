import 'package:flutter/material.dart';
import 'package:poke_master/models/pokemon_detail.dart';

final pokemonTypeColors = {
  'grass': Color(0xFF7AC74C),
  'poison': Color(0xFFA33EA1),
  'fire': Color(0xFFEE8130),
  'water': Color(0xFF6390F0),
  'electric': Color(0xFFF7D02C),
  'ice': Color(0xFF96D9D6),
  'fighting': Color(0xFFC22E28),
  'psychic': Color(0xFFF95587),
  'rock': Color(0xFFB6A136),
  'ground': Color(0xFFE2BF65),
  'flying': Color(0xFFA98FF3),
  'bug': Color(0xFFA6B91A),
  'normal': Color(0xFFA8A77A),
  'ghost': Color(0xFF735797),
  'steel': Color(0xFFB7B7CE),
  'dragon': Color(0xFF6F35FC),
  'dark': Color(0xFF705746),
  'fairy': Color(0xFFD685AD),
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

Color getAppBarColor(PokedexDetail detail) {
  final primaryType = detail.types[0].toLowerCase();
  return pokemonTypeColors[primaryType] ?? Colors.red;
}

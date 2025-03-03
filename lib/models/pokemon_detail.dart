class PokemonDetail {
  final int height;
  final int weight;
  final List<String> types; //포켓몬 타입
  final String flavorText; //포켓몬 설명
  final String abilities;

  PokemonDetail({
    required this.height,
    required this.weight,
    required this.types,
    required this.flavorText,
    required this.abilities,
  });

  factory PokemonDetail.fromJson(Map<String, dynamic> json) {
    final height = json['height'];
    final weight = json['weight'];
    final typeList =
        (json['types'] as List)
            .map((type) => type['type']['name'] as String)
            .toList();

    final flavorText = (json['flavor_text_entries'] as List)
        .firstWhere((entry) => entry['language']['name'] == 'en')['flavor_text']
        .toString()
        .replaceAll('\n', ' ');
    final abilityList =
        (json['abilities'] as List)
            .map((ability) => ability['ability']['name'] as String)
            .join(', ');
    return PokemonDetail(
      height: height,
      weight: weight,
      types: typeList,
      flavorText: flavorText,
      abilities: abilityList,
    );
  }
}

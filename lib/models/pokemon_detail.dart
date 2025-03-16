class PokemonDetail {
  final int height;
  final int weight;
  final List<String> types; //포켓몬 타입
  final String flavorText; //포켓몬 설명
  final List<String> regularAbilities; // 일반 어빌리티
  final List<String> hiddenAbilities; // 히든 어빌리티

  PokemonDetail({
    required this.height,
    required this.weight,
    required this.types,
    required this.flavorText,
    required this.regularAbilities,
    required this.hiddenAbilities,
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

    // 일반 어빌리티와 히든 어빌리티 분리
    final regularAbilities = <String>[];
    final hiddenAbilities = <String>[];

    for (var ability in json['abilities'] as List) {
      final name = ability['ability']['name'] as String;
      final isHidden = ability['is_hidden'] as bool;

      if (isHidden) {
        hiddenAbilities.add(name);
      } else {
        regularAbilities.add(name);
      }
    }

    return PokemonDetail(
      height: height,
      weight: weight,
      types: typeList,
      flavorText: flavorText,
      regularAbilities: regularAbilities,
      hiddenAbilities: hiddenAbilities,
    );
  }
}

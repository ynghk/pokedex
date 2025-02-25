class PokemonListResult {
  final String name;
  final String url;

  PokemonListResult.fromjson(Map<String, dynamic> json)
    : name = json['name'],
      url = json['url'];
}

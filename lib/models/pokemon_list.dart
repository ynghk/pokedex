class PokemonList {
  final int count;
  final String next;
  final String? previous;
  final List<dynamic> results;

  PokemonList.fromjson(Map<String, dynamic> json)
    : count = json['count'],
      next = json['next'],
      previous = json['previous'],
      results = json['results'];
}

class PokemonList {
  final int count;
  final String next;
  final String? previous;
  final List<dynamic> results;

  PokemonList({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory PokemonList.fromJson(Map<String, dynamic> json) {
    return PokemonList(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: json['results'],
    );
  }
}

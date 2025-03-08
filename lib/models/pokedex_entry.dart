class PokedexEntry {
  final int id;
  final String name;
  final String url;

  PokedexEntry({required this.id, required this.name, required this.url});

  factory PokedexEntry.fromJson(Map<String, dynamic> json) {
    return PokedexEntry(
      id: json['entry_number'],
      name: json['pokemon_species']['name'],
      url: json['pokemon_species']['url'],
    );
  }

  //url에서 포켓몬 id 추출
  int getPokemonId() {
    final id = url.split('/').reversed.elementAt(1);
    return int.parse(id);
  }
}

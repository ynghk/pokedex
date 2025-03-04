
class PokedexEntry {
  final int id;
  final String name;

  PokedexEntry({required this.id, required this.name});

  factory PokedexEntry.fromJson(Map<String, dynamic> json) {
    return PokedexEntry(
      id: json['entry_number'],
      name: json['pokemon_species']['name'],
    );
  }
}
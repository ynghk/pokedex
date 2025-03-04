class EvolutionStage {
  final String name;
  final int id;
  final int? minLevel;
  final String? trigger;
  final String? item;

  EvolutionStage({
    required this.name,
    required this.id,
    required this.minLevel,
    required this.trigger,
    required this.item,
  });

  factory EvolutionStage.fromJson(Map<String, dynamic> json) {
    final details = json['evolution_details'] as List?;
    return EvolutionStage(
      name: json['species']['name'],
      id: int.parse(json['species']['url'].split('/').reversed.elementAt(1)),
      minLevel:
          details != null && details.isNotEmpty
              ? details[0]['min_level']
              : null,
      trigger:
          details != null && details.isNotEmpty
              ? details[0]['trigger']['name']
              : null,
      item:
          details != null && details.isNotEmpty && details[0]['item'] != null
              ? details[0]['item']['name']
              : null,
    );
  }
}

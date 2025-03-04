class PokemonListResult {
  final String name;
  final String url;

  PokemonListResult({required this.name, required this.url});

  factory PokemonListResult.fromJson(Map<String, dynamic> json) {
    return PokemonListResult(name: json['name'], url: json['url']);
  }

  //url에서 ID 추출
  int getPokemonId() {
    final id = url.split('/').reversed.elementAtOrNull(1); //url을 /기준으로 쪼갠 후 reversed를 줘서 뒤에서 두번째 요소를 id에 저장
    if (id == null) throw Exception('Invalid URL format'); //id가 null일 경우를 생각하여 throw exception으로 예외 처리
    return int.parse(id); // id를 정수 형태로 반환 
  }
}

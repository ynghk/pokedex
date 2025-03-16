import 'package:flutter/material.dart';
import 'package:pokedex_app/models/evolution_stage.dart';
import 'package:pokedex_app/models/pokemon_detail.dart';
import 'package:pokedex_app/models/pokemon_type_colors.dart';
import 'package:pokedex_app/models/pokedex_entry.dart';
import 'package:pokedex_app/repositories/pokemon_repository.dart';
import 'package:pokedex_app/views/screens/pokedex_screen.dart';

class PokemonDetailViewModel with ChangeNotifier {
  final PokemonRepository _repository;
  final int pokemonId;
  PokemonDetail? _pokemonDetail;
  List<EvolutionStage>? _evolutionChain;
  bool _isLoading = true;
  String? _error;

  PokemonDetailViewModel(this._repository, this.pokemonId) {
    fetchData();
  }

  PokemonDetail? get pokemonDetail => _pokemonDetail;
  List<EvolutionStage>? get evolutionChain => _evolutionChain;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // UI에 접근할 수 있는 getter
  String get pokemonHeight =>
      _pokemonDetail != null ? '${_pokemonDetail!.height / 10}m' : '?';
  String get pokemonWeight =>
      _pokemonDetail != null ? '${_pokemonDetail!.weight / 10}kg' : '?';
  List<String> get pokemonTypes => _pokemonDetail?.types ?? [];
  String get pokemonFlavorText => _pokemonDetail?.flavorText ?? '';
  List<String> get regularAbilities => _pokemonDetail?.regularAbilities ?? [];
  List<String> get hiddenAbilities => _pokemonDetail?.hiddenAbilities ?? [];

  // 텍스트 스타일을 결정하는 메서드
  TextStyle getTextStyle(
    BuildContext context, {
    bool isBold = false,
    double fontSize = 15.0,
  }) {
    final isDark =
        Theme.of(context).colorScheme.surface.computeLuminance() <= 0.5;
    return TextStyle(
      color: isDark ? Colors.white : Colors.black,
      fontSize: fontSize,
      fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
    );
  }

  // 진화 스테이지 위젯에서 사용할 스타일
  TextStyle getEvolutionTextStyle(
    BuildContext context, {
    bool isBold = false,
    double fontSize = 12.0,
  }) {
    final isDark =
        Theme.of(context).colorScheme.surface.computeLuminance() <= 0.5;
    return TextStyle(
      color: isDark ? Colors.white : Colors.black,
      fontSize: fontSize,
      fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
      overflow: TextOverflow.ellipsis,
    );
  }

  Future<void> fetchData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _pokemonDetail = await _repository.getPokemonDetail(pokemonId);
      _evolutionChain = await _repository.getEvolutionChain(pokemonId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Color getAppBarColor() {
    final primaryType = _pokemonDetail?.types[0].toLowerCase();
    return pokemonTypeColors[primaryType] ?? Colors.red;
  }

  // 타입 별 색상 처리 로직
  List<TextSpan> getTypeColoredTextSpans() {
    if (_pokemonDetail == null) return [];
    return _pokemonDetail!.types.join(', ').toTypeColoredText();
  }

  // 이브이 특별 처리 확인 메서드
  bool isEeveeEvolutionCase(int currentPokemonId) {
    return evolutionChain != null &&
        evolutionChain!.isNotEmpty &&
        evolutionChain![0].name.toLowerCase() == 'eevee' &&
        currentPokemonId == evolutionChain![0].id;
  }

  // 이브이를 제외한 진화형 목록 반환
  List<EvolutionStage> getEeveeEvolutions() {
    if (evolutionChain == null || evolutionChain!.isEmpty) {
      return [];
    }
    // 이브이(첫 번째)를 제외한 모든 진화형 반환
    return evolutionChain!.length > 1 ? evolutionChain!.sublist(1) : [];
  }

  // 진화 단계 클릭 처리 메서드
  void navigateToEvolution(BuildContext context, EvolutionStage evolution) {
    // 네비게이션 로직을 ViewModel에서 처리
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => PokedexScreen(
              pokedex: PokedexEntry(
                id: evolution.id,
                name: evolution.name,
                url:
                    'https://pokeapi.co/api/v2/pokemon-species/${evolution.id}/',
              ),
              isDarkMode: Theme.of(context).colorScheme.surface.computeLuminance() <= 0.5,
            ),
      ),
    );
  }

  // 포켓몬 설명 정렬
  String getFormattedDescription() {
    if (_pokemonDetail == null) return '';
    return _pokemonDetail!.flavorText
        .replaceAll('\n', ' ')
        .replaceAll('  ', ' ');
  }

  String getFormattedTitle(String name) {
    return 'No.$pokemonId ${name.capitalize()}';
  }

  // AppBar 스타일 관련 메서드
  TextStyle getAppBarTitleStyle(Color appBarColor) {
    return TextStyle(
      color: appBarColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
      fontSize: 30,
      fontWeight: FontWeight.bold,
    );
  }

  // Container 스타일 관련 메서드
  BoxDecoration getContainerDecoration() {
    return BoxDecoration(
      border: Border.all(color: Colors.grey, width: 2),
      borderRadius: BorderRadius.circular(10),
    );
  }

  // 섹션 패딩 관련 메서드
  EdgeInsets getDefaultSectionPadding() {
    return const EdgeInsets.only(top: 5, left: 12, right: 12);
  }

  EdgeInsets getLastSectionPadding() {
    return const EdgeInsets.only(top: 5, left: 12, right: 12, bottom: 15);
  }

  // 이브이 진화 그리드 스타일
  SliverGridDelegateWithFixedCrossAxisCount getEeveeGridDelegate() {
    return const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4,
      childAspectRatio: 0.8,
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
    );
  }

  // 이미지 URL 생성 메서드
  String getListImageUrl(int pokemonId) {
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$pokemonId.png';
  }
}

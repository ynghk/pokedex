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
  bool _isLoading = false;
  String? _error;
  final ScrollController _scrollController = ScrollController();
  bool _isDisposed = false;
  bool get isDisposed => _isDisposed;

  PokemonDetailViewModel(this._repository, this.pokemonId);

  // Getters
  PokemonDetail? get pokemonDetail => _pokemonDetail;
  List<EvolutionStage>? get evolutionChain => _evolutionChain;
  bool get isLoading => _isLoading;
  String? get error => _error;
  ScrollController get scrollController => _scrollController;

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

  // 데이터 로드 메서드
  Future<void> fetchData() async {
    // dispose된 후 호출되었는지 확인
    if (_isDisposed) {
      print('경고: disposed된 ViewModel에서 fetchData() 호출됨');
      return;
    }

    _isLoading = true;
    _error = null;
    _pokemonDetail = null;
    _evolutionChain = null;
    notifyListeners();

    try {
      _pokemonDetail = await _repository.getPokemonDetail(pokemonId);
      // 중간에 dispose 되었는지 확인
      if (_isDisposed) return;

      _evolutionChain = await _repository.getEvolutionChain(pokemonId);
      // 다시 확인
      if (_isDisposed) return;
    } catch (e) {
      if (_isDisposed) return;
      _error = e.toString();
      print('Error fetching data for ID $pokemonId: $e');
    } finally {
      if (_isDisposed) return;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDataWithScrollReset(BuildContext context) async {
    // 뷰모델이 이미 dispose되었는지 확인
    if (_isDisposed) {
      print('경고: disposed된 ViewModel에서 fetchDataWithScrollReset() 호출됨');
      return;
    }

    try {
      await fetchData();
      // 비동기 작업 후 뷰모델이 dispose 되었는지 확인
      if (_isDisposed) return;

      if (_scrollController.hasClients) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // 다시 확인하여 안전하게 스크롤 이동
          if (!_isDisposed && _scrollController.hasClients) {
            try {
              _scrollController.animateTo(
                0.0,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            } catch (e) {
              // 스크롤 컨트롤러 관련 오류 무시
              print('스크롤 리셋 중 오류 발생: $e');
            }
          }
        });
      }
    } catch (e) {
      // 에러 처리
      print('데이터 리로드 중 오류 발생: $e');
    }
  }

  Color getAppBarColor() {
    final primaryType = _pokemonDetail?.types[0].toLowerCase();
    return pokemonTypeColors[primaryType] ?? Colors.red;
  }

  // 타입 별 색상 처리 로직
  List<TextSpan> getTypeColoredTextSpans() {
    if (_isDisposed || _pokemonDetail == null) return [];
    return _pokemonDetail!.types.join(', ').toTypeColoredText();
  }

  // 이브이 특별 처리 확인 메서드
  bool isEeveeEvolutionCase(int currentPokemonId) {
    if (_isDisposed) return false;
    return evolutionChain != null &&
        evolutionChain!.isNotEmpty &&
        evolutionChain![0].name.toLowerCase() == 'eevee' &&
        currentPokemonId == evolutionChain![0].id;
  }

  // 이브이를 제외한 진화형 목록 반환
  List<EvolutionStage> getEeveeEvolutions() {
    if (_isDisposed || evolutionChain == null || evolutionChain!.isEmpty) {
      return [];
    }
    // 이브이(첫 번째)를 제외한 모든 진화형 반환
    return evolutionChain!.length > 1 ? evolutionChain!.sublist(1) : [];
  }

  // 진화 단계 클릭 처리 메서드
  void navigateToEvolution(BuildContext context, EvolutionStage evolution) {
    // 네비게이션 전에 필요한 데이터를 로컬 변수에 저장하여 ViewModel이 폐기된 후에도 사용 가능하게 함
    final evolutionId = evolution.id;
    final evolutionName = evolution.name;
    final isDark =
        Theme.of(context).colorScheme.surface.computeLuminance() <= 0.5;

    // 네비게이션 로직
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => PokedexScreen(
              pokedex: PokedexEntry(
                id: evolutionId,
                name: evolutionName,
                url: 'https://pokeapi.co/api/v2/pokemon-species/$evolutionId/',
              ),
              isDarkMode: isDark,
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

  // 포켓몬 이름 포맷팅
  String getFormattedTitle(String name) {
    return 'No.$pokemonId   ${name.capitalize()}';
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

  // 리소스 정리를 위한 dispose 메서드 구현
  @override
  void dispose() {
    // 플래그를 먼저 설정
    _isDisposed = true;

    // 안전하게 컨트롤러 해제
    if (_scrollController.hasClients) {
      try {
        _scrollController.dispose();
      } catch (e) {
        print('ScrollController 해제 중 오류: $e');
      }
    }

    // 참조 해제
    _pokemonDetail = null;
    _evolutionChain = null;

    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    } else {
      print('경고: disposed된 ViewModel에서 notifyListeners() 호출됨');
    }
  }
}

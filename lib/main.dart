import 'package:flutter/material.dart';
import 'package:poke_master/repositories/pokemon_repository.dart';
import 'package:poke_master/viewmodels/bookmark_viewmodel.dart';
import 'package:poke_master/viewmodels/pokemon_list_viewmodel.dart';
import 'package:poke_master/views/screens/pokemon_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final repository = PokemonRepository();
  final viewModel = PokemonListViewModel(repository);
  await viewModel.loadInitialPokemons();
  await initialization(viewModel);

  runApp(
    MultiProvider(
      providers: [
        Provider<PokemonRepository>(create: (_) => repository),
        ChangeNotifierProvider<BookmarkViewModel>(
          create: (_) => BookmarkViewModel(repository: repository),
        ),
        ChangeNotifierProvider<PokemonListViewModel>(
          create: (_) => PokemonListViewModel(repository),
        ),
        ChangeNotifierProvider<PokemonListViewModel>(
          create: (_) => viewModel, // 미리 생성된 viewModel 사용
        ),
      ],
      child: MyApp(repository: repository),
    ),
  );
}

Future<void> initialization(PokemonListViewModel viewModel) async {
  await Future.delayed(Duration(seconds: 2)); // 최소 딜레이 추가
  FlutterNativeSplash.remove();
}

class MyApp extends StatefulWidget {
  final PokemonRepository repository;

  const MyApp({super.key, required this.repository});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTheme(); // 앱 시작 시 테마 불러오기
  }

  // 테마 토글 메서드
  void _toggleTheme(bool isDark) {
    setState(() {
      _isDarkMode = isDark;
      _saveTheme(_isDarkMode); // 테마 변경 시 저장 호출
    });
  }

  // SharedPreferences에서 테마 상태 불러오기
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  // SharedPreferences에 테마 상태 저장하기
  Future<void> _saveTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Poke Master',
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Provider<PokemonRepository>.value(
        value: widget.repository,
        child: PokemonListScreen(_isDarkMode, onThemeChanged: _toggleTheme),
      ),
    );
  }
}

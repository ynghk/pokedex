import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:poke_master/repositories/pokemon_repository.dart';
import 'package:poke_master/viewmodels/bookmark_viewmodel.dart';
import 'package:poke_master/viewmodels/login_viewmodel.dart';
import 'package:poke_master/viewmodels/pokemon_list_viewmodel.dart';
import 'package:poke_master/views/screens/pokemon_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  //Firebase 초기화
  await Firebase.initializeApp();

  final repository = PokemonRepository();
  final viewModel = PokemonListViewModel(repository);
  await viewModel.loadInitialPokemons();

  // SharedPreferences에서 다크 모드 상태 가져와 초기화
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode =
      prefs.getBool('isDarkMode') ??
      (WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark);
  viewModel.initDarkMode(isDarkMode); // 앱 시작 시 다크 모드 초기화

  await Future.delayed(Duration(seconds: 2)); // 최소 딜레이 추가
  FlutterNativeSplash.remove();

  runApp(
    MultiProvider(
      providers: [
        Provider<PokemonRepository>(create: (_) => repository),
        ChangeNotifierProvider<BookmarkViewModel>(
          create: (_) => BookmarkViewModel(repository: repository),
        ),
        ChangeNotifierProvider<PokemonListViewModel>(
          create: (_) => viewModel, // 미리 생성된 viewModel 사용
        ),
        ChangeNotifierProvider<LoginViewModel>(create: (_) => LoginViewModel()),
      ],
      child: MyApp(repository: repository, initialDarkMode: isDarkMode),
    ),
  );
}

class MyApp extends StatefulWidget {
  final PokemonRepository repository;
  final bool initialDarkMode;
  const MyApp({
    super.key,
    required this.repository,
    required this.initialDarkMode,
  });

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.initialDarkMode;
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
      _isDarkMode = prefs.getBool('isDarkMode') ?? widget.initialDarkMode;
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
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Provider<PokemonRepository>.value(
        value: widget.repository,
        child: PokemonListScreen(
          isDarkMode: _isDarkMode,
          onThemeChanged: _toggleTheme,
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     title: 'Poke Master',
  //     theme: ThemeData.light(),
  //     darkTheme: ThemeData.dark(),
  //     themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
  //     home: Provider<PokemonRepository>.value(
  //       value: widget.repository,
  //       child: AuthScreen(
  //         isDarkMode: _isDarkMode,
  //         onThemeChanged: _toggleTheme,
  //         repository: widget.repository,
  //       ),
  //     ),
  //   );
  // }
}

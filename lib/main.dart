import 'package:flutter/material.dart';
import 'package:poke_master/repositories/pokemon_repository.dart';
import 'package:poke_master/viewmodels/bookmark_viewmodel.dart';
import 'package:poke_master/viewmodels/pokemon_list_viewmodel.dart';
import 'package:poke_master/views/screens/pokemon_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

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

  void _toggleTheme(bool isDark) {
    setState(() {
      _isDarkMode = isDark;
    });
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

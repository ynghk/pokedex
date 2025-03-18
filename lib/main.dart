import 'package:flutter/material.dart';
import 'package:pokedex_app/repositories/pokemon_repository.dart';
import 'package:pokedex_app/viewmodels/bookmark_viewmodel.dart';
import 'package:pokedex_app/viewmodels/pokemon_list_viewmodel.dart';
import 'package:pokedex_app/views/screens/pokemon_list_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repository = PokemonRepository();

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
      ],
      child: MyApp(repository: repository),
    ),
  );
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
      title: 'Pokedex App',
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Provider<PokemonRepository>.value(
        value: widget.repository,
        child: PokemonListScreen(_isDarkMode, onThemeChanged: _toggleTheme),
      ),
    );
  }
}

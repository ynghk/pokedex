import 'package:flutter/material.dart';
import 'package:pokedex_app/repositories/pokemon_repository.dart';
import 'package:pokedex_app/views/screens/pokemon_list_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  final repository = PokemonRepository();

  runApp(
    Provider<PokemonRepository>.value(
      value: repository,
      child: MyApp(repository: repository),
    ),
  );
}

class MyApp extends StatefulWidget {
  final PokemonRepository repository;

  const MyApp({Key? key, required this.repository}) : super(key: key);

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
      title: 'Pokedex App',
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Provider<PokemonRepository>.value(
        value: widget.repository,
        child: PokemonListScreen(_isDarkMode, onThemeChanged: _toggleTheme),
      ),
    );
  }
}

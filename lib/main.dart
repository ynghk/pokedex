import 'package:flutter/material.dart';
import 'package:pokedex_app/screens/pokemon_list_screen.dart';
import 'package:pokedex_app/services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: PokemonListScreen());
  }
}

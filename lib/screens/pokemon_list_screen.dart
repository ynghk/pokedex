import 'package:flutter/material.dart';
import 'package:pokedex_app/models/pokemon_list_result.dart';
import 'package:pokedex_app/services/api_service.dart';

class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});

  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  late Future<List<PokemonListResult>> pokemons;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pokemons = ApiService().getKantoPokemonData();
    print(pokemons);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokedex', style: TextStyle(color: Colors.black)),
      ),
    );
  }
}

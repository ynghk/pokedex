import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poke_master/repositories/pokemon_repository.dart';
import 'package:poke_master/views/screens/login_screen.dart';
import 'package:poke_master/views/screens/pokemon_list_screen.dart';

class AuthScreen extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;
  final PokemonRepository repository;
  const AuthScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return PokemonListScreen(
              isDarkMode: isDarkMode,
              onThemeChanged: onThemeChanged,
            );
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}

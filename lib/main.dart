import 'package:flutter/material.dart';
import 'package:pokedex_app/screens/pokemon_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color _getTextColorBasedOnBackground(Color backgroundColor) {
    return backgroundColor.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;
  }

  bool isDarkMode = false;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.red,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.red,
          iconTheme: IconThemeData(color: Colors.white), // 모든 AppBar 뒤로가기 색상
          titleTextStyle: TextStyle(
            color: _getTextColorBasedOnBackground(Colors.redAccent),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        colorScheme: ColorScheme.light(
          primary: Colors.red,
          onPrimary: _getTextColorBasedOnBackground(
            Colors.red,
          ), // AppBar 텍스트 색상
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            color: _getTextColorBasedOnBackground(Colors.white), // 기본 텍스트 색상
          ),
        ),
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.redAccent,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.redAccent,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: _getTextColorBasedOnBackground(Colors.redAccent),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        colorScheme: ColorScheme.dark(
          primary: Colors.redAccent,
          onPrimary: _getTextColorBasedOnBackground(
            Colors.redAccent,
          ), // AppBar 텍스트 색상
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            color: _getTextColorBasedOnBackground(Colors.black), // 기본 텍스트 색상
          ),
        ),
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: PokemonListScreen(
        isDarkMode,
        onThemeChanged: (value) {
          setState(() {
            isDarkMode = value;
          });
        },
      ),
    );
  }
}

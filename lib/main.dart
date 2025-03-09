import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokedex_app/viewmodels/theme_viewmodel.dart';
import 'package:pokedex_app/views/screens/pokemon_list_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  // main 함수에서 비동기 작업을 위해 WidgetsFlutterBinding 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // 화면 방향을 세로 모드로 고정
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Color _getTextColorBasedOnBackground(Color backgroundColor) {
    return backgroundColor.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeViewModel(),
      child: Consumer<ThemeViewModel>(
        builder: (context, themeViewModel, child) {
          return MaterialApp(
            theme: ThemeData(
              brightness: Brightness.light,
              primaryColor: Colors.red,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.red,
                iconTheme: IconThemeData(
                  color: Colors.white,
                ), // 모든 AppBar 뒤로가기 색상
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
                  color: _getTextColorBasedOnBackground(
                    Colors.white,
                  ), // 기본 텍스트 색상
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
                  color: _getTextColorBasedOnBackground(
                    Colors.black,
                  ), // 기본 텍스트 색상
                ),
              ),
            ),
            themeMode:
                themeViewModel.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: PokemonListScreen(
              themeViewModel.isDarkMode,
              onThemeChanged: themeViewModel.toggleTheme,
            ),
          );
        },
      ),
    );
  }
}

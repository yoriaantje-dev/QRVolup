import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const FlutterApp());
}

class FlutterApp extends StatelessWidget {
  const FlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.red,
        ),
        primaryColorDark: Colors.red.shade800,
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.red,
        ),
        primaryColorDark: Colors.red.shade800,
      ),
    );
  }
}

extension DarkMode on BuildContext {
  bool get isDarkMode {
    final brightness = MediaQuery.of(this).platformBrightness;
    return brightness == Brightness.dark;
  }

  Color snackbarTextColor() => isDarkMode ? Colors.black : Colors.white;
  Color snackbarBackgroundColor() => isDarkMode ? Colors.white : Colors.grey;
}

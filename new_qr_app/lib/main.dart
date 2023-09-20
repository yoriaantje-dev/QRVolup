import 'package:flutter/material.dart';
import 'package:new_qr_app/data/file_helper.dart';
import 'package:new_qr_app/screens/qr_screens/barcode_scanner_zoom.dart';
import 'package:new_qr_app/screens/home_screen.dart';

// DebugConsole Filter:
// !I/Flutter, !D/Input, !D/Surface, !I/View

void main() {
  runApp(const FlutterApp());
}

class FlutterApp extends StatelessWidget {
  const FlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(storage: FileStorage()),
        '/scanner': (context) => const BarcodeScannerWithZoom(),
      },
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


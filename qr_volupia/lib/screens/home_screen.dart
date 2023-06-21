import 'package:flutter/material.dart';
import '../data/file_helper.dart';
import '../shared/menu_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController prefixController = TextEditingController();
  FileHelper helper = FileHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Standaard turf items")),
      drawer: const MenuDrawer(),
      body: const Placeholder(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:new_qr_app/data/file_helper.dart';
import 'package:new_qr_app/screens/home_screen.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Reading and Writing Files',
      home: HomeScreen(storage: FileStorage())),
    );
}
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_volupia/main.dart';

import '../shared/barcode_scanner.dart';
import '../shared/menu_drawer.dart';
import '../data/file_helper.dart';
import '../data/models/participant_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  String scanResult = "NO_SCAN";
  List<Participant> participantList = [];

  File? file;
  FileHelper helper = FileHelper();

  void _loadFromFile() async {
    if (file == null) {
      List<File> files = await helper.getFiles();
      setState(() {
        file = files.first;
      });
    }
    if (file != null) {
      String jsonString = await helper.readFromFile(file!);
      Map<String, dynamic> mappedJson = jsonDecode(jsonString);
      for (Map<String, dynamic> participantMap
          in mappedJson["participantList"]) {
        setState(() {
          participantList.add(Participant.fromJSON(participantMap));
        });
      }
      _showSnackBar("Loaded from file");
      if (kDebugMode) print("Loaded from file");
    } else {
      _showSnackBar("Load failed");
    }
  }

  void _saveList({silent = false}) async {
    List<Map<String, dynamic>> saveList = [];
    for (Participant participant in participantList) {
      saveList.add(participant.toMap());
    }
    Map<String, dynamic> saveMap = {"participantList": saveList};
    helper.writeToFile("participantStorage", jsonEncode(saveMap));
    if (!silent) _showSnackBar("Saved to file.");
    if (kDebugMode) print("Saved to file.");
  }

  void _showScannedName(String name) {
    _showSnackBar("QR Code for: $name");
  }

  void _showSnackBar(String text) {
    SnackBar snackBar = SnackBar(
      content: Text(
        text,
        style: TextStyle(color: context.snackbarTextColor()),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: context.snackbarBackgroundColor(),
    );
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void handleQRScanned() async {
    String scannedName = (await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const BarcodeScannerWithoutController(),
          ),
        ) ??
        "SCAN FAILED/ CANCELLED");
    _showScannedName(scannedName);
    setState(() {
      scanResult = scannedName;
    });

    int index = 0;
    for (Participant participant in participantList) {
      if (participant.name == scannedName) {
        setState(() {
          try {
            participantList[index].checkedIn = true;
          } catch (e) {
            if (kDebugMode) {
              print(
                  "Error looking in participantlist.\nCould not find $scannedName in participants or:\n $e");
            }
          }
        });
      }
      if (index != participantList.length - 1) {
        index++;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadFromFile();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _saveList(silent: true);
  }

  @override
  void dispose() {
    _saveList(silent: true);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void deactivate() {
    _saveList(silent: true);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    if (participantList == List.empty()) _loadFromFile();

    return Scaffold(
      appBar: AppBar(title: const Text("Aftekenlijst")),
      drawer: const MenuDrawer(),
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.redAccent,
        ),
        child: IconButton(
          iconSize: 40,
          icon: const Icon(Icons.camera),
          onPressed: () {
            handleQRScanned();
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text("Laatste scan: $scanResult"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: participantList.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  color: participantList[index].checkedIn
                      ? Colors.green[900]
                      : Colors.red[900],
                  key: Key(participantList[index].name),
                  child: ListTile(
                    title: Text(participantList[index].name),
                    subtitle: Text("Leeftijd: ${participantList[index].age}"),
                    trailing: Switch(
                      activeColor: Colors.white,
                      value: participantList[index].checkedIn,
                      onChanged: (bool value) {
                        setState(() {
                          participantList[index].checkedIn = value;
                        });
                        _saveList(silent: true);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

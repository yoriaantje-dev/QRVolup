import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../data/file_helper.dart';
import '../data/models/participant_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.storage});

  final FileStorage storage;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  String scanResult = "NO_SCAN";
  List<Participant> participantList = [];

  void _loadFromFile() async {
    String jsonString = await widget.storage.readFileAsString();
    Map<String, dynamic> mappedJson = jsonDecode(jsonString);
    for (Map<String, dynamic> participantMap in mappedJson["participantList"]) {
      setState(() {
        participantList.add(Participant.fromJSON(participantMap));
      });
    }
    if (kDebugMode) print("Loaded from file.");
  }

  void _saveList({silent = false}) async {
    List<Map<String, dynamic>> saveList = [];
    for (Participant participant in participantList) {
      saveList.add(participant.toMap());
    }
    Map<String, dynamic> saveMap = {"participantList": saveList};
    widget.storage.writeFile(jsonEncode(saveMap));
    if (kDebugMode) print("Saved to file.");
  }

  // TODO: Change to ENUMRATE XD
  void checkScanResult(String scannedName) {
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

  // TODO: https://pub.dev/packages/mobile_scanner
  void handleQRScanned() async {
    String scannedName = (await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const BarcodeScannerWithoutController(),
          ),
        ) ??
        "SCAN MISLUKT/ GEANNULEERD");
    // _showScannedName(scannedName);
    setState(() {
      scanResult = scannedName;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (participantList == List.empty()) _loadFromFile();

    return Scaffold(
      appBar: AppBar(title: const Text("Aftekenlijst")),
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: SingleChildScrollView(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
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
                        subtitle:
                            Text("Leeftijd: ${participantList[index].age}"),
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
            ),
          ),
        ],
      ),
    );
  }
}

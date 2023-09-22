import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:Volupia_QR_Checker/flow_menu.dart';

import '../data/file_helper.dart';
import '../data/models/participant_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.storage});

  final FileStorage storage;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  String scanResult = "";
  Participant lastScannedParticipant = Participant("NONE");
  List<Participant> participantList = [];

  List<Participant> _makeDefaultList() {
    List<Participant> defaultList = [];
    final Participant voorbeeldDeelnemer = Participant("Voorbeeld");
    defaultList.add(voorbeeldDeelnemer);
    return defaultList;
  }

  void _loadFromFile({bool reset = false}) async {
    String jsonString = await widget.storage.readFileAsString();
    try {
      Map<String, dynamic> mappedJson = jsonDecode(jsonString);
      for (Map<String, dynamic> participantMap
          in mappedJson["participantList"]) {
        setState(() {
          participantList.add(Participant.fromJSON(participantMap));
        });
      }
    } catch (e) {
      setState(() {
        participantList = _makeDefaultList();
      });
      if (kDebugMode) print("Error: $e\n" "Loaded from defaults.");
    }

    // if (participantList.isEmpty || reset) {
    if (reset) {
      setState(() {
        participantList = _makeDefaultList();
      });
    } else if (kDebugMode) {
      print("Loaded from file.");
    }
  }

  void removeDuplicateParticipants() {
    final nameSet = <String>{};
    final noDuplicateList = <Participant>[];
    for (final participant in participantList) {
      if (nameSet.add(participant.name.trim())) {
        noDuplicateList.add(participant);
      }
    }
    setState(() {
      participantList = noDuplicateList;
    });
  }

  void _saveList({bool reset = false}) async {
    if (reset) {
      setState(() {
        participantList = _makeDefaultList();
      });
    }
    removeDuplicateParticipants();

    List<Map<String, dynamic>> saveList = [];
    for (Participant participant in participantList) {
      saveList.add(participant.toMap());
    }
    Map<String, dynamic> saveMap = {"participantList": saveList};
    widget.storage.writeFile(jsonEncode(saveMap));
    if (kDebugMode) print("Saved to file.");
  }

  void _deleteList() {
    setState(() {
      participantList = [];
    });
    _saveList();
  }

  void removeParticipantAtIndex(int index) async {
    bool confirmed = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Verwijder ${participantList[index].name}"),
          content: Text("Weet je zeker dat je '${participantList[index].name}' wilt verwijderen?"),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuleren'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            ElevatedButton(
              child: const Text('Ja'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmed) {
      setState(() {
        participantList.removeAt(index);
      });
      _saveList();
    }
  }

  void checkScanResult(String scannedName) {
    for (final (index, participant) in participantList.indexed) {
      if (participant.name == scannedName) {
        setState(() {
          try {
            participantList[index].checkedIn = true;
            lastScannedParticipant = participantList[index];
            _saveList();
          } catch (e) {
            if (kDebugMode) {
              print("Error looking in participantlist.\n"
                  "Could not find $scannedName in participants or:\n"
                  "$e");
            }
          }
        });
      }
    }
  }

  void functionCapture() async {
    var scannedQR = await Navigator.pushNamed(context, "/scanner");
    String scannedName = scannedQR.toString().trim().toLowerCase();
    checkScanResult(scannedName);
    setState(() {
      scanResult = scannedName;
    });
  }

  void functionAddParticipant(String input) async {
    if (input.isNotEmpty) {
      setState(() {
        participantList.add(Participant(input.trim().toLowerCase()));
      });
      removeDuplicateParticipants();
      _saveList();
    }
  }

  void functionAddParticipantList(String input) {
    if (input.isNotEmpty) {
      List<String> participantStringList = input.split(",");
      for (String participant in participantStringList) {
        setState(() {
          List<String> participantInfo = participant.split("-");
          participantList.add(Participant(participantInfo[0], participantInfo[1]));
        });
      }
      removeDuplicateParticipants();
      _saveList();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (participantList.isEmpty) {
      _loadFromFile(reset: false);
    } else {
      _saveList(reset: false);
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Aftekenlijst")),
      floatingActionButton: floatingActionMenu(
        context,
        functionCapture,
        _saveList,
        _deleteList,
        functionAddParticipant,
        functionAddParticipantList,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: scanResult.isNotEmpty
                ? Text("Laatste scan: $scanResult --> Nu (${lastScannedParticipant.checkedIn ? 'Ingecheckt' : 'Niet gevonden/ error'})")
                : Container(),
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
                    return participantCard(index);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget participantCard(int index) {
    return Card(
      color: participantList[index].checkedIn
          ? Colors.green[900]
          : Colors.red[900],
      key: Key(participantList[index].name),
      child: ListTile(
        title: Text(
          participantList[index].name,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          "Gezien: ${participantList[index].checkedIn ? 'ja' : 'nee'}",
          style: TextStyle(color: Colors.grey[300]),
        ),
        trailing: Switch(
          activeColor: Colors.white,
          value: participantList[index].checkedIn,
          onChanged: (bool value) {
            setState(() {
              participantList[index].checkedIn = value;
            });
            _saveList();
          },
        ),
        onLongPress: () => removeParticipantAtIndex(index),
      ),
    );
  }
}

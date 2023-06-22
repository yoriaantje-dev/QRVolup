import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_volupia/main.dart';

import '../screens/widgets/flow_menu.dart';
import '../data/file_helper.dart';
import '../data/models/participant_model.dart';
import '../shared/menu_drawer.dart';

class ManagementScreen extends StatefulWidget {
  const ManagementScreen({super.key});

  @override
  State<ManagementScreen> createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen>
    with WidgetsBindingObserver {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  File? file;
  FileHelper helper = FileHelper();
  List<Participant> participantList = [];

  checkUnfocus() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

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

  void _addParticipant({
    String name = "",
    int age = 99,
    Participant? providedParticipant,
  }) {
    setState(() {
      participantList.add(providedParticipant ??= Participant(name, age));
    });
  }

  void _massAddParticipants(String commaSeperatedListNameAge) {
    List<String> participantNameAgeList =
        commaSeperatedListNameAge.split(",");
    for (String participantInfo in participantNameAgeList) {
      List<String> participantInfoList = participantInfo.split("_");
      Participant newParticipant = Participant(
          participantInfoList[0], int.tryParse(participantInfoList[1]) ?? 99);
      setState(() {
        participantList.add(newParticipant);
      });
    }
  }

  void _removeParticipant(int index) {
    setState(() {
      participantList.removeAt(index);
    });
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

  @override
  void initState() {
    super.initState();
    _loadFromFile();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _saveList();
  }

  @override
  void dispose() {
    _saveList();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void deactivate() {
    _saveList();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    if (participantList == List.empty()) _loadFromFile();

    return Scaffold(
      appBar: AppBar(title: const Text("Beheer deelnemers")),
      drawer: const MenuDrawer(),
      floatingActionButton: floatingActionMenu(
        context,
        _addParticipant,
        _massAddParticipants,
        _saveList,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              "Gebruiker toevoegen: ",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const SizedBox(width: 60, child: Text("Naam: ")),
                  Expanded(
                    child: TextField(
                      controller: nameController,
                      onTapOutside: (event) => checkUnfocus(),
                      decoration: const InputDecoration(hintText: "Naam"),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const SizedBox(width: 60, child: Text("Leeftijd: ")),
                  Expanded(
                    child: TextField(
                      controller: ageController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}'))
                      ],
                      onTapOutside: (event) => checkUnfocus(),
                      decoration: const InputDecoration(hintText: "Leeftijd"),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _addParticipant(
                  age: int.tryParse(ageController.text.trim()) ?? 99,
                  name: nameController.text,
                );
              },
              child: const Text("Voeg toe"),
            ),
            Text(
              "Huidige gebruikers: ",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: SingleChildScrollView(
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: participantList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Card(
                          color: Colors.red,
                          key: Key(participantList[index].name),
                          child: ListTile(
                            title: Text("Naam: ${participantList[index].name}"),
                            subtitle: Text("Leeftijd: ${participantList[index].age}"),
                            trailing: IconButton(
                              color: Colors.white,
                              icon: const Icon(Icons.delete),
                              onPressed: () => _removeParticipant(index),
                            ),
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
      ),
    );
  }
}

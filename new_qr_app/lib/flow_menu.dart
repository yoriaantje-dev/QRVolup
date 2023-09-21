import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:Volupia_QR_Checker/main.dart';

Color? dialMainOverlayColor(bool isDarkMode) =>
    isDarkMode ? Colors.grey[900] : Colors.grey[300];
Color? dialMainBackgroundColor(bool isDarkMode) =>
    isDarkMode ? Colors.red[600] : Colors.redAccent[200];
Color? dialLabelBackgroundColor(bool isDarkMode) =>
    isDarkMode ? Colors.grey[600] : Colors.grey[200];
Color? dialButtonBackgroundColor(bool isDarkMode) =>
    isDarkMode ? Colors.red[400] : Colors.red[200];

Widget floatingActionMenu(
  BuildContext context,
  dynamic functionCapture,
  dynamic functionSave,
  dynamic functionDelete,
  dynamic functionAddParticipant,
  dynamic functionAddParticipantList,
) {
  final TextEditingController textFieldController = TextEditingController();

  return SpeedDial(
    icon: Icons.camera,
    onPress: functionCapture,
    activeIcon: Icons.close_fullscreen_rounded,
    overlayColor: dialMainOverlayColor(context.isDarkMode),
    backgroundColor: dialMainBackgroundColor(context.isDarkMode),
    foregroundColor: Colors.white,
    children: [
      SpeedDialChild(
        backgroundColor: dialButtonBackgroundColor(context.isDarkMode),
        foregroundColor: Colors.white,
        child: const Icon(Icons.person_add_alt_sharp),
        labelWidget: Container(
          decoration: BoxDecoration(
              color: dialLabelBackgroundColor(context.isDarkMode),
              borderRadius: const BorderRadius.all(Radius.circular(7))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Deelnemer toevoegen",
              style: TextStyle(
                  color: context.isDarkMode ? Colors.white : Colors.black),
            ),
          ),
        ),
        onTap: () async {
          await _displayTextInputDialog(
            context,
            textFieldController,
            "Deelnemer toevoegen",
            "Voornaam Achternaam",
          );
          functionAddParticipantList(textFieldController.text);
        },
      ),
      SpeedDialChild(
        backgroundColor: dialButtonBackgroundColor(context.isDarkMode),
        foregroundColor: Colors.white,
        child: const Icon(Icons.group_add),
        labelWidget: Container(
          decoration: BoxDecoration(
              color: dialLabelBackgroundColor(context.isDarkMode),
              borderRadius: const BorderRadius.all(Radius.circular(7))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Deelnemerlijst toevoegen",
              style: TextStyle(
                  color: context.isDarkMode ? Colors.white : Colors.black),
            ),
          ),
        ),
        onTap: () async {
          await _displayTextInputDialog(
            context,
            textFieldController,
            "Deelnemers toevoegen",
            "Voornaam Achternaam, VolgendeVoornaam Volgende Achternaam, VolgendeVoornaam Volgende Achternaam, etc.",
          );
          functionAddParticipantList(textFieldController.text);
        },
      ),
      SpeedDialChild(
        backgroundColor: dialButtonBackgroundColor(context.isDarkMode),
        foregroundColor: Colors.white,
        child: const Icon(Icons.save),
        labelWidget: Container(
          decoration: BoxDecoration(
              color: dialLabelBackgroundColor(context.isDarkMode),
              borderRadius: const BorderRadius.all(Radius.circular(7))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Opslaan",
              style: TextStyle(
                  color: context.isDarkMode ? Colors.white : Colors.black),
            ),
          ),
        ),
        onTap: functionSave,
      ),
      SpeedDialChild(
        backgroundColor: dialButtonBackgroundColor(context.isDarkMode),
        foregroundColor: Colors.white,
        child: const Icon(Icons.delete),
        labelWidget: Container(
          decoration: BoxDecoration(
              color: dialLabelBackgroundColor(context.isDarkMode),
              borderRadius: const BorderRadius.all(Radius.circular(7))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Delete",
              style: TextStyle(
                  color: context.isDarkMode ? Colors.white : Colors.black),
            ),
          ),
        ),
        onTap: functionDelete,
      ),
    ],
  );
}

Future<void> _displayTextInputDialog(
  BuildContext context,
  TextEditingController textFieldController,
  String title,
  String hint,
) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: TextField(
          controller: textFieldController,
          decoration: InputDecoration(hintText: hint),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ],
      );
    },
  );
}

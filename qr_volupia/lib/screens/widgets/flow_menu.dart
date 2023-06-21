import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:qr_volupia/data/models/participant_model.dart';
import 'package:qr_volupia/main.dart';
import 'package:qr_volupia/shared/popup_dialog.dart';

Color? dialMainOverlayColor(bool isDarkMode) =>
    isDarkMode ? Colors.grey[900] : Colors.grey[300];
Color? dialMainBackgroundColor(bool isDarkMode) =>
    isDarkMode ? Colors.red[600] : Colors.redAccent[200];
Color? dialLabelBackgroundColor(bool isDarkMode) =>
    isDarkMode ? Colors.grey[600] : Colors.grey[200];
Color? dialButtonBackgroundColor(bool isDarkMode) =>
    isDarkMode ? Colors.red[400] : Colors.red[200];

Widget floatingActionMenu(BuildContext context, dynamic addParticipantFunction,
    dynamic saveFunction) {
  return SpeedDial(
    icon: Icons.save,
    activeIcon: Icons.close_fullscreen_rounded,
    onPress: () => saveFunction(),
    overlayColor: dialMainOverlayColor(context.isDarkMode),
    backgroundColor: dialMainBackgroundColor(context.isDarkMode),
    foregroundColor: Colors.white,
    children: [
      SpeedDialChild(
        backgroundColor: dialButtonBackgroundColor(context.isDarkMode),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
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
          addParticipantFunction(
            providedParticipant: await showDialog<Participant>(
              context: context,
              builder: (context) => const AddParticipantDialog(),
            ),
          );
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
        onTap: saveFunction,
      ),
    ],
  );
}

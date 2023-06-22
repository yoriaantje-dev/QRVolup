import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_volupia/data/models/participant_model.dart';
import 'package:qr_volupia/main.dart';

class AddParticipantDialog extends StatefulWidget {
  const AddParticipantDialog({super.key});

  @override
  State<AddParticipantDialog> createState() => _AddParticipantDialogState();
}

class _AddParticipantDialogState extends State<AddParticipantDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _onSavePressed(BuildContext context) {
    final name = _nameController.text.trim();
    final int age = int.tryParse(_ageController.text.trim()) ?? 99;

    if (name.isNotEmpty && age > 0) {
      final newParticipant = Participant(name, age);
      Navigator.of(context).pop(newParticipant);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Voer een naam en leeftijd in."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Deelnemer Toevoegen"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            autofocus: true,
            decoration: const InputDecoration(hintText: "Naam"),
          ),
          TextField(
            controller: _ageController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
            ],
            decoration: const InputDecoration(hintText: "Leeftijd"),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('ANNULEREN'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: context.isDarkMode
                ? MaterialStatePropertyAll<Color>(Colors.red.shade800)
                : const MaterialStatePropertyAll<Color>(Colors.red),
          ),
          child: const Text('OPSLAAN'),
          onPressed: () {
            _onSavePressed(context);
          },
        ),
      ],
    );
  }
}

class MassAddParticipantsDialog extends StatefulWidget {
  const MassAddParticipantsDialog({super.key});

  @override
  State<MassAddParticipantsDialog> createState() => _MassAddParticipantsDialogState();
}

class _MassAddParticipantsDialogState extends State<MassAddParticipantsDialog> {
    final TextEditingController _massInputController = TextEditingController();

  @override
  void dispose() {
    _massInputController.dispose();
    super.dispose();
  }

  void _onSavePressed(BuildContext context) {
    final input = _massInputController.text.trim();

    if (input.isNotEmpty) {
      Navigator.of(context).pop(input);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invoer incorrect/ onvolledig!"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Deelnemer Toevoegen"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Het formaat is: Deelnemer1Voornaam Deelnemer1Achternaam_Deelnemer1Leeftijd,Deelnemer2Voornaam Deelnemer2Achternaam_Deelnemer2Leeftijd,Deelnemer3Voornaam Deelnemer3Achternaam_Deelnemer3Leeftijd"),
          TextField(
            controller: _massInputController,
            autofocus: true,
            decoration: const InputDecoration(hintText: "Deelnemer1Voornaam Deelnemer1Achternaam_Deelnemer1Leeftijd,Deelnemer2Voornaam Deelnemer2Achternaam_Deelnemer2Leeftijd"),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('ANNULEREN'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: context.isDarkMode
                ? MaterialStatePropertyAll<Color>(Colors.red.shade800)
                : const MaterialStatePropertyAll<Color>(Colors.red),
          ),
          child: const Text('TOEVOEGEN'),
          onPressed: () {
            _onSavePressed(context);
          },
        ),
      ],
    );
  }
}
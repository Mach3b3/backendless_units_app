// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:units_app/models/units.dart';
import 'package:units_app/services/units_service.dart';
import 'package:units_app/services/user_management.dart';
import 'package:units_app/widgets/dialogs.dart';

// Refreshes the units in the UI by fetching them from the database
void refreshUnitsInUI(BuildContext context) async {
  String result = await context.read<UnitService>().getUnits(
        context.read<UserManagement>().currentUser!.email,
      );

  if (result != 'OK') {
    showSnackBar(context, result);
  } else {
    showToast('Data successfully retrieved from the database.');
  }
}

// Saves all units in the UI to the database
void saveAllUnitsInUI(BuildContext context) async {
  String result = await context
      .read<UnitService>()
      .saveUnitEntry(context.read<UserManagement>().currentUser!.email, true);

  if (result != 'OK') {
    showSnackBar(context, result);
  } else {
    showToast('Data successfully saved online');
  }
}

// Creates a new unit in the UI
void createNewUnitInUI(
  BuildContext context, {
  required TextEditingController unitdesccontroller,
  required TextEditingController reflectionscontroller,
}) async {
  if (unitdesccontroller.text.isEmpty || reflectionscontroller.text.isEmpty) {
    showToast('Please enter a unit first, then save!');
  } else {
    Units unit = Units(
      unitDesc: unitdesccontroller.text.trim(),
      reflections: reflectionscontroller.text.trim(),
    );

    // Check if the unit already exists in the units list
    if (context.read<UnitService>().units.contains(unit)) {
      showDialogBox(context, 'Duplicate value. Please try again.');
    } else {
      unitdesccontroller.text = '';
      reflectionscontroller.text = '';

      // Create the unit and add it to the units list
      context.read<UnitService>().createUnit(unit);
      Navigator.pop(context); // Close the current screen/dialog
    }
  }
}

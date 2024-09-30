import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/material.dart';
import 'package:units_app/models/unit_entry.dart';
import 'package:units_app/models/units.dart';

class UnitService with ChangeNotifier {
  UnitEntry?
      _unitsEntry; // Holds the UnitsEntry object retrieved from the backend
  late Units currentUnits; // Holds the currently selected Units object

  List<Units> _units = []; // Holds the list of Units objects
  List<Units> get units => _units; // Getter for the units list

  void emptyUnits() {
    _units = []; // Clears the units list
    notifyListeners();
  }

  bool _busyRetrieving =
      false; // Flag to indicate if units retrieval is in progress
  bool _busySaving = false; // Flag to indicate if units saving is in progress

  bool get busyRetrieving => _busyRetrieving; // Getter for busyRetrieving flag
  bool get busySaving => _busySaving;

  Future<String> getUnits(
    String username,
  ) async {
    String result = 'OK'; // Holds the result of the operation

    // Create a DataQueryBuilder to query the UnitsEntry table for a specific username
    DataQueryBuilder queryBuilder = DataQueryBuilder()
      ..whereClause = "username = '$username'";

    _busyRetrieving = true; // Set the busyRetrieving flag to true
    notifyListeners();

    // Retrieve the UnitsEntry object from the backend using Backendless SDK
    List<Map<dynamic, dynamic>?>? map = await Backendless.data
        .of('UnitEntry')
        .find(queryBuilder)
        .onError((error, stackTrace) {
      result = error.toString();
      return null; // Set the result to the error message if an error occurs
    });

    // Check the result of the operation
    if (result != 'OK') {
      _busyRetrieving = false; // Set the busyRetrieving flag to false
      notifyListeners();
      return result;
    }

    if (map != null) {
      if (map.isNotEmpty) {
        _unitsEntry = UnitEntry.fromJson(
            map.first); // Parse the UnitsEntry object from the retrieved map
        _units = convertMapToUnitList(_unitsEntry!
            .units); // Convert the units map to a list of Units objects
        notifyListeners();
      } else {
        emptyUnits(); // If no UnitsEntry object is found, empty the units list
      }
    } else {
      result =
          'NOT OK'; // Set the result to an error message if the retrieved map is null
    }
    _busyRetrieving = false; // Set the busyRetrieving flag to false
    notifyListeners();
    return result;
  }

  Future<String> saveUnitEntry(String username, bool inUI) async {
    String result = 'OK'; // Holds the result of the operation

    if (_unitsEntry == null) {
      _unitsEntry =
          UnitEntry(units: convertUnitListToMap(_units), username: username);
    } else {
      _unitsEntry!.units = convertUnitListToMap(_units);
    }

    if (inUI) {
      _busySaving = true; // Set the busySaving flag to true
      notifyListeners();
    }

    // Save the UnitsEntry object to the backend using Backendless SDK
    await Backendless.data
        .of('UnitEntry')
        .save(_unitsEntry!.toJson())
        .onError((error, stackTrace) {
      result = error.toString();
      return null; // Set the result to the error message if an error occurs
    });

    if (inUI) {
      _busySaving = false; // Set the busySaving flag to false
      notifyListeners();
    }

    return result;
  }

  void deleteUnit(Units unit) {
    _units.remove(unit); // Remove the specified unit from the units list
    notifyListeners();
  }

  void createUnit(Units unit) {
    _units.insert(0,
        unit); // Insert the specified unit at the beginning of the units list
    notifyListeners();
  }
}

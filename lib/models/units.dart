// This function converts a List of Units objects to a Map.
// ignore_for_file: avoid_renaming_method_parameters

Map<dynamic, dynamic> convertUnitListToMap(List<Units> units) {
  Map<dynamic, dynamic> map = {};

  // Iterate over each Units object in the list
  for (var i = 0; i < units.length; i++) {
    // Add the index as a string key and the serialized JSON representation of the Units object as the value to the map
    map.addAll({'$i': units[i].toJson()});
  }

  // Return the resulting map
  return map;
}

// This function converts a Map to a List of Units objects.
List<Units> convertMapToUnitList(Map<dynamic, dynamic> map) {
  List<Units> units = [];

  // Iterate over each entry in the map
  for (var i = 0; i < map.length; i++) {
    // Retrieve the serialized JSON representation of the Units object using the index as a string key
    // and convert it back to a Units object using the fromJson constructor
    units.add(Units.fromJson(map['$i']));
  }

  // Return the resulting list of Units objects
  return units;
}

// The Units class represents a unit with a description and reflections.
class Units {
  final String unitDesc;
  final String reflections;

  // Constructor for the Units class
  Units({
    required this.unitDesc,
    required this.reflections,
  });

  // This method serializes the Units object to a JSON-compatible Map.
  Map<String, Object?> toJson() => {
        'unitDesc': unitDesc,
        'reflections': reflections,
      };

  // This method deserializes a JSON-compatible Map back into a Units object.
  static Units fromJson(Map<dynamic, dynamic>? json) => Units(
        unitDesc: json!['unitDesc'] as String,
        reflections: json['reflections'] as String,
      );

  // Override the equality operator to compare Units objects.
  // Two Units objects are considered equal if their unitDesc values are the same (case-insensitive comparison).
  @override
  bool operator ==(covariant Units units) {
    return (unitDesc.toUpperCase().compareTo(units.unitDesc.toUpperCase()) ==
        0);
  }

  // Override the hashCode getter to ensure consistent hashing based on the unitDesc value.
  @override
  int get hashCode {
    return unitDesc.hashCode;
  }
}

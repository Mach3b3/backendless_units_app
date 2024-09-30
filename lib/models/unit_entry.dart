// ignore_for_file: file_names

// The UnitsEntry class represents an entry containing units, associated with a username and metadata.
class UnitEntry {
  Map<dynamic, dynamic> units; // A map representing the units
  String username; // The username associated with the units entry
  String? objectId; // An optional identifier for the object
  DateTime? created; // An optional DateTime indicating the creation time
  DateTime? updated; // An optional DateTime indicating the last update time

  // Constructor for the UnitsEntry class
  UnitEntry({
    required this.units,
    required this.username,
    this.objectId,
    this.created,
    this.updated,
  });

  // This method serializes the UnitsEntry object to a JSON-compatible Map.
  Map<String, Object?> toJson() => {
        'username': username,
        'Units': units,
        'created': created,
        'updated': updated,
        'objectId': objectId,
      };

  // This method deserializes a JSON-compatible Map back into a UnitsEntry object.
  static UnitEntry fromJson(Map<dynamic, dynamic>? json) => UnitEntry(
        username: json!['username'] as String,
        units: json['units'] as Map<dynamic, dynamic>,
        objectId: json['objectId'] as String?,
        created: json['created'] as DateTime?,
      );
}

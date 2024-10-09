import 'person.dart';

enum VehicleType { car, motorcycle, other }

String idGenerator() {
  final now = DateTime.now();
  return now.microsecondsSinceEpoch.toString();
}

class Vehicle {
  Vehicle({
    required this.regNr,
    required this.vehicleType,
    required this.owner,
    String? id,
  }) : id = id ?? idGenerator();

  final String id;
  final String regNr;
  final VehicleType vehicleType;
  final Person owner;
}

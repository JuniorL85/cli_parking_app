import 'person.dart';

enum VehicleType { car, motorcycle, other }

class Vehicle {
  Vehicle({
    required this.regNr,
    required this.vehicleType,
    required this.owner,
  });

  final String regNr;
  final VehicleType vehicleType;
  final Person owner;
}

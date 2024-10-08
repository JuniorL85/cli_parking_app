import '../logic/set_main.dart';
import '../models/person.dart';
import '../models/vehicle.dart';

class VehicleRepository extends SetMain {
  VehicleRepository._privateConstructor();

  static final instance = VehicleRepository._privateConstructor();

  List<Vehicle> vehicleList = [
    Vehicle(
      regNr: 'CDF990',
      vehicleType: VehicleType.car,
      owner: Person(
        name: 'Anders Andersson',
        socialSecurityNumber: '197811112222',
      ),
    )
  ];

  void addVehicle(Vehicle Vehicle) {
    vehicleList.add(Vehicle);
  }

  void getAllVehicles() {
    if (vehicleList.isNotEmpty) {
      for (var (index, vehicle) in vehicleList.indexed) {
        print(
            '${index + 1}. RegNr: ${vehicle.regNr}, Ägare: ${vehicle.owner.name}-${vehicle.owner.socialSecurityNumber} Typ: ${vehicle.vehicleType.name}');
      }
    } else {
      print('Finns inga fordon att visa just nu....');
    }
  }

  void updateVehicles(Vehicle vehicle, oldRegNr) {
    final foundVehicleIndex =
        vehicleList.indexWhere((v) => v.regNr == oldRegNr);

    if (foundVehicleIndex == -1) {
      getBackToMainPage(
          'Finns inget fordon med det angivna registreringsnumret');
    }

    vehicleList[foundVehicleIndex] = vehicle;
  }

  void deleteVehicle(String regNr) {
    final vehicleToDelete =
        vehicleList.firstWhere((vehicle) => vehicle.regNr == regNr);

    vehicleList.remove(vehicleToDelete);

    print(
        'Du har raderat följande fordon: ${vehicleToDelete.regNr} - ${vehicleToDelete.vehicleType.name}');
  }
}

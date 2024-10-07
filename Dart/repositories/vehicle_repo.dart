import '../logic/set_main.dart';
import '../models/person.dart';
import '../models/vehicle.dart';

class VehicleRepository {
  VehicleRepository._privateConstructor();

  static final instance = VehicleRepository._privateConstructor();

  final SetMain setMain = new SetMain();

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
    if (vehicleList.isEmpty) {
      print(
          'Finns inga fordon att uppdatera, testa att lägga till ett fordon först');
      setMain.setMainPage();
      return;
    }

    final foundVehicleIndex =
        vehicleList.indexWhere((v) => v.regNr == oldRegNr);

    if (foundVehicleIndex == -1) {
      print('Finns inget fordon med det angivna registreringsnumret');
      setMain.setMainPage();
      return;
    }

    vehicleList[foundVehicleIndex] = vehicle;
  }

  void deleteVehicle(String regNr) {
    if (vehicleList.isEmpty) {
      print(
          'Finns inga personer att radera, testa att lägga till en person först');
      setMain.setMainPage();
      return;
    }
    final vehicleToDelete =
        vehicleList.firstWhere((person) => person.regNr == regNr);
    vehicleList.remove(vehicleToDelete);
    print(
        'Du har raderat följande fordon: ${vehicleToDelete.regNr} - ${vehicleToDelete.vehicleType.name}');
  }
}

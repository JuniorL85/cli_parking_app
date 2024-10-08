import '../logic/set_main.dart';
import '../models/parking.dart';
import 'parking_space_repo.dart';
import 'vehicle_repo.dart';

class ParkingRepository extends SetMain {
  ParkingRepository._privateConstructor();

  static final instance = ParkingRepository._privateConstructor();

  final VehicleRepository vehicleRepository = VehicleRepository.instance;
  final ParkingSpaceRepository parkingSpaceRepository =
      ParkingSpaceRepository.instance;

  List<Parking> parkingList = [];

  void addParking(String regNr, String parkingPlaceId, DateTime endTime) {
    try {
      final addVehicle = vehicleRepository.vehicleList
          .where((vehicle) => vehicle.regNr == regNr)
          .first;

      final addParkingSpace = parkingSpaceRepository.parkingSpaceList
          .where((p) => p.id == parkingPlaceId)
          .first;

      final addParking = Parking(
        vehicle: addVehicle,
        parkingSpace: addParkingSpace,
        startTime: DateTime.now(),
        endTime: endTime,
      );

      parkingList.add(addParking);
    } catch (err) {
      getBackToMainPage(
          'Det gick fel, du omdirigeras till startsidan, se till att du lagt till personer, fordon och parkeringsplatser innan du forsätter!');
    }
  }

  void getAllParkings() {
    if (parkingList.isNotEmpty) {
      for (var (index, park) in parkingList.indexed) {
        print(
            '${index + 1}. Id: ${park.id}, Parkering: ${park.parkingSpace.address}, Time (start and end): ${park.startTime}-${park.endTime}, RegNr: ${park.vehicle.regNr}');
      }
    } else {
      print('Inga parkeringar att visa för tillfället.....');
    }
  }

  void updateParkings(String parkingId, DateTime endTime) {
    if (parkingList.isEmpty) {
      getBackToMainPage(
          'Finns inga pågående parkeringar att uppdatera, testa att lägga till parkeringar först');
    }

    final foundParkingIndex = parkingList.indexWhere((v) => v.id == parkingId);

    if (foundParkingIndex == -1) {
      getBackToMainPage('Finns ingen parkering med det angivna id');
    }

    parkingList[foundParkingIndex].endTime = endTime;
  }

  void deleteParkings(String parkingId) {
    if (parkingList.isEmpty) {
      getBackToMainPage(
          'Finns inga pågående parkeringar att radera, testa att lägga till parkeringar först');
    }

    final foundParkingIndex = parkingList.indexWhere((v) => v.id == parkingId);

    if (foundParkingIndex == -1) {
      getBackToMainPage('Finns ingen parkering med det angivna id');
    }

    final parkingToDelete = parkingList[foundParkingIndex];

    parkingList.removeAt(foundParkingIndex);

    print(
        'Du har raderat följande parkering: ${parkingToDelete.id} - ${parkingToDelete.startTime}-${parkingToDelete.endTime}');
  }
}

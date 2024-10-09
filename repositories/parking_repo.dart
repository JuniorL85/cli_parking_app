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

  void _calculateDuration(startTime, endTime, pricePerHour) {
    Duration interval = endTime.difference(startTime);
    final price = interval.inMinutes / 60 * pricePerHour;
    print('\nDitt pris kommer att bli: ${price.toStringAsFixed(2)}kr\n');
  }

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

      _calculateDuration(DateTime.now(), endTime, addParkingSpace.pricePerHour);
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
    final foundParkingIndex = parkingList.indexWhere((v) => v.id == parkingId);

    if (foundParkingIndex == -1) {
      getBackToMainPage('Finns ingen parkering med det angivna id');
    }

    final foundParking = parkingList[foundParkingIndex];

    foundParking.endTime = endTime;

    _calculateDuration(
      foundParking.startTime,
      foundParking.endTime,
      foundParking.parkingSpace.pricePerHour,
    );
  }

  void deleteParkings(String parkingId) {
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

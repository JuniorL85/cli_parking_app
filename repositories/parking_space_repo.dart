import '../logic/set_main.dart';
import '../models/parking_space.dart';

class ParkingSpaceRepository {
  ParkingSpaceRepository._privateConstructor();

  static final instance = ParkingSpaceRepository._privateConstructor();

  final SetMain setMain = new SetMain();

  List<ParkingSpace> parkingSpaceList = [
    ParkingSpace(
      address: 'Testgatan 10, 546 76 Göteborg',
      pricePerHour: 12,
    )
  ];

  void addParkingSpace(ParkingSpace parkingSpace) {
    parkingSpaceList.add(parkingSpace);
  }

  void getAllParkingSpaces() {
    if (parkingSpaceList.isNotEmpty) {
      for (var (index, parkingSpace) in parkingSpaceList.indexed) {
        print(
            '${index + 1}. Id: ${parkingSpace.id}, Adress: ${parkingSpace.address} Pris per timme: ${parkingSpace.pricePerHour}');
      }
    } else {
      print('Inga parkeringsplatser att visa för tillfället....');
    }
  }

  void updateParkingSpace(ParkingSpace parkingSpace) {
    if (parkingSpaceList.isEmpty) {
      print(
          'Finns inga parkeringsplatser att uppdatera, testa att lägga till parkeringsplatser först');
      setMain.setMainPage();
      return;
    }

    final foundParkingSpaceIndex =
        parkingSpaceList.indexWhere((v) => v.id == parkingSpace.id);

    if (foundParkingSpaceIndex == -1) {
      print('Finns ingen parkeringsplats med det angivna id');
      setMain.setMainPage();
      return;
    }

    parkingSpaceList[foundParkingSpaceIndex] = parkingSpace;
  }

  void deleteParkingSpace(String parkingPlaceId) {
    if (parkingSpaceList.isEmpty) {
      print(
          'Finns inga parkeringsplatser att radera, testa att lägga till parkeringsplatser först');
      setMain.setMainPage();
      return;
    }
    final parkingSpaceToDelete =
        parkingSpaceList.firstWhere((parking) => parking.id == parkingPlaceId);
    parkingSpaceList.remove(parkingSpaceToDelete);
    print(
        'Du har raderat följande parkeringsplats: ${parkingSpaceToDelete.id} - ${parkingSpaceToDelete.address}');
  }
}

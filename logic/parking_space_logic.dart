import 'dart:io';

import '../models/parking_space.dart';
import '../repositories/parking_space_repo.dart';
import 'set_main.dart';

class ParkingSpaceLogic extends SetMain {
  final ParkingSpaceRepository parkingSpaceRepository =
      ParkingSpaceRepository.instance;

  List<String> texts = [
    'Du har valt att hantera Parkeringsplatser. Vad vill du göra?\n',
    '1. Skapa ny parkeringsplats\n',
    '2. Visa alla parkeringsplatser\n',
    '3. Uppdatera parkeringsplatser\n',
    '4. Ta bort parkeringsplatser\n',
    '5. Gå tillbaka till huvudmenyn\n\n',
    'Välj ett alternativ (1-5): ',
  ];

  void runLogic(int chosenOption) {
    switch (chosenOption) {
      case 1:
        _addParkingSpaceLogic();
        break;
      case 2:
        _showAllParkingSpacesLogic();
        break;
      case 3:
        _updateParkingSpacesLogic();
        break;
      case 4:
        _deleteParkingSpaceLogic();
        break;
      case 5:
        setMainPage();
        return;
      default:
        print('Ogiltigt val');
        return;
    }
  }

  void _addParkingSpaceLogic() {
    print('\nDu har valt att skapa en ny parkeringsplats\n');
    stdout.write('Fyll i adress: ');
    var addressInput = stdin.readLineSync();

    if (addressInput == null || addressInput.isEmpty) {
      stdout.write(
          'Du har inte fyllt i något adress, vänligen fyll i ett adress: ');
      addressInput = stdin.readLineSync();
    }

    if (addressInput == null || addressInput.isEmpty) {
      setMainPage();
      return;
    }

    stdout.write('Fyll i pris per timme för parkeringsplatsen: ');
    var pricePerHourInput = stdin.readLineSync();

    if (pricePerHourInput == null || pricePerHourInput.isEmpty) {
      stdout.write(
          'Du har inte fyllt i något pris per timme för parkeringsplatsen, vänligen fyll i ett pris per timme för parkeringsplatsen: ');
      pricePerHourInput = stdin.readLineSync();
    }

    // Dubbelkollar så inga tomma värden skickas
    if (pricePerHourInput == null || pricePerHourInput.isEmpty) {
      setMainPage();
      return;
    }

    final pricePerHourFormatted = int.parse(pricePerHourInput);

    parkingSpaceRepository.addParkingSpace(ParkingSpace(
        address: addressInput, pricePerHour: pricePerHourFormatted));
    parkingSpaceRepository.getAllParkingSpaces();

    stdout.write('Tryck på något för att komma till huvudmenyn');
    stdin.readLineSync();
    setMainPage();
  }

  void _showAllParkingSpacesLogic() {
    print('\nDu har valt att se alla parkeringsplatser:\n');
    parkingSpaceRepository.getAllParkingSpaces();
    stdout.write('Tryck på något för att komma till huvudmenyn');
    stdin.readLineSync();
    setMainPage();
  }

  void _updateParkingSpacesLogic() {
    print('\nDu har valt att uppdatera en parkeringsplats\n');
    if (parkingSpaceRepository.parkingSpaceList.isEmpty) {
      getBackToMainPage(
          'Finns inga parkeringsplatser att uppdatera, testa att lägga till en parkeringsplats först');
    }
    parkingSpaceRepository.getAllParkingSpaces();

    stdout.write('Fyll i id för parkeringsplatsen du vill uppdatera: ');
    var parkingPlaceIdInput = stdin.readLineSync();

    if (parkingPlaceIdInput == null || parkingPlaceIdInput.isEmpty) {
      stdout.write(
          'Du har inte fyllt i något id för parkeringsplatsen, vänligen fyll i ett id för parkeringsplatsen: ');
      parkingPlaceIdInput = stdin.readLineSync();
    }

    if (parkingPlaceIdInput == null || parkingPlaceIdInput.isEmpty) {
      setMainPage();
      return;
    }

    final foundParkingSpaceIdIndex = parkingSpaceRepository.parkingSpaceList
        .indexWhere((i) => i.id == parkingPlaceIdInput);

    if (foundParkingSpaceIdIndex != -1) {
      ParkingSpace oldParkingSpace =
          parkingSpaceRepository.parkingSpaceList[foundParkingSpaceIdIndex];

      print(
          'Vill du uppdatera parkeringsplatsens adress? Annars tryck Enter: ');
      var addressInput = stdin.readLineSync();
      var updatedAddress;
      if (addressInput == null || addressInput.isEmpty) {
        updatedAddress = oldParkingSpace.address;
        print('Du gjorde ingen ändring!');
      } else {
        updatedAddress = addressInput;
        print('Du har ändrat adressen till $updatedAddress!');
      }

      print(
          'Vill du uppdatera parkeringsplatsens pris per timme? Annars tryck Enter: ');
      var pphInput = stdin.readLineSync();
      int updatedPph;
      if (pphInput == null || pphInput.isEmpty) {
        updatedPph = oldParkingSpace.pricePerHour;
        print('Du gjorde ingen ändring!');
      } else {
        updatedPph = int.parse(pphInput);
        print('Du har ändrat pris per timme till $updatedPph!');
      }

      parkingSpaceRepository.updateParkingSpace(ParkingSpace(
          id: parkingPlaceIdInput,
          address: updatedAddress,
          pricePerHour: updatedPph));

      print('\nFöljande parkeringsplatser är kvar i listan\n');
      parkingSpaceRepository.getAllParkingSpaces();

      stdout.write('Tryck på något för att komma till huvudmenyn');
      stdin.readLineSync();
      setMainPage();
    } else {
      getBackToMainPage('Du angav ett felaktigt id');
    }
  }

  void _deleteParkingSpaceLogic() {
    print('\nDu har valt att ta bort en parkeringsplats\n');
    if (parkingSpaceRepository.parkingSpaceList.isEmpty) {
      getBackToMainPage(
          'Finns inga parkeringsplatser att radera, testa att lägga till en parkeringsplats först');
    }
    parkingSpaceRepository.getAllParkingSpaces();

    stdout.write('Fyll i id för parkeringsplatsen: ');
    var parkingPlaceIdInput = stdin.readLineSync();

    if (parkingPlaceIdInput == null || parkingPlaceIdInput.isEmpty) {
      stdout.write(
          'Du har inte fyllt i något id för parkeringsplatsen, vänligen fyll i ett id för parkeringsplatsen: ');
      parkingPlaceIdInput = stdin.readLineSync();
    }

    if (parkingPlaceIdInput == null || parkingPlaceIdInput.isEmpty) {
      setMainPage();
      return;
    }

    final foundParkingSpaceIdIndex = parkingSpaceRepository.parkingSpaceList
        .indexWhere((i) => i.id == parkingPlaceIdInput);

    if (foundParkingSpaceIdIndex != -1) {
      parkingSpaceRepository.deleteParkingSpace(parkingPlaceIdInput);
      print('\nFöljande parkeringsplatser är kvar i listan\n');
      parkingSpaceRepository.getAllParkingSpaces();

      stdout.write('Tryck på något för att komma till huvudmenyn');
      stdin.readLineSync();
      setMainPage();
    } else {
      getBackToMainPage('Du angav ett felaktigt id');
    }
  }
}

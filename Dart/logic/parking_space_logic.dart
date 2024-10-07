import 'dart:io';

import '../models/parking_space.dart';
import '../repositories/parking_space_repo.dart';
import 'set_main.dart';

class ParkingSpaceLogic {
  final ParkingSpaceRepository parkingSpaceRepository =
      ParkingSpaceRepository.instance;
  final SetMain setMain = new SetMain();

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
        setMain.setMainPage();
        return;
      default:
        print('Ogiltigt val');
        return;
    }
  }

  void _addParkingSpaceLogic() {
    print('\nDu har valt att skapa en ny parkeringsplats\n');
    stdout.write('Fyll i adress: ');
    var address = stdin.readLineSync();

    if (address == null || address.isEmpty) {
      stdout.write(
          'Du har inte fyllt i något adress, vänligen fyll i ett adress: ');
      address = stdin.readLineSync();
    }

    stdout.write('Fyll i pris per timme för parkeringsplatsen: ');
    var pricePerHour = stdin.readLineSync();

    if (pricePerHour == null || pricePerHour.isEmpty) {
      stdout.write(
          'Du har inte fyllt i något pris per timme för parkeringsplatsen, vänligen fyll i ett pris per timme för parkeringsplatsen: ');
      pricePerHour = stdin.readLineSync();
    }

    // Dubbelkollar så inga tomma värden skickas
    if (address == null ||
        address.isEmpty ||
        pricePerHour == null ||
        pricePerHour.isEmpty) {
      setMain.setMainPage();
      return;
    }

    final pricePerHourFormatted = int.parse(pricePerHour);

    parkingSpaceRepository.addParkingSpace(
        ParkingSpace(address: address, pricePerHour: pricePerHourFormatted));
    parkingSpaceRepository.getAllParkingSpaces();

    stdout.write('Tryck på något för att komma till huvudmenyn');
    stdin.readLineSync();
    setMain.setMainPage();
  }

  void _showAllParkingSpacesLogic() {
    print('\nDu har valt att se alla parkeringsplatser:\n');
    parkingSpaceRepository.getAllParkingSpaces();
    stdout.write('Tryck på något för att komma till huvudmenyn');
    stdin.readLineSync();
    setMain.setMainPage();
  }

  void _updateParkingSpacesLogic() {
    print('\nDu har valt att uppdatera en parkeringsplats\n');
    if (parkingSpaceRepository.parkingSpaceList.isEmpty) {
      print(
          'Finns inga parkeringsplatser att uppdatera, testa att lägga till en parkeringsplats först');
      setMain.setMainPage();
      return;
    }
    stdout.write('Fyll i id för parkeringsplatsen du vill uppdatera: ');
    var parkingPlaceId = stdin.readLineSync();

    if (parkingPlaceId == null || parkingPlaceId.isEmpty) {
      stdout.write(
          'Du har inte fyllt i något id för parkeringsplatsen, vänligen fyll i ett id för parkeringsplatsen: ');
      parkingPlaceId = stdin.readLineSync();
    }

    if (parkingPlaceId == null || parkingPlaceId.isEmpty) {
      setMain.setMainPage();
      return;
    }

    ParkingSpace oldParkingSpace = parkingSpaceRepository.parkingSpaceList
        .where((parkingSpace) => parkingSpace.id == parkingPlaceId)
        .first;

    print('Vill du uppdatera parkeringsplatsens adress? Annars tryck Enter: ');
    var address = stdin.readLineSync();
    var updatedAddress;
    if (address == null || address.isEmpty) {
      updatedAddress = oldParkingSpace.address;
      print('Du gjorde ingen ändring!');
    } else {
      updatedAddress = address;
      print('Du har ändrat adressen till $updatedAddress!');
    }

    print(
        'Vill du uppdatera parkeringsplatsens pris per timme? Annars tryck Enter: ');
    var pph = stdin.readLineSync();
    int updatedPph;
    if (pph == null || pph.isEmpty) {
      updatedPph = oldParkingSpace.pricePerHour;
      print('Du gjorde ingen ändring!');
    } else {
      updatedPph = int.parse(pph);
      print('Du har ändrat pris per timme till $updatedPph!');
    }

    parkingSpaceRepository.updateParkingSpace(ParkingSpace(
        id: parkingPlaceId, address: updatedAddress, pricePerHour: updatedPph));

    print('\nFöljande parkeringsplatser är kvar i listan\n');
    parkingSpaceRepository.getAllParkingSpaces();

    stdout.write('Tryck på något för att komma till huvudmenyn');
    stdin.readLineSync();
    setMain.setMainPage();
  }

  void _deleteParkingSpaceLogic() {
    print('\nDu har valt att ta bort en parkeringsplats\n');
    if (parkingSpaceRepository.parkingSpaceList.isEmpty) {
      print(
          'Finns inga parkeringsplatser att radera, testa att lägga till en parkeringsplats först');
      setMain.setMainPage();
      return;
    }
    stdout.write('Fyll i id för parkeringsplatsen: ');
    var parkingPlaceId = stdin.readLineSync();

    if (parkingPlaceId == null || parkingPlaceId.isEmpty) {
      stdout.write(
          'Du har inte fyllt i något id för parkeringsplatsen, vänligen fyll i ett id för parkeringsplatsen: ');
      parkingPlaceId = stdin.readLineSync();
    }

    if (parkingPlaceId == null || parkingPlaceId.isEmpty) {
      setMain.setMainPage();
      return;
    }

    parkingSpaceRepository.deleteParkingSpace(parkingPlaceId);
    print('\nFöljande parkeringsplatser är kvar i listan\n');
    parkingSpaceRepository.getAllParkingSpaces();

    stdout.write('Tryck på något för att komma till huvudmenyn');
    stdin.readLineSync();
    setMain.setMainPage();
  }
}

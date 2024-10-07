import 'dart:io';

import '../repositories/parking_repo.dart';
import 'set_main.dart';

class ParkingLogic {
  final ParkingRepository parkingRepository = ParkingRepository.instance;
  final SetMain setMain = new SetMain();

  List<String> texts = [
    'Du har valt att hantera Parkeringar. Vad vill du göra?\n',
    '1. Skapa ny parkering\n',
    '2. Visa alla parkeringar\n',
    '3. Uppdatera parkeringar\n',
    '4. Ta bort parkeringar\n',
    '5. Gå tillbaka till huvudmenyn\n\n',
    'Välj ett alternativ (1-5): ',
  ];

  void runLogic(int chosenOption) {
    switch (chosenOption) {
      case 1:
        _addParkingLogic();
        break;
      case 2:
        _showAllParkingsLogic();
        break;
      case 3:
        _updateParkingLogic();
        break;
      case 4:
        _deleteParkingLogic();
        break;
      case 5:
        setMain.setMainPage();
        return;
      default:
        print('Ogiltigt val');
        return;
    }
  }

  String _getCorrectDate(String endTime) {
    DateTime dateToday = DateTime.now();
    String date = dateToday.toString().substring(0, 10);
    return '${date} $endTime';
  }

  void _addParkingLogic() {
    print('\nDu har valt att skapa en ny parkering\n');
    stdout.write('Fyll i registreringsnummer: ');
    var regNr = stdin.readLineSync();

    if (regNr == null || regNr.isEmpty) {
      stdout.write(
          'Du har inte fyllt i något registreringsnummer, vänligen fyll i ett registreringsnummer: ');
      regNr = stdin.readLineSync();
    }

    stdout.write('Fyll i id för parkeringsplatsen: ');
    var parkingPlaceId = stdin.readLineSync();

    if (parkingPlaceId == null || parkingPlaceId.isEmpty) {
      stdout.write(
          'Du har inte fyllt i något id för parkeringsplatsen, vänligen fyll i ett id för parkeringsplatsen: ');
      parkingPlaceId = stdin.readLineSync();
    }

    stdout.write('Fyll i sluttid för din parkering: ');
    var endTime = stdin.readLineSync();

    if (endTime == null || endTime.isEmpty) {
      stdout.write(
          'Du har inte fyllt i någon sluttid för din parkering, vänligen fyll i en sluttid för din parkering: ');
      endTime = stdin.readLineSync();
    }

    if (parkingPlaceId == null ||
        parkingPlaceId.isEmpty ||
        endTime == null ||
        endTime.isEmpty ||
        regNr == null ||
        regNr.isEmpty) {
      setMain.setMainPage();
      return;
    }

    parkingRepository.addParking(
        regNr, parkingPlaceId, DateTime.tryParse(_getCorrectDate(endTime))!);
    parkingRepository.getAllParkings();

    stdout.write('Tryck på något för att komma till huvudmenyn');
    stdin.readLineSync();
    setMain.setMainPage();
  }

  void _showAllParkingsLogic() {
    print('\nDu har valt att se alla parkeringar:\n');
    parkingRepository.getAllParkings();
    stdout.write('Tryck på något för att komma till huvudmenyn');
    stdin.readLineSync();
    setMain.setMainPage();
  }

  void _updateParkingLogic() {
    print('\nDu har valt att uppdatera en parkering\n');
    if (parkingRepository.parkingList.isEmpty) {
      print(
          'Finns inga parkeringar att uppdatera, testa att lägga till en parkering först');
      setMain.setMainPage();
      return;
    }
    stdout
        .write('Fyll i id för parkeringen på parkeringen du vill uppdatera: ');
    var parkingId = stdin.readLineSync();

    if (parkingId == null || parkingId.isEmpty) {
      stdout.write(
          'Du har inte fyllt i något id för parkeringen, vänligen fyll i ett id för parkeringen: ');
      parkingId = stdin.readLineSync();
    }

    if (parkingId == null || parkingId.isEmpty) {
      setMain.setMainPage();
      return;
    }

    print('Vill du uppdatera parkeringens sluttid? Annars tryck Enter: ');
    var endTimeInput = stdin.readLineSync();
    var endTime;
    if (endTimeInput == null || endTimeInput.isEmpty) {
      endTime = '';
      print('Du gjorde ingen ändring!');
    } else {
      endTime = endTimeInput;
      parkingRepository.updateParkings(
          parkingId, DateTime.tryParse(_getCorrectDate(endTime))!);
    }

    print('\nFöljande parkeringar är kvar i listan\n');
    parkingRepository.getAllParkings();

    stdout.write('Tryck på något för att komma till huvudmenyn');
    stdin.readLineSync();
    setMain.setMainPage();
  }

  void _deleteParkingLogic() {
    print('\nDu har valt att ta bort en parkering\n');
    if (parkingRepository.parkingList.isEmpty) {
      print(
          'Finns inga parkeringar att radera, testa att lägga till en parkering först');
      setMain.setMainPage();
      return;
    }
    stdout.write('Fyll i id för parkeringen: ');
    var parkingId = stdin.readLineSync();

    if (parkingId == null || parkingId.isEmpty) {
      stdout.write(
          'Du har inte fyllt i något id för parkeringen, vänligen fyll i ett id för parkeringen: ');
      parkingId = stdin.readLineSync();
    }

    if (parkingId == null || parkingId.isEmpty) {
      setMain.setMainPage();
      return;
    }

    parkingRepository.deleteParkings(parkingId);
    print('\nFöljande parkeringar är kvar i listan\n');
    parkingRepository.getAllParkings();

    stdout.write('Tryck på något för att komma till huvudmenyn');
    stdin.readLineSync();
    setMain.setMainPage();
  }
}

import 'dart:io';

import '../repositories/parking_repo.dart';
import 'set_main.dart';

class ParkingLogic extends SetMain {
  final ParkingRepository parkingRepository = ParkingRepository.instance;

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
        setMainPage();
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
    var regNrInput = stdin.readLineSync();

    if (regNrInput == null || regNrInput.isEmpty) {
      stdout.write(
          'Du har inte fyllt i något registreringsnummer, vänligen fyll i ett registreringsnummer: ');
      regNrInput = stdin.readLineSync();
    }

    stdout.write('Fyll i id för parkeringsplatsen: ');
    var parkingPlaceIdInput = stdin.readLineSync();

    if (parkingPlaceIdInput == null || parkingPlaceIdInput.isEmpty) {
      stdout.write(
          'Du har inte fyllt i något id för parkeringsplatsen, vänligen fyll i ett id för parkeringsplatsen: ');
      parkingPlaceIdInput = stdin.readLineSync();
    }

    stdout.write('Fyll i sluttid för din parkering: ');
    var endTimeInput = stdin.readLineSync();

    if (endTimeInput == null || endTimeInput.isEmpty) {
      stdout.write(
          'Du har inte fyllt i någon sluttid för din parkering, vänligen fyll i en sluttid för din parkering: ');
      endTimeInput = stdin.readLineSync();
    }

    if (parkingPlaceIdInput == null ||
        parkingPlaceIdInput.isEmpty ||
        endTimeInput == null ||
        endTimeInput.isEmpty ||
        regNrInput == null ||
        regNrInput.isEmpty) {
      setMainPage();
      return;
    }

    parkingRepository.addParking(
      regNrInput,
      parkingPlaceIdInput,
      DateTime.tryParse(
        _getCorrectDate(endTimeInput),
      )!,
    );
    parkingRepository.getAllParkings();

    stdout.write('Tryck på något för att komma till huvudmenyn');
    stdin.readLineSync();
    setMainPage();
  }

  void _showAllParkingsLogic() {
    print('\nDu har valt att se alla parkeringar:\n');
    parkingRepository.getAllParkings();
    stdout.write('Tryck på något för att komma till huvudmenyn');
    stdin.readLineSync();
    setMainPage();
  }

  void _updateParkingLogic() {
    print('\nDu har valt att uppdatera en parkering\n');
    if (parkingRepository.parkingList.isEmpty) {
      getBackToMainPage(
          'Finns inga parkeringar att uppdatera, testa att lägga till en parkering först');
    }
    stdout
        .write('Fyll i id för parkeringen på parkeringen du vill uppdatera: ');
    var parkingIdInput = stdin.readLineSync();

    if (parkingIdInput == null || parkingIdInput.isEmpty) {
      stdout.write(
          'Du har inte fyllt i något id för parkeringen, vänligen fyll i ett id för parkeringen: ');
      parkingIdInput = stdin.readLineSync();
    }

    if (parkingIdInput == null || parkingIdInput.isEmpty) {
      setMainPage();
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
          parkingIdInput, DateTime.tryParse(_getCorrectDate(endTime))!);
    }

    print('\nFöljande parkeringar är kvar i listan\n');
    parkingRepository.getAllParkings();

    stdout.write('Tryck på något för att komma till huvudmenyn');
    stdin.readLineSync();
    setMainPage();
  }

  void _deleteParkingLogic() {
    print('\nDu har valt att ta bort en parkering\n');
    if (parkingRepository.parkingList.isEmpty) {
      getBackToMainPage(
          'Finns inga parkeringar att radera, testa att lägga till en parkering först');
    }
    stdout.write('Fyll i id för parkeringen: ');
    var parkingIdInput = stdin.readLineSync();

    if (parkingIdInput == null || parkingIdInput.isEmpty) {
      stdout.write(
          'Du har inte fyllt i något id för parkeringen, vänligen fyll i ett id för parkeringen: ');
      parkingIdInput = stdin.readLineSync();
    }

    if (parkingIdInput == null || parkingIdInput.isEmpty) {
      setMainPage();
      return;
    }

    parkingRepository.deleteParkings(parkingIdInput);
    print('\nFöljande parkeringar är kvar i listan\n');
    parkingRepository.getAllParkings();

    stdout.write('Tryck på något för att komma till huvudmenyn');
    stdin.readLineSync();
    setMainPage();
  }
}

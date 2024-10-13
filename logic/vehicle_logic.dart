import 'dart:io';

import '../models/person.dart';
import '../models/vehicle.dart';
import '../repositories/person_repo.dart';
import '../repositories/vehicle_repo.dart';
import 'set_main.dart';

class VehicleLogic extends SetMain {
  final VehicleRepository vehicleRepository = VehicleRepository.instance;
  final PersonRepository personRepository = PersonRepository.instance;

  List<String> texts = [
    'Du har valt att hantera Fordon. Vad vill du göra?\n',
    '1. Skapa nytt fordon\n',
    '2. Visa alla fordon\n',
    '3. Uppdatera fordon\n',
    '4. Ta bort fordon\n',
    '5. Gå tillbaka till huvudmenyn\n\n',
    'Välj ett alternativ (1-5): ',
  ];

  void runLogic(int chosenOption) {
    switch (chosenOption) {
      case 1:
        _addVehicleLogic();
        break;
      case 2:
        _showAllVehiclesLogic();
        break;
      case 3:
        _updateVehiclesLogic();
        break;
      case 4:
        _deleteVehicleLogic();
        break;
      case 5:
        setMainPage();
        return;
      default:
        print('Ogiltigt val');
        return;
    }
  }

  void _addVehicleLogic() {
    print('\nDu har valt att lägga till ett nytt fordon\n');
    stdout.write(
        'Fyll i personnummer på ägaren (du måste ha skapat en ny person först, har du inte gjort det så skriv 1 så kommer du tillbaka till huvudmenyn): ');
    var socialSecurityNumberInput = stdin.readLineSync();

    if (socialSecurityNumberInput == null ||
        socialSecurityNumberInput.isEmpty) {
      stdout.write(
          'Du har inte fyllt i något personnummer, vänligen fyll i ett personnummer: ');
      socialSecurityNumberInput = stdin.readLineSync();
    }

    // Dubbelkollar så inga tomma värden skickas
    if (socialSecurityNumberInput == null ||
        socialSecurityNumberInput.isEmpty) {
      setMainPage();
      return;
    }

    if (int.parse(socialSecurityNumberInput) == 1) {
      setMainPage();
      return;
    }

    try {
      // Lägg till rätt person på fordon
      final personToAdd = personRepository.personList.firstWhere(
          (person) => person.socialSecurityNumber == socialSecurityNumberInput);

      stdout.write('Fyll i registreringsnummer: ');
      var regNrInput = stdin.readLineSync();

      if (regNrInput == null || regNrInput.isEmpty) {
        stdout.write(
            'Du har inte fyllt i något registreringsnummer, vänligen fyll i ett registreringsnummer: ');
        regNrInput = stdin.readLineSync();
      }

      if (regNrInput == null || regNrInput.isEmpty) {
        setMainPage();
        return;
      }

      stdout.write(
          'Fyll i vilken typ av fordon det är med en siffra (1: Bil, 2: Motorcykel, 3: Annat): ');
      var typeInput = stdin.readLineSync();

      if (typeInput == null || typeInput.isEmpty) {
        stdout.write(
            'Du har inte fyllt i någon typ, vänligen fyll i en siffra (1: Bil, 2: Motorcykel, 3: Annat): ');
        typeInput = stdin.readLineSync();
      }

      // Dubbelkollar så inga tomma värden skickas
      if (typeInput == null || typeInput.isEmpty) {
        setMainPage();
        return;
      }

      int pickedOption = int.parse(typeInput);
      VehicleType vehicleType = VehicleType.car;
      // Lägg till rätt fordonstyp
      switch (pickedOption) {
        case 1:
          vehicleType = VehicleType.car;
          break;
        case 2:
          vehicleType = VehicleType.motorcycle;
          break;
        case 3:
          vehicleType = VehicleType.other;
          break;
      }

      vehicleRepository.addVehicle(Vehicle(
        regNr: regNrInput.toUpperCase(),
        vehicleType: vehicleType,
        owner: personToAdd,
      ));
      vehicleRepository.getAllVehicles();

      stdout.write('Tryck på något för att komma till huvudmenyn');
      stdin.readLineSync();
      setMainPage();
    } catch (error) {
      stdout.write('Felaktigt personnummer du omdirigeras till huvudmenyn\n');
      setMainPage();
      return;
    }
  }

  void _showAllVehiclesLogic() {
    print('\nDu har valt att se alla fordon:\n');
    vehicleRepository.getAllVehicles();
    stdout.write('Tryck på något för att komma till huvudmenyn');
    stdin.readLineSync();
    setMainPage();
  }

  void _updateVehiclesLogic() {
    print('\nDu har valt att uppdatera ett fordon\n');
    if (vehicleRepository.vehicleList.isEmpty) {
      getBackToMainPage(
          'Finns inga fordon att uppdatera, testa att lägga till ett fordon först');
    }

    vehicleRepository.getAllVehicles();

    stdout.write('Fyll i registreringsnummer på fordonet du vill uppdatera: ');
    var regNrInput = stdin.readLineSync()!.toUpperCase();

    if (regNrInput.isEmpty) {
      stdout.write(
          'Du har inte fyllt i något registreringsnummer, vänligen fyll i ett registreringsnummer: ');
      regNrInput = stdin.readLineSync()!.toUpperCase();
    }

    // Dubbelkollar så inga tomma värden skickas
    if (regNrInput.isEmpty) {
      setMainPage();
      return;
    }

    final foundVehicleIndex =
        vehicleRepository.vehicleList.indexWhere((p) => p.regNr == regNrInput);

    if (foundVehicleIndex != -1) {
      final vehicleOwnerInfo = vehicleRepository.vehicleList
          .where((p) => p.regNr == regNrInput)
          .map((v) => Person(
              name: v.owner.name,
              socialSecurityNumber: v.owner.socialSecurityNumber))
          .first;

      VehicleType vehicleType = vehicleRepository.vehicleList
          .firstWhere((v) => v.regNr == regNrInput)
          .vehicleType;

      print('Vänligen fyll i det nya registreringsnumret på fordonet: ');
      var regnr = stdin.readLineSync()!.toUpperCase();
      var updatedRegnr;
      if (regnr.isEmpty) {
        updatedRegnr = '';
        print('Du gjorde ingen ändring!');
      } else {
        updatedRegnr = regnr;
        vehicleRepository.updateVehicles(
            Vehicle(
              regNr: updatedRegnr,
              vehicleType: vehicleType,
              owner: vehicleOwnerInfo,
            ),
            regNrInput);
      }

      print('\nFöljande fordon är kvar i listan\n');
      vehicleRepository.getAllVehicles();

      stdout.write('Tryck på något för att komma till huvudmenyn');
      stdin.readLineSync();
      setMainPage();
    } else {
      getBackToMainPage('Du har angett ett felaktigt registreringsnummer');
    }
  }

  void _deleteVehicleLogic() {
    print('\nDu har valt att ta bort ett fordon\n');
    if (vehicleRepository.vehicleList.isEmpty) {
      getBackToMainPage(
          'Finns inga fordon att radera, testa att lägga till ett fordon först');
    }

    vehicleRepository.getAllVehicles();

    stdout.write('Fyll i registreringsnummer: ');
    var regNrInput = stdin.readLineSync();

    if (regNrInput == null || regNrInput.isEmpty) {
      stdout.write(
          'Du har inte fyllt i något registreringsnummer, vänligen fyll i ett registreringsnummer: ');
      regNrInput = stdin.readLineSync();
    }

    // Dubbelkollar så inga tomma värden skickas
    if (regNrInput == null || regNrInput.isEmpty) {
      setMainPage();
      return;
    }

    final foundVehicleIndex =
        vehicleRepository.vehicleList.indexWhere((p) => p.regNr == regNrInput);

    if (foundVehicleIndex != -1) {
      vehicleRepository.deleteVehicle(regNrInput.toUpperCase());
      print('\nFöljande fordon är kvar i listan\n');
      vehicleRepository.getAllVehicles();

      stdout.write('Tryck på något för att komma till huvudmenyn');
      stdin.readLineSync();
      setMainPage();
    } else {
      getBackToMainPage('Du har angett ett felaktigt registreringsnummer');
    }
  }
}

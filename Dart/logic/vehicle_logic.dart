import 'dart:io';

import '../models/person.dart';
import '../models/vehicle.dart';
import '../repositories/person_repo.dart';
import '../repositories/vehicle_repo.dart';
import 'set_main.dart';

class VehicleLogic {
  final VehicleRepository vehicleRepository = VehicleRepository.instance;
  final PersonRepository personRepository = PersonRepository.instance;
  final SetMain setMain = new SetMain();

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
        setMain.setMainPage();
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
    var socialSecurityNumber = stdin.readLineSync();

    if (socialSecurityNumber == null || socialSecurityNumber.isEmpty) {
      stdout.write(
          'Du har inte fyllt i något personnummer, vänligen fyll i ett personnummer: ');
      socialSecurityNumber = stdin.readLineSync();
    }

    // En extra koll för att ge användaren en chans till
    if (socialSecurityNumber == null || socialSecurityNumber.isEmpty) {
      setMain.setMainPage();
      return;
    }

    if (int.parse(socialSecurityNumber) == 1) {
      setMain.setMainPage();
      return;
    }

    try {
      // Lägg till rätt person på fordon
      final personToAdd = personRepository.personList.firstWhere(
          (person) => person.socialSecurityNumber == socialSecurityNumber);

      stdout.write('Fyll i registreringsnummer: ');
      var regNr = stdin.readLineSync();

      if (regNr == null || regNr.isEmpty) {
        stdout.write(
            'Du har inte fyllt i något registreringsnummer, vänligen fyll i ett registreringsnummer: ');
        regNr = stdin.readLineSync();
      }

      stdout.write(
          'Fyll i vilken typ av fordon det är med en siffra (1: Bil, 2: Motorcykel, 3: Annat): ');
      var type = stdin.readLineSync();

      if (type == null || type.isEmpty) {
        stdout.write(
            'Du har inte fyllt i någon typ, vänligen fyll i en siffra (1: Bil, 2: Motorcykel, 3: Annat): ');
        type = stdin.readLineSync();
      }

      if (type == null || type.isEmpty || regNr == null || regNr.isEmpty) {
        setMain.setMainPage();
        return;
      }

      int pickedOption = int.parse(type);
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
        regNr: regNr.toUpperCase(),
        vehicleType: vehicleType,
        owner: personToAdd,
      ));
      vehicleRepository.getAllVehicles();

      stdout.write('Tryck på något för att komma till huvudmenyn');
      stdin.readLineSync();
      setMain.setMainPage();
    } catch (error) {
      stdout.write('Felaktigt personnummer du omdirigeras till huvudmenyn');
      setMain.setMainPage();
      return;
    }
  }

  void _showAllVehiclesLogic() {
    print('\nDu har valt att se alla fordon:\n');
    vehicleRepository.getAllVehicles();
    stdout.write('Tryck på något för att komma till huvudmenyn');
    stdin.readLineSync();
    setMain.setMainPage();
  }

  void _updateVehiclesLogic() {
    final vehicleList = vehicleRepository.vehicleList;
    print('\nDu har valt att uppdatera ett fordon\n');
    if (vehicleList.isEmpty) {
      print(
          'Finns inga fordon att uppdatera, testa att lägga till ett fordon först');
      setMain.setMainPage();
      return;
    }
    stdout.write('Fyll i registreringsnummer på fordonet du vill uppdatera: ');
    var regNr = stdin.readLineSync()!.toUpperCase();

    if (regNr.isEmpty) {
      stdout.write(
          'Du har inte fyllt i något registreringsnummer, vänligen fyll i ett registreringsnummer: ');
      regNr = stdin.readLineSync()!.toUpperCase();
    }

    // En extra koll för att ge användaren en chans till
    if (regNr.isEmpty) {
      setMain.setMainPage();
      return;
    }

    final vehicleOwnerInfo = vehicleList
        .where((p) => p.regNr == regNr)
        .map((v) => Person(
            name: v.owner.name,
            socialSecurityNumber: v.owner.socialSecurityNumber))
        .first;

    VehicleType vehicleType =
        vehicleList.firstWhere((v) => v.regNr == regNr).vehicleType;

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
          regNr);
    }

    print('\nFöljande fordon är kvar i listan\n');
    vehicleRepository.getAllVehicles();

    stdout.write('Tryck på något för att komma till huvudmenyn');
    stdin.readLineSync();
    setMain.setMainPage();
  }

  void _deleteVehicleLogic() {
    print('\nDu har valt att ta bort ett fordon\n');
    if (vehicleRepository.vehicleList.isEmpty) {
      print(
          'Finns inga fordon att radera, testa att lägga till ett fordon först');
      setMain.setMainPage();
      return;
    }
    stdout.write('Fyll i registreringsnummer: ');
    var regNr = stdin.readLineSync();

    if (regNr == null || regNr.isEmpty) {
      stdout.write(
          'Du har inte fyllt i något registreringsnummer, vänligen fyll i ett registreringsnummer: ');
      regNr = stdin.readLineSync();
    }

    // En extra koll för att ge användaren en chans till
    if (regNr == null || regNr.isEmpty) {
      setMain.setMainPage();
      return;
    }

    vehicleRepository.deleteVehicle(regNr.toUpperCase());
    print('\nFöljande fordon är kvar i listan\n');
    vehicleRepository.getAllVehicles();

    stdout.write('Tryck på något för att komma till huvudmenyn');
    stdin.readLineSync();
    setMain.setMainPage();
  }
}

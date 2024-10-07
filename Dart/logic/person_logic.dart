import 'dart:io';

import '../models/person.dart';
import '../repositories/person_repo.dart';
import 'set_main.dart';

class PersonLogic {
  final PersonRepository personRepository = PersonRepository.instance;
  final SetMain setMain = new SetMain();

  List<String> texts = [
    'Du har valt att hantera Personer. Vad vill du göra?\n',
    '1. Skapa ny person\n',
    '2. Visa alla personer\n',
    '3. Uppdatera person\n',
    '4. Ta bort person\n',
    '5. Gå tillbaka till huvudmenyn\n\n',
    'Välj ett alternativ (1-5): ',
  ];

  void runLogic(int chosenOption) {
    switch (chosenOption) {
      case 1:
        _addPersonLogic();
        break;
      case 2:
        _showAllPersonsLogic();
        break;
      case 3:
        _updatePersonsLogic();
        break;
      case 4:
        _deletePersonLogic();
        break;
      case 5:
        setMain.setMainPage();
        return;
      default:
        print('Ogiltigt val');
        return;
    }
  }

  void _addPersonLogic() {
    print('\nDu har valt att skapa en ny person\n');
    stdout.write('Fyll i namn: ');
    var name = stdin.readLineSync();

    if (name == null || name.isEmpty) {
      stdout
          .write('Du har inte fyllt i något namn, vänligen fyll i ett namn: ');
      name = stdin.readLineSync();
    }

    stdout.write('Fyll i personnummer (12 siffror utan bindestreck): ');
    var socialSecurityNr = stdin.readLineSync();

    if (socialSecurityNr == null || socialSecurityNr.isEmpty) {
      stdout.write(
          'Du har inte fyllt i något personnummer, vänligen fyll i ett personnummer: ');
      socialSecurityNr = stdin.readLineSync();
    }

    personRepository.addPerson(
        Person(name: name!, socialSecurityNumber: socialSecurityNr!));
    personRepository.getAllPersons();

    stdout.write('Tryck på något för att komma till huvudmenyn');
    stdin.readLineSync();
    setMain.setMainPage();
  }

  void _showAllPersonsLogic() {
    print('\nDu har valt att se alla personer:\n');
    personRepository.getAllPersons();
    stdout.write('Tryck på något för att komma till huvudmenyn');
    stdin.readLineSync();
    setMain.setMainPage();
  }

  void _updatePersonsLogic() {
    print('\nDu har valt att uppdatera en person\n');
    if (personRepository.personList.isEmpty) {
      print(
          'Finns inga personer att uppdatera, testa att lägga till en person först');
      setMain.setMainPage();
      return;
    }
    stdout.write(
        'Fyll i personnummer på personen du vill uppdatera (12 siffror utan bindestreck): ');
    var socialSecurityNr = stdin.readLineSync();

    if (socialSecurityNr == null || socialSecurityNr.isEmpty) {
      stdout.write(
          'Du har inte fyllt i något personnummer, vänligen fyll i ett personnummer: ');
      socialSecurityNr = stdin.readLineSync();
    }

    print('Vill du uppdatera personens namn? Annars tryck Enter: ');
    var name = stdin.readLineSync();
    var updatedName;
    if (name == null || name.isEmpty) {
      updatedName = '';
      print('Du gjorde ingen ändring!');
    } else {
      updatedName = name;
      personRepository.updatePersons(
          Person(name: updatedName, socialSecurityNumber: socialSecurityNr!));
    }

    print('\nFöljande personer är kvar i listan\n');
    personRepository.getAllPersons();

    stdout.write('Tryck på något för att komma till huvudmenyn');
    stdin.readLineSync();
    setMain.setMainPage();
  }

  void _deletePersonLogic() {
    print('\nDu har valt att ta bort en person\n');
    if (personRepository.personList.isEmpty) {
      print(
          'Finns inga personer att radera, testa att lägga till en person först');
      setMain.setMainPage();
      return;
    }
    stdout.write('Fyll i personnummer (12 siffror utan bindestreck): ');
    var socialSecurityNr = stdin.readLineSync();

    if (socialSecurityNr == null || socialSecurityNr.isEmpty) {
      stdout.write(
          'Du har inte fyllt i något personnummer, vänligen fyll i ett personnummer: ');
      socialSecurityNr = stdin.readLineSync();
    }

    personRepository.deletePerson(socialSecurityNr!);
    print('\nFöljande personer är kvar i listan\n');
    personRepository.getAllPersons();

    stdout.write('Tryck på något för att komma till huvudmenyn');
    stdin.readLineSync();
    setMain.setMainPage();
  }
}

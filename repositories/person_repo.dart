import 'package:collection/src/iterable_extensions.dart';

import '../logic/set_main.dart';
import '../models/person.dart';
import 'vehicle_repo.dart';

class PersonRepository extends SetMain {
  PersonRepository._privateConstructor();

  static final instance = PersonRepository._privateConstructor();

  final VehicleRepository vehicleRepository = VehicleRepository.instance;

  List<Person> personList = [
    Person(
      name: 'Test Testsson',
      socialSecurityNumber: '131313131313',
    )
  ];

  void addPerson(Person person) {
    personList.add(person);
  }

  void getAllPersons() {
    if (personList.isNotEmpty) {
      for (var (index, person) in personList.indexed) {
        print(
            '${index + 1}. Id: ${person.id}\n Namn: ${person.name}\n  Personnummer: ${person.socialSecurityNumber}\n');
      }
    } else {
      print('Inga personer att visa i nuläget. Testa att lägga till personer.');
    }
  }

  void updatePersons(Person person) {
    final foundPersonIndex = personList.indexWhere(
        (pers) => pers.socialSecurityNumber == person.socialSecurityNumber);

    if (foundPersonIndex == -1) {
      getBackToMainPage('Finns ingen person med det angivna personnumret');
    }

    personList[foundPersonIndex] = person;
  }

  void deletePerson(String socialSecurityNumber) {
    final personToDelete = personList.firstWhereOrNull(
        (person) => person.socialSecurityNumber == socialSecurityNumber);

    if (personToDelete != null) {
      final personToDeleteInVehicleListIndex = vehicleRepository.vehicleList
          .indexWhere((v) =>
              v.owner.socialSecurityNumber ==
              personToDelete.socialSecurityNumber);

      personList.remove(personToDelete);

      if (personToDeleteInVehicleListIndex != -1) {
        vehicleRepository.vehicleList
            .removeAt(personToDeleteInVehicleListIndex);
      }

      print(
          'Du har raderat följande person: ${personToDelete.name} - ${personToDelete.socialSecurityNumber}');
    } else {
      getBackToMainPage('Finns ingen person med det angivna personnumret');
    }
  }
}

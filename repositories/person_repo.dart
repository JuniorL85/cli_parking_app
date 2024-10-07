import '../logic/set_main.dart';
import '../models/person.dart';
import '../models/vehicle.dart';
import 'vehicle_repo.dart';

class PersonRepository {
  PersonRepository._privateConstructor();

  static final instance = PersonRepository._privateConstructor();

  final VehicleRepository vehicleRepository = VehicleRepository.instance;

  List<Person> personList = [
    Person(
      name: 'Test Testsson',
      socialSecurityNumber: '131313131313',
    )
  ];

  final SetMain setMain = new SetMain();

  void addPerson(Person person) {
    personList.add(person);
  }

  void getAllPersons() {
    if (personList.isNotEmpty) {
      for (var (index, person) in personList.indexed) {
        print(
            '${index + 1}. Namn: ${person.name},  Personnummer: ${person.socialSecurityNumber}');
      }
    } else {
      print('Inga personer att visa i nuläget. Testa att lägga till personer.');
    }
  }

  void updatePersons(Person person) {
    if (personList.isEmpty) {
      print(
          'Finns inga personer att uppdatera, testa att lägga till en person först');
      setMain.setMainPage();
      return;
    }

    final foundPersonIndex = personList.indexWhere(
        (pers) => pers.socialSecurityNumber == person.socialSecurityNumber);

    if (foundPersonIndex == -1) {
      print('Finns ingen person med det angivna personnumret');
      setMain.setMainPage();
      return;
    }

    personList[foundPersonIndex] = person;
  }

  void deletePerson(String socialSecurityNumber) {
    if (personList.isEmpty) {
      print(
          'Finns inga personer att radera, testa att lägga till en person först');
      setMain.setMainPage();
      return;
    }
    final personToDelete = personList.firstWhere(
        (person) => person.socialSecurityNumber == socialSecurityNumber);
    final Vehicle personToDeleteInVehicleList = vehicleRepository.vehicleList
        .firstWhere((v) =>
            v.owner.socialSecurityNumber ==
            personToDelete.socialSecurityNumber);
    personList.remove(personToDelete);
    vehicleRepository.vehicleList.remove(personToDeleteInVehicleList);
    print(
        'Du har raderat följande person: ${personToDelete.name} - ${personToDelete.socialSecurityNumber}');
  }
}

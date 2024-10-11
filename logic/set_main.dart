import 'dart:io';

import 'parking_logic.dart';
import 'parking_space_logic.dart';
import 'person_logic.dart';
import 'vehicle_logic.dart';

class SetMain {
  List<String> firstPageTexts = [
    'Välkommen till parkeringsappen!\n',
    'Vad vill du hantera?\n',
    '1. Personer\n',
    '2. Fordon\n',
    '3. Parkeringsplatser\n',
    '4. Parkeringar\n',
    '5. Avsluta\n\n',
    'Välj ett alternativ (1-5): ',
  ];

  void setMainPage() {
    int pickedMenuOption;
    stdout.writeAll(firstPageTexts);
    final input = stdin.readLineSync();

    if (input == null || input.isEmpty) {
      print('Du har inte valt något giltigt alternativ');
      return;
    } else {
      int pickedOption = int.parse(input);

      switch (pickedOption) {
        case 1:
          stdout.writeAll(PersonLogic().texts);
          final personInput = stdin.readLineSync();
          if (personInput == null || personInput.isEmpty) {
            print('Du har inte valt något giltigt alternativ');
            return;
          }
          pickedMenuOption = int.parse(personInput);

          final PersonLogic personLogic = new PersonLogic();
          personLogic.runLogic(pickedMenuOption);
          break;
        case 2:
          stdout.writeAll(VehicleLogic().texts);
          final vehicleInput = stdin.readLineSync();

          if (vehicleInput == null || vehicleInput.isEmpty) {
            print('Du har inte valt något giltigt alternativ');
            return;
          }
          pickedMenuOption = int.parse(vehicleInput);

          final VehicleLogic vehicleLogic = new VehicleLogic();
          vehicleLogic.runLogic(pickedMenuOption);
          break;
        case 3:
          stdout.writeAll(ParkingSpaceLogic().texts);
          final parkingSpaceInput = stdin.readLineSync();

          if (parkingSpaceInput == null || parkingSpaceInput.isEmpty) {
            print('Du har inte valt något giltigt alternativ');
            return;
          }
          pickedMenuOption = int.parse(parkingSpaceInput);

          final ParkingSpaceLogic vehicleLogic = new ParkingSpaceLogic();
          vehicleLogic.runLogic(pickedMenuOption);
          break;
        case 4:
          stdout.writeAll(ParkingLogic().texts);
          final parkingInput = stdin.readLineSync();

          if (parkingInput == null || parkingInput.isEmpty) {
            print('Du har inte valt något giltigt alternativ');
            return;
          }
          pickedMenuOption = int.parse(parkingInput);

          final ParkingLogic vehicleLogic = new ParkingLogic();
          vehicleLogic.runLogic(pickedMenuOption);
          break;
        case 5:
          stdout.write(
              'Du valde att avsluta, tack för att du använde Parkeringsappen!');
          return;
        default:
          print('Ogiltigt val');
          return;
      }
    }
  }

  getBackToMainPage(String printText) {
    print(printText);
    setMainPage();
    return;
  }
}

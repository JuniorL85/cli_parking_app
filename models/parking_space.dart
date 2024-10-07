String idGenerator() {
  final now = DateTime.now();
  return now.microsecondsSinceEpoch.toString();
}

class ParkingSpace {
  ParkingSpace({
    required this.address,
    required this.pricePerHour,
    String? id,
  }) : id = id ?? idGenerator();

  final String id;
  final String address;
  final int pricePerHour;
}

String idGenerator() {
  final now = DateTime.now();
  return now.microsecondsSinceEpoch.toString();
}

class Person {
  Person({
    required this.name,
    required this.socialSecurityNumber,
    String? id,
  }) : id = id ?? idGenerator();

  final String id;
  String name;
  String socialSecurityNumber;
}

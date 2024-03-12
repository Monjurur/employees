class Person {
  final int id;
  final String name;
  final int age;
  final String gender;

  Person({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
    };
  }
}
class Person {
  int id;
  String firstName;
  String lastName;

  Person({this.id, this.firstName, this.lastName});

  factory Person.fromJson(Map<String, dynamic> data) => new Person(
    id: data["id"],
    firstName: data["first_name"],
    lastName: data["last_name"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName
  };
}
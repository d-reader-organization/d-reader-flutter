class User {
  final int id;
  final String firstName;
  final String lastName;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory User.fromDB(dynamic data) {
    return User(
      id: data['id'],
      firstName: data['firstName'],
      lastName: data['lastName'],
    );
  }
}

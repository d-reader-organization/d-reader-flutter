class CreatorModel {
  final int id;
  final String email;
  final String name;
  final String avatar;

  CreatorModel({
    required this.id,
    required this.email,
    required this.name,
    required this.avatar,
  });

  factory CreatorModel.fromJson(dynamic json) {
    return CreatorModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      avatar: json['avatar'],
    );
  }
}

class CreatorModel {
  final int id;
  final String email;
  final String name;
  final String slug;
  final String description;
  final String avatar;
  final String logo;

  CreatorModel({
    required this.id,
    required this.email,
    required this.name,
    required this.slug,
    required this.description,
    required this.avatar,
    required this.logo,
  });

  factory CreatorModel.fromJson(dynamic json) {
    return CreatorModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      avatar: json['avatar'],
      logo: json['logo'],
    );
  }
}

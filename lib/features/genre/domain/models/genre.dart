class GenreModel {
  String name;
  String slug;
  String icon;
  String color;

  GenreModel({
    required this.name,
    required this.slug,
    required this.icon,
    required this.color,
  });

  factory GenreModel.fromJson(json) {
    return GenreModel(
      name: json['name'],
      slug: json['slug'],
      icon: json['icon'] ?? '',
      color: json['color'],
    );
  }
}

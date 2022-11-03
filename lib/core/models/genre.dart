class GenreModel {
  String name;
  String slug;
  String imagePath;
  DateTime? deletedAt;

  GenreModel({
    required this.name,
    required this.slug,
    required this.imagePath,
    this.deletedAt,
  });

  factory GenreModel.fromJson(json) {
    return GenreModel(
        name: json['name'],
        slug: json['slug'],
        imagePath: json['image'],
        deletedAt: json['deletedAt']);
  }
}

class ComicModel {
  final String name;
  final String slug;
  final String thumbnail;
  final String pfp;

  ComicModel({
    required this.name,
    required this.slug,
    required this.thumbnail,
    required this.pfp,
  });

  factory ComicModel.fromJson(dynamic data) => ComicModel(
        name: data['name'],
        slug: data['slug'],
        thumbnail: data['thumbnail'],
        pfp: data['pfp'],
      );
}

class ComicIssueModel {
  final int id;
  final int number;
  final String title;
  final String slug;
  final String cover;

  ComicIssueModel({
    required this.id,
    required this.number,
    required this.title,
    required this.slug,
    required this.cover,
  });

  factory ComicIssueModel.fromJson(dynamic json) {
    return ComicIssueModel(
      id: json['id'],
      number: json['number'],
      title: json['title'],
      slug: json['slug'],
      cover: json['cover'],
    );
  }
}

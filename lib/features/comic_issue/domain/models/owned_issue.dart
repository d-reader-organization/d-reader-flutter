class OwnedComicIssue {
  final int id, number, ownedCopiesCount;
  final String title, slug, cover;

  OwnedComicIssue({
    required this.id,
    required this.number,
    required this.ownedCopiesCount,
    required this.title,
    required this.slug,
    required this.cover,
  });

  factory OwnedComicIssue.fromJson(dynamic json) {
    return OwnedComicIssue(
      id: json['id'],
      number: json['number'],
      ownedCopiesCount: json['ownedCopiesCount'],
      title: json['title'],
      slug: json['slug'],
      cover: json['cover'],
    );
  }
}

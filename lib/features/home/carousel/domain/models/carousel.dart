class CarouselModel {
  final int id;
  final String image, title, subtitle;
  final int? comicIssueId, creatorId;
  final String? comicSlug, externalLink;

  CarouselModel({
    required this.id,
    required this.image,
    required this.title,
    required this.subtitle,
    this.externalLink,
    this.comicIssueId,
    this.comicSlug,
    this.creatorId,
  });

  factory CarouselModel.fromJson(dynamic data) {
    return CarouselModel(
      id: data['id'],
      image: data['image'],
      title: data['title'] ?? '',
      subtitle: data['subtitle'] ?? '',
      externalLink: data['externalLink'] ?? '',
      comicIssueId: data['comicIssueId'],
      comicSlug: data['comicSlug'],
      creatorId: data['creatorId'],
    );
  }
}

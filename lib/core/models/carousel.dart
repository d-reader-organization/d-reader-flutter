class Carousel {
  final int id;
  final String image;
  final String title;
  final String subtitle;

  Carousel({
    required this.id,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  factory Carousel.fromJson(dynamic data) {
    return Carousel(
      id: data['id'],
      image: data['image'],
      title: data['title'],
      subtitle: data['subtitle'],
    );
  }
}

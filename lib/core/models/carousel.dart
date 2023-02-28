class CarouselModel {
  final int id;
  final String image;
  final String title;
  final String subtitle;

  CarouselModel({
    required this.id,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  factory CarouselModel.fromJson(dynamic data) {
    return CarouselModel(
      id: data['id'],
      image: data['image'],
      title: data['title'] ?? '',
      subtitle: data['subtitle'] ?? '',
    );
  }
}

class CarouselModel {
  final int id;
  final String image;
  final String title;
  final String subtitle;
  final int priority;
  final String location;

  CarouselModel({
    required this.id,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.priority,
    required this.location,
  });

  factory CarouselModel.fromJson(dynamic data) {
    return CarouselModel(
      id: data['id'],
      image: data['image'],
      title: data['title'] ?? '',
      subtitle: data['subtitle'] ?? '',
      priority: data['priority'],
      location: data['location'],
    );
  }
}

class PageModel {
  int id, pageNumber, height, width;
  String image;

  PageModel({
    required this.id,
    required this.pageNumber,
    required this.image,
    required this.height,
    required this.width,
  });

  factory PageModel.fromJson(dynamic json) {
    return PageModel(
      id: json['id'],
      pageNumber: json['pageNumber'],
      image: json['image'],
      height: json['height'] ?? 0,
      width: json['width'] ?? 0,
    );
  }
}

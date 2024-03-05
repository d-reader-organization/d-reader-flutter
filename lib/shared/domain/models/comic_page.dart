class PageModel {
  int id, pageNumber;
  String image;
  PageModel({
    required this.id,
    required this.pageNumber,
    required this.image,
  });

  factory PageModel.fromJson(dynamic json) {
    return PageModel(
      id: json['id'],
      pageNumber: json['pageNumber'],
      image: json['image'],
    );
  }
}

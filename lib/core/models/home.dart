class Home {
  final int id;
  Home({required this.id});

  factory Home.fromDB(dynamic data) {
    return Home(id: data['id']);
  }
}

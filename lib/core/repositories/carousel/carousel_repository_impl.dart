import 'package:d_reader_flutter/core/models/carousel.dart';
import 'package:d_reader_flutter/core/repositories/carousel/carousel_repository.dart';
import 'package:dio/dio.dart';

class CarouselRepositoryImpl implements CarouselRepository {
  final Dio client;

  CarouselRepositoryImpl({
    required this.client,
  });
  @override
  Future<List<CarouselModel>> getCarouselData() async {
    final response =
        await client.get('/carousel/slides/get').then((value) => value.data);
    if (response == null) {
      return [];
    }
    return List<CarouselModel>.from(
      response.map(
        (item) => CarouselModel.fromJson(
          item,
        ),
      ),
    );
  }
}

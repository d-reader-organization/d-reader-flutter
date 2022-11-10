import 'package:d_reader_flutter/core/models/carousel.dart';

abstract class CarouselRepository {
  Future<List<CarouselModel>> getCarouselData();
}

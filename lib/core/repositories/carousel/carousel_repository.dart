import 'package:d_reader_flutter/shared/domain/models/carousel.dart';

abstract class CarouselRepository {
  Future<List<CarouselModel>> getCarouselData();
}

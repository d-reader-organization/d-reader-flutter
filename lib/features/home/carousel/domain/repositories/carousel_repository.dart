import 'package:d_reader_flutter/features/home/carousel/domain/models/carousel.dart';

abstract class CarouselRepository {
  Future<List<CarouselModel>> getCarouselData();
}

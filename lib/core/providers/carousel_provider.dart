import 'package:d_reader_flutter/core/models/carousel.dart';
import 'package:d_reader_flutter/core/repositories/carousel/carousel_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final carouselProvider = FutureProvider<List<CarouselModel>>((ref) async {
  CarouselRepositoryImpl carouselRepository = CarouselRepositoryImpl();
  return await carouselRepository.getCarouselData();
});

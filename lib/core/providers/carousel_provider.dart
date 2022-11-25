import 'package:d_reader_flutter/core/models/carousel.dart';
import 'package:d_reader_flutter/core/repositories/carousel/carousel_repository_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final carouselProvider = FutureProvider<List<CarouselModel>>((ref) async {
  CarouselRepositoryImpl carouselRepository = CarouselRepositoryImpl();
  return await carouselRepository.getCarouselData();
});

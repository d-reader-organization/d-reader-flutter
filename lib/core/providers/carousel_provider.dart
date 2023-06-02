import 'package:d_reader_flutter/core/models/carousel.dart';
import 'package:d_reader_flutter/core/providers/dio_provider.dart';
import 'package:d_reader_flutter/core/repositories/carousel/carousel_repository_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final carouselRepositoryProvider = Provider<CarouselRepositoryImpl>((ref) {
  return CarouselRepositoryImpl(
    client: ref.watch(dioProvider),
  );
});

final carouselProvider = FutureProvider<List<CarouselModel>>((ref) async {
  return ref.read(carouselRepositoryProvider).getCarouselData();
});

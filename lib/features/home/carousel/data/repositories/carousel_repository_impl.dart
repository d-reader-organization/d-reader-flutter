import 'package:d_reader_flutter/features/home/carousel/data/datasource/carousel_remote_data_soruce.dart';
import 'package:d_reader_flutter/features/home/carousel/domain/models/carousel.dart';
import 'package:d_reader_flutter/features/home/carousel/domain/repositories/carousel_repository.dart';

class CarouselRepositoryImpl implements CarouselRepository {
  final CarouselDataSource dataSource;

  CarouselRepositoryImpl(this.dataSource);

  @override
  Future<List<CarouselModel>> getCarouselData() {
    return dataSource.getCarouselData();
  }
}

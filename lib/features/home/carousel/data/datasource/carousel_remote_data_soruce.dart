import 'package:d_reader_flutter/features/home/carousel/domain/models/carousel.dart';
import 'package:d_reader_flutter/shared/data/remote/network_service.dart';

abstract class CarouselDataSource {
  Future<List<CarouselModel>> getCarouselData();
}

class CarouselRemoteDataSource implements CarouselDataSource {
  final NetworkService networkService;

  CarouselRemoteDataSource(this.networkService);

  @override
  Future<List<CarouselModel>> getCarouselData() async {
    final response = await networkService.get('/carousel/slides/get');

    return response.fold(
      (exception) => [],
      (result) {
        return List<CarouselModel>.from(
          result.data.map(
            (item) => CarouselModel.fromJson(
              item,
            ),
          ),
        );
      },
    );
  }
}

  // Future<List<CarouselModel>> getCarouselData() async {
  //   final response =
  //       await client.get('/carousel/slides/get').then((value) => value.data);

  //   return response != null

  //       : [];
  // }


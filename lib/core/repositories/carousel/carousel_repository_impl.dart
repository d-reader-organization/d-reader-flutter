import 'dart:convert' show jsonDecode;

import 'package:d_reader_flutter/core/models/carousel.dart';
import 'package:d_reader_flutter/core/repositories/carousel/carousel_repository.dart';
import 'package:d_reader_flutter/core/services/api_service.dart';

class CarouselRepositoryImpl implements CarouselRepository {
  @override
  Future<List<CarouselModel>> getCarouselData() async {
    String? responseBody =
        await ApiService.instance.apiCallGet('/carousel/slides/get');
    if (responseBody == null) {
      return [];
    }
    Iterable decodedData = jsonDecode(responseBody);
    return List<CarouselModel>.from(
      decodedData.map(
        (item) => CarouselModel.fromJson(
          item,
        ),
      ),
    );
  }
}

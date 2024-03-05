import 'package:d_reader_flutter/features/comic/domain/models/comic_model.dart';
import 'package:d_reader_flutter/shared/data/remote/network_service.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

abstract class ComicDataSource {
  Future<Either<AppException, List<ComicModel>>> getComics(
      {String? queryString});
  Future<Either<AppException, ComicModel?>> getComic(String slug);
  Future<Either<AppException, List<ComicModel>>> getOwnedComics({
    required int userId,
    required String query,
  });
  Future<void> updateComicFavourite(String slug);
  Future<void> rateComic({
    required String slug,
    required int rating,
  });
  Future<void> bookmarkComic(String slug);
}

class ComicRemoteDataSource implements ComicDataSource {
  final NetworkService networkService;

  ComicRemoteDataSource(this.networkService);

  @override
  Future<void> bookmarkComic(String slug) {
    // TODO: implement bookmarkComic
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, ComicModel?>> getComic(String slug) {
    // TODO: implement getComic
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, List<ComicModel>>> getComics(
      {String? queryString}) {
    // TODO: implement getComics
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, List<ComicModel>>> getOwnedComics(
      {required int userId, required String query}) {
    // TODO: implement getOwnedComics
    throw UnimplementedError();
  }

  @override
  Future<void> rateComic({required String slug, required int rating}) {
    // TODO: implement rateComic
    throw UnimplementedError();
  }

  @override
  Future<void> updateComicFavourite(String slug) {
    // TODO: implement updateComicFavourite
    throw UnimplementedError();
  }
}

//   @override
//   Future<List<ComicModel>> getComics({String? queryString}) async {
//     final response = await client
//         .get<List<dynamic>>('/comic/get?$queryString')
//         .then((value) => value.data);

//     return response != null
//         ? List<ComicModel>.from(
//             response.map(
//               (item) => ComicModel.fromJson(
//                 item,
//               ),
//             ),
//           )
//         : [];
//   }

//   @override
//   Future<ComicModel?> getComic(String slug) async {
//     final response = await client
//         .get<dynamic>('/comic/get/$slug')
//         .then((value) => value.data);

//     return response != null ? ComicModel.fromJson(response) : null;
//   }

//   @override
//   Future<void> updateComicFavourite(String slug) async {
//     await client.patch('/comic/favouritise/$slug');
//   }

//   @override
//   Future rateComic({required String slug, required int rating}) async {
//     await client
//         .patch(
//           '/comic/rate/$slug',
//           data: {
//             'rating': rating,
//           },
//         )
//         .then((value) => value.data)
//         .onError((error, stackTrace) {
//           return error.toString();
//         });
//   }

//   @override
//   Future<List<ComicModel>> getOwnedComics(
//       {required int userId, required String query}) async {
//     final response = await client
//         .get('/comic/get/by-owner/$userId?$query')
//         .then((value) => value.data);

//     return response != null
//         ? List<ComicModel>.from(
//             response.map(
//               (item) => ComicModel.fromJson(
//                 item,
//               ),
//             ),
//           )
//         : [];
//   }

//   @override
//   Future<void> bookmarkComic(String slug) {
//     return client.patch('/comic/bookmark/$slug').then((value) => value.data);
//   }
// }
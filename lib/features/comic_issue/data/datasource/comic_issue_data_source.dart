import 'package:d_reader_flutter/features/comic_issue/domain/models/comic_issue.dart';
import 'package:d_reader_flutter/features/comic_issue/domain/models/owned_issue.dart';
import 'package:d_reader_flutter/shared/data/remote/network_service.dart';
import 'package:d_reader_flutter/shared/domain/models/comic_page.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

abstract class ComicIssueDataSource {
  Future<Either<AppException, List<ComicIssueModel>>> getComicIssues(
      {String? queryString});
  Future<Either<AppException, ComicIssueModel>> getComicIssue(int id);
  Future<List<PageModel>> getComicIssuePages(int id);
  Future<void> favouritiseIssue(int id);
  Future<void> rateIssue({
    required int id,
    required int rating,
  });
  Future<Either<AppException, List<OwnedComicIssue>>> getOwnedIssues({
    required int id,
    required String query,
  });
}

class ComicIssueRemoteDataSource implements ComicIssueDataSource {
  final NetworkService networkService;

  ComicIssueRemoteDataSource(this.networkService);

  @override
  Future<void> favouritiseIssue(int id) {
    return networkService.patch('/comic-issue/favouritise/$id');
  }

  @override
  Future<Either<AppException, ComicIssueModel>> getComicIssue(int id) async {
    try {
      final response = await networkService.get('/comic-issue/get/$id');
      return response.fold(
        (exception) => Left(exception),
        (result) => Right(
          ComicIssueModel.fromJson(
            result.data,
          ),
        ),
      );
    } catch (exception) {
      return Left(
        AppException(
          message: 'Unknown exception occurred',
          statusCode: 500,
          identifier:
              '${exception.toString()}ComicIssueRemoteDataSource.getComicIssue',
        ),
      );
    }
  }

  @override
  Future<List<PageModel>> getComicIssuePages(int id) async {
    try {
      final response = await networkService.get('/comic-issue/get/$id/pages');
      return response.fold(
        (exception) => [],
        (result) {
          return List<PageModel>.from(
            result.data.map(
              (item) => PageModel.fromJson(
                item,
              ),
            ),
          );
        },
      );
    } catch (exception) {
      rethrow;
    }
  }

  @override
  Future<Either<AppException, List<ComicIssueModel>>> getComicIssues({
    String? queryString,
  }) async {
    try {
      final response =
          await networkService.get('/comic-issue/get?$queryString');
      return response.fold(
        (exception) => Left(exception),
        (result) {
          return Right(
            List<ComicIssueModel>.from(
              result.data.map(
                (item) => ComicIssueModel.fromJson(
                  item,
                ),
              ),
            ),
          );
        },
      );
    } catch (exception) {
      return Left(
        AppException(
          message: 'Unknown exception occurred',
          statusCode: 500,
          identifier:
              '${exception.toString()}ComicIssueRemoteDataSource.getComicIssues',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, List<OwnedComicIssue>>> getOwnedIssues({
    required int id,
    required String query,
  }) async {
    try {
      final response =
          await networkService.get('/comic-issue/get/by-owner/$id?$query');
      return response.fold(
        (p0) => Left(p0),
        (result) {
          return Right(
            List<OwnedComicIssue>.from(
              result.data.map(
                (item) => OwnedComicIssue.fromJson(
                  item,
                ),
              ),
            ),
          );
        },
      );
    } catch (exception) {
      return Left(
        AppException(
          message: 'Unknown exception occurred',
          statusCode: 500,
          identifier:
              '${exception.toString()}ComicIssueRemoteDataSource.getOwnedIssues',
        ),
      );
    }
  }

  @override
  Future<void> rateIssue({
    required int id,
    required int rating,
  }) {
    return networkService.patch(
      '/comic-issue/rate/$id',
      data: {
        'rating': rating,
      },
    );
  }
}

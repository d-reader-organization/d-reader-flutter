import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/models/page_model.dart';
import 'package:d_reader_flutter/core/repositories/comic_issues/comic_issue_repository.dart';
import 'package:dio/dio.dart';

class ComicIssueRepositoryImpl implements ComicIssueRepository {
  final Dio client;

  ComicIssueRepositoryImpl({
    required this.client,
  });

  @override
  Future<List<ComicIssueModel>> getComicIssues({String? queryString}) async {
    final response = await client
        .get<List<dynamic>?>('/comic-issue/get?$queryString')
        .then((value) => value.data);

    if (response == null) {
      return [];
    }

    return List<ComicIssueModel>.from(
      response.map(
        (item) => ComicIssueModel.fromJson(
          item,
        ),
      ),
    );
  }

  @override
  Future<ComicIssueModel?> getComicIssue(int id) async {
    final response =
        await client.get('/comic-issue/get/$id').then((value) => value.data);

    return response == null ? null : ComicIssueModel.fromJson(response);
  }

  @override
  Future<List<PageModel>> getComicIssuePages(int id) async {
    final response = await client
        .get('/comic-issue/get/$id/pages')
        .then((value) => value.data);
    if (response == null) {
      return [];
    }

    return List<PageModel>.from(
      response.map(
        (item) => PageModel.fromJson(
          item,
        ),
      ),
    );
  }

  @override
  Future<dynamic> rateIssue({
    required int id,
    required int rating,
  }) async {
    final result = await client
        .patch(
          '/comic-issue/rate/$id',
          data: {
            'rating': rating,
          },
        )
        .then((value) => value.data)
        .onError((error, stackTrace) {
          return error.toString();
        });

    return result != null ? ComicIssueModel.fromJson(result) : result;
  }
}

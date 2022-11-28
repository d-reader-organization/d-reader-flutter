import 'dart:convert' show jsonDecode;

import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/repositories/comic_issues/comic_issue_repository.dart';
import 'package:d_reader_flutter/core/services/api_service.dart';

class ComicIssueRepositoryImpl implements ComicIssueRepository {
  @override
  Future<List<ComicIssueModel>> getComicIssues([String? queryString]) async {
    final String? responseBody =
        await ApiService.apiCallGet('/comic-issue/get?$queryString');
    if (responseBody == null) {
      return [];
    }
    Iterable decodedData = jsonDecode(responseBody);
    return List<ComicIssueModel>.from(
      decodedData.map(
        (item) => ComicIssueModel.fromJson(
          item,
        ),
      ),
    );
  }

  @override
  Future<ComicIssueModel?> getComic(int id) async {
    final String? responseBody =
        await ApiService.apiCallGet('/comic-issue/get/$id');
    return responseBody == null
        ? null
        : ComicIssueModel.fromJson(jsonDecode(responseBody));
  }
}

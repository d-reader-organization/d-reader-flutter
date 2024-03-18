import 'package:d_reader_flutter/features/comic_issue/data/datasource/comic_issue_data_source.dart';
import 'package:d_reader_flutter/features/comic_issue/data/repositories/comic_issue_repository_impl.dart';
import 'package:d_reader_flutter/shared/data/remote/network_service.dart';
import 'package:d_reader_flutter/shared/domain/providers/dio_network_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final comicIssueDataSourceProvider =
    Provider.family<ComicIssueDataSource, NetworkService>(
  (ref, networkService) {
    return ComicIssueRemoteDataSource(networkService);
  },
);

final comicIssueRepositoryProvider = Provider((ref) {
  final networkService = ref.watch(networkServiceProvider);
  final dataSource = ref.watch(comicIssueDataSourceProvider(networkService));

  return ComicIssueRepositoryImpl(dataSource);
});

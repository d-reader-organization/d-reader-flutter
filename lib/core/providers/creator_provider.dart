import 'package:d_reader_flutter/core/models/creator.dart';
import 'package:d_reader_flutter/core/repositories/creator/creator_repository_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final creatorsProvider = FutureProvider<List<CreatorModel>>((ref) async {
  CreatorRepositoryImpl creatorRepository = CreatorRepositoryImpl();
  return await creatorRepository.getCreators();
});

final creatorProvider =
    FutureProvider.family<CreatorModel, String>((ref, slug) async {
  CreatorRepositoryImpl creatorRepository = CreatorRepositoryImpl();
  return await creatorRepository.getCreator(slug);
});

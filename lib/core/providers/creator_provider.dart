import 'package:d_reader_flutter/core/models/creator.dart';
import 'package:d_reader_flutter/core/repositories/creator/creator_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final creatorProvider = FutureProvider<List<CreatorModel>>((ref) async {
  CreatorRepositoryImpl creatorRepository = CreatorRepositoryImpl();
  return await creatorRepository.getCreators();
});

import 'package:d_reader_flutter/features/comic/domain/models/comic_model.dart';
import 'package:d_reader_flutter/features/comic_issue/domain/models/comic_issue.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final selectedOwnedComicProvider = StateProvider.autoDispose<ComicModel?>(
  (ref) {
    return null;
  },
);

final selectedIssueInfoProvider = StateProvider.autoDispose<ComicIssueModel?>(
  (ref) {
    return null;
  },
);

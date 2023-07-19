import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/core/models/comic_issue.dart';
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

import 'package:d_reader_flutter/features/comic/presentation/providers/comic_providers.dart';
import 'package:d_reader_flutter/shared/domain/models/enums.dart';
import 'package:d_reader_flutter/features/discover/root/presentation/widgets/common/discover_scroll_view.dart';
import 'package:flutter/material.dart';

class DiscoverComicsTab extends StatelessWidget {
  const DiscoverComicsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DiscoverScrollView(
      listenableProvider: paginatedComicsProvider,
      scrollListType: ScrollListType.comicList,
    );
  }
}

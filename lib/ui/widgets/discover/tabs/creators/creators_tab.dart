import 'package:d_reader_flutter/features/creator/presentations/providers/creator_provider.dart';
import 'package:d_reader_flutter/ui/shared/enums.dart';
import 'package:d_reader_flutter/ui/widgets/discover/common/discover_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DiscoverCreatorsTab extends ConsumerWidget {
  const DiscoverCreatorsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DiscoverScrollView(
      listenableProvider: paginatedCreatorsProvider,
      scrollListType: ScrollListType.creatorList,
    );
  }
}

import 'package:d_reader_flutter/features/comic/domain/models/comic_model.dart';
import 'package:d_reader_flutter/shared/domain/models/pagination/pagination_state.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/skeleton_card.dart';
import 'package:d_reader_flutter/ui/widgets/creators/tabs/collectibles/list_builder.dart';
import 'package:flutter/material.dart';

class CreatorCollectiblesWrapper extends StatelessWidget {
  final PaginationState<ComicModel> provider;
  const CreatorCollectiblesWrapper({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return provider.when(
      data: (issues) {
        return const CreatorCollectiblesListBuilder();
      },
      loading: () => ListView.builder(
        itemCount: 3,
        shrinkWrap: true,
        physics: const PageScrollPhysics(),
        itemBuilder: (context, index) => const Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: SkeletonCard(),
        ),
      ),
      error: (err, stack) {
        return Text(
          '$err',
          style: const TextStyle(color: ColorPalette.dReaderRed),
        );
      },
      onGoingLoading: (items) {
        return const CreatorCollectiblesListBuilder();
      },
      onGoingError: (items, err, stk) {
        return const CreatorCollectiblesListBuilder();
      },
    );
  }
}

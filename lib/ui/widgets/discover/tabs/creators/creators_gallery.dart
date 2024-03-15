import 'package:d_reader_flutter/features/creator/domain/models/creator.dart';
import 'package:d_reader_flutter/shared/domain/models/pagination/pagination_state.dart';
import 'package:d_reader_flutter/shared/utils/utils.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/skeleton_card.dart';
import 'package:d_reader_flutter/ui/widgets/discover/tabs/creators/creators_gallery_builder.dart';
import 'package:flutter/material.dart';

class CreatorsGallery extends StatelessWidget {
  final PaginationState<CreatorModel> provider;
  const CreatorsGallery({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return provider.when(
      data: (creators) {
        return CreatorsGalleryBuilder(creators: creators);
      },
      error: (err, stack) => Text(
        'Error: $err',
        style: const TextStyle(color: Colors.red),
      ),
      loading: () => const CreatorsGallerySkeleton(),
      onGoingError: (List<CreatorModel> items, Object? e, StackTrace? stk) {
        return CreatorsGalleryBuilder(
          creators: items,
        );
      },
      onGoingLoading: (List<CreatorModel> items) {
        return CreatorsGalleryBuilder(
          creators: items,
        );
      },
    );
  }
}

class CreatorsGallerySkeleton extends StatelessWidget {
  const CreatorsGallerySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 166,
      child: ListView.builder(
        itemCount: 2,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => SkeletonCard(
          height: 166,
          margin: const EdgeInsets.only(
            right: 16,
          ),
          width: getCardWidth(MediaQuery.sizeOf(context).width),
        ),
      ),
    );
  }
}

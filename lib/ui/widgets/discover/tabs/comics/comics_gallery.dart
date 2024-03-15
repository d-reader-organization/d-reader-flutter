import 'package:d_reader_flutter/features/comic/domain/models/comic_model.dart';
import 'package:d_reader_flutter/shared/domain/models/pagination/pagination_state.dart';
import 'package:d_reader_flutter/shared/utils/utils.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/skeleton_card.dart';
import 'package:d_reader_flutter/ui/widgets/discover/tabs/comics/comic_gallery_builder.dart';
import 'package:flutter/material.dart';

class ComicGallery extends StatelessWidget {
  final PaginationState<ComicModel> provider;
  const ComicGallery({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return provider.when(
      data: (comics) {
        return ComicGalleryBuilder(comics: comics);
      },
      error: (err, stack) => Text(
        'Error: $err',
        style: const TextStyle(color: Colors.red),
      ),
      loading: () => const ComicGallerySkeleton(),
      onGoingError: (List<ComicModel> items, Object? e, StackTrace? stk) {
        return ComicGalleryBuilder(
          comics: items,
        );
      },
      onGoingLoading: (List<ComicModel> items) {
        return ComicGalleryBuilder(
          comics: items,
        );
      },
    );
  }
}

class ComicGallerySkeleton extends StatelessWidget {
  const ComicGallerySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 226,
      child: ListView.builder(
        itemCount: 2,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => SkeletonCard(
          margin: const EdgeInsets.only(right: 16),
          width: getCardWidth(MediaQuery.sizeOf(context).width),
          height: 276,
        ),
      ),
    );
  }
}

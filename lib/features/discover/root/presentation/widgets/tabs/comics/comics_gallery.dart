import 'package:d_reader_flutter/features/comic/domain/models/comic_model.dart';
import 'package:d_reader_flutter/shared/domain/models/pagination/pagination_state.dart';
import 'package:d_reader_flutter/shared/widgets/cards/skeleton_card.dart';
import 'package:d_reader_flutter/features/discover/root/presentation/widgets/tabs/comics/comic_gallery_builder.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/carrot_error_widget.dart';
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
      error: (err, stack) {
        return const CarrotErrorWidget(
          mainErrorText: 'We ran into some issues',
          adviceText: 'We are working on a fix. Thanks for your patience!',
        );
      },
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
    bool isTablet = MediaQuery.sizeOf(context).width > 600;
    return GridView.builder(
      itemCount: 4,
      primary: false,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 3 : 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 156 / 235,
      ),
      itemBuilder: (context, index) {
        return const SkeletonCard();
      },
    );
  }
}

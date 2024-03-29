import 'package:d_reader_flutter/features/comic/domain/models/comic_model.dart';
import 'package:d_reader_flutter/shared/domain/models/pagination/pagination_state.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/widgets/cards/skeleton_card.dart';
import 'package:d_reader_flutter/features/creator/presentation/widgets/tabs/comics/list_builder.dart';
import 'package:flutter/material.dart';

class CreatorComicsWrapper extends StatelessWidget {
  final PaginationState<ComicModel> provider;
  const CreatorComicsWrapper({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return provider.when(
      data: (comics) {
        if (comics.isEmpty) {
          return const Center(
            child: Text(
              'No comics published yet',
            ),
          );
        }
        return ComicsListBuilder(
          comics: comics,
        );
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
        return ComicsListBuilder(comics: items);
      },
      onGoingError: (items, err, stk) {
        return ComicsListBuilder(comics: items);
      },
    );
  }
}

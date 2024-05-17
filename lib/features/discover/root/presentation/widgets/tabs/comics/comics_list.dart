import 'package:d_reader_flutter/features/comic/domain/models/comic_model.dart';
import 'package:d_reader_flutter/shared/domain/models/pagination/pagination_state.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/widgets/cards/skeleton_card.dart';
import 'package:d_reader_flutter/features/discover/root/presentation/widgets/tabs/comics/comics_list_builder.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/carrot_error_widget.dart';
import 'package:flutter/material.dart';

class ComicList extends StatelessWidget {
  final PaginationState<ComicModel> provider;
  const ComicList({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return provider.when(
      data: (comics) {
        return ComicListBuilder(comics: comics);
      },
      error: (e, stk) {
        return const CarrotErrorWidget(
          mainErrorText: 'We ran into some issues',
          adviceText: 'We are working on a fix. Thanks for your patience!',
        );
      },
      loading: () => ListView.separated(
        itemCount: 3,
        shrinkWrap: true,
        physics: const PageScrollPhysics(),
        itemBuilder: (context, index) {
          return const ComicListItemSkeleton();
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            color: ColorPalette.greyscale400,
            thickness: 1,
          );
        },
      ),
      onGoingError: (List<ComicModel> items, Object? e, StackTrace? stk) {
        return ComicListBuilder(
          comics: items,
        );
      },
      onGoingLoading: (List<ComicModel> items) {
        return ComicListBuilder(
          comics: items,
        );
      },
    );
  }
}

class ComicListItemSkeleton extends StatelessWidget {
  const ComicListItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 135,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const SkeletonCard(),
                )
              ],
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          const Expanded(
            flex: 5,
            child: SkeletonCard(
              height: 135,
            ),
          ),
        ],
      ),
    );
  }
}

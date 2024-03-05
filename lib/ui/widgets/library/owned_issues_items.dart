import 'package:d_reader_flutter/core/providers/library/selected_owned_comic_provider.dart';
import 'package:d_reader_flutter/features/comic/domain/models/comic_model.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/presentation/providers/owned_issues_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/skeleton_card.dart';
import 'package:d_reader_flutter/ui/widgets/library/cards/owned_issue_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OwnedIssuesItems extends ConsumerWidget {
  final ComicModel comic;
  const OwnedIssuesItems({
    super.key,
    required this.comic,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(
      ownedIssuesAsyncProvider(
          '${ref.watch(environmentProvider).user?.id ?? ''}?comicSlug=${comic.slug}'),
    );

    return provider.when(
      data: (data) {
        if (data.isEmpty) {
          return const Text('Something went wrong.');
        }
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            ref.invalidate(selectedOwnedComicProvider);
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    ref.invalidate(selectedOwnedComicProvider);
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        comic.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                const Divider(
                  thickness: 1,
                  color: ColorPalette.greyscale500,
                ),
                const SizedBox(
                  height: 4,
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const PageScrollPhysics(),
                  itemBuilder: (context, index) {
                    return OwnedIssueCard(issue: data[index]);
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(
                      thickness: 1,
                      color: ColorPalette.greyscale500,
                    );
                  },
                  itemCount: data.length,
                ),
              ],
            ),
          ),
        );
      },
      error: (Object error, StackTrace stackTrace) {
        return const Center(
          child: Text('Nothing to see in here.'),
        );
      },
      loading: () {
        return const LoadingOwnedIssuesView();
      },
    );
  }
}

class LoadingOwnedIssuesView extends StatelessWidget {
  const LoadingOwnedIssuesView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          const Row(
            children: [
              SkeletonCard(
                height: 16,
                width: 16,
                withBorderRadius: false,
              ),
              SizedBox(
                width: 8,
              ),
              SkeletonCard(
                height: 16,
                width: 120,
                withBorderRadius: false,
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          const Divider(
            thickness: 1,
            color: ColorPalette.greyscale500,
          ),
          const SizedBox(
            height: 4,
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const PageScrollPhysics(),
            itemBuilder: (context, index) {
              return const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: SkeletonCard(
                      height: 126,
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonCard(
                          withBorderRadius: false,
                          width: 70,
                          height: 18,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        SkeletonCard(
                          withBorderRadius: false,
                          width: 120,
                          height: 18,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        SkeletonCard(
                          withBorderRadius: false,
                          width: 100,
                          height: 18,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        SkeletonCard(
                          width: 120,
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(
                thickness: 1,
                color: ColorPalette.greyscale500,
              );
            },
            itemCount: 3,
          ),
        ],
      ),
    );
  }
}

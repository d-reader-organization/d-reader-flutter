import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/providers/library/selected_owned_comic_provider.dart';
import 'package:d_reader_flutter/core/providers/nft_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/skeleton_card.dart';
import 'package:d_reader_flutter/ui/widgets/library/cards/owned_nft_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class OwnedNftsItems extends ConsumerWidget {
  final ComicIssueModel issue;
  const OwnedNftsItems({
    super.key,
    required this.issue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(
      nftsProvider(
        'comicIssueId=${issue.id}&userId=${ref.watch(environmentProvider).user?.id}',
      ),
    );

    return provider.when(
      data: (data) {
        if (data.isEmpty) {
          return const Text('No data.');
        }
        return WillPopScope(
          onWillPop: () async {
            ref.invalidate(selectedIssueInfoProvider);
            return false;
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    ref.invalidate(selectedIssueInfoProvider);
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
                        '${issue.comic?.title} / ',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: ColorPalette.greyscale200,
                        ),
                      ),
                      Text(
                        'EP ${issue.number}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                const Divider(
                  thickness: 1,
                  color: ColorPalette.boxBackground200,
                ),
                const SizedBox(
                  height: 4,
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const PageScrollPhysics(),
                  itemBuilder: (context, index) {
                    return OwnedNftCard(nft: data[index]);
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(
                      thickness: 1,
                      color: ColorPalette.boxBackground200,
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
        Sentry.captureException(error, stackTrace: stackTrace);
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
            color: ColorPalette.boxBackground200,
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
                color: ColorPalette.boxBackground200,
              );
            },
            itemCount: 3,
          ),
        ],
      ),
    );
  }
}

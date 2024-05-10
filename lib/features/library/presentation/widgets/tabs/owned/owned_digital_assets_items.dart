import 'package:d_reader_flutter/features/library/presentation/providers/owned/owned_providers.dart';
import 'package:d_reader_flutter/features/digital_asset/presentation/providers/digital_asset_providers.dart';
import 'package:d_reader_flutter/features/comic_issue/domain/models/comic_issue.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/widgets/cards/skeleton_card.dart';
import 'package:d_reader_flutter/features/library/presentation/widgets/cards/owned_digital_asset_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OwnedDigitalAssetsItems extends ConsumerWidget {
  final ComicIssueModel issue;
  const OwnedDigitalAssetsItems({
    super.key,
    required this.issue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(
      digitalAssetsProvider(
        'comicIssueId=${issue.id}&userId=${ref.watch(environmentProvider).user?.id}',
      ),
    );

    return provider.when(
      data: (data) {
        if (data.isEmpty) {
          return const Text('No data.');
        }
        return ListView(
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
              color: ColorPalette.greyscale500,
            ),
            const SizedBox(
              height: 4,
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const PageScrollPhysics(),
              itemBuilder: (context, index) {
                return OwnedDigitalAssetCard(digitalAsset: data[index]);
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

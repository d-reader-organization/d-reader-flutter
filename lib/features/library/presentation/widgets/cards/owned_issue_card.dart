import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/features/comic_issue/domain/models/owned_issue.dart';
import 'package:d_reader_flutter/features/library/presentation/providers/owned/owned_controller.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/screen_navigation.dart';
import 'package:d_reader_flutter/shared/widgets/image_widgets/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/features/library/presentation/widgets/buttons/info_button.dart';
import 'package:d_reader_flutter/features/library/presentation/widgets/tabs/owned/owned_copies.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OwnedIssueCard extends ConsumerWidget {
  final OwnedComicIssue issue;

  const OwnedIssueCard({
    super.key,
    required this.issue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        nextScreenPush(
          context: context,
          path: '${RoutePath.eReader}/${issue.id}',
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 130,
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 4,
        ),
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: comicIssueAspectRatio,
              child: CachedImageBgPlaceholder(
                imageUrl: issue.cover,
                bgImageFit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Episode ${issue.number}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: ColorPalette.greyscale100,
                        ),
                      ),
                      Text(
                        issue.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  OwnedCopies(copiesCount: issue.ownedCopiesCount),
                  const SizedBox(),
                  InfoButton(
                    isLoading: ref.watch(globalNotifierProvider).isLoading,
                    onTap: () {
                      ref
                          .read(ownedControllerProvider.notifier)
                          .handleIssueInfoTap(
                            comicIssueId: issue.id,
                            goToDigitalAssetDetails: (digitalAssetAddress) {
                              return nextScreenPush(
                                context: context,
                                path:
                                    '${RoutePath.digitalAssetDetails}/$digitalAssetAddress',
                              );
                            },
                          );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

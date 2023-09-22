import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/core/providers/comic_provider.dart';
import 'package:d_reader_flutter/core/providers/selected_rating_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/confirmation_dialog.dart';
import 'package:d_reader_flutter/ui/widgets/common/rating_stars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RatingIcon extends ConsumerWidget {
  final double initialRating;
  final int? issueId;
  final String? comicSlug;
  final bool isRatedByMe, isContainerWidget;
  const RatingIcon({
    Key? key,
    required this.initialRating,
    this.isRatedByMe = false,
    this.issueId,
    this.comicSlug,
    this.isContainerWidget = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: (issueId != null || comicSlug != null)
          ? () async {
              await showDialog(
                context: context,
                builder: (context) {
                  return ConfirmationDialog(
                    title:
                        issueId != null ? 'Rate the episode' : 'Rate the comic',
                    subtitle: 'Tap a star to give ratings!',
                    onTap: () {
                      final int rating = ref.read(selectedRatingStarIndex) + 1;
                      return issueId != null && rating > 0
                          ? ref.read(
                              rateComicIssueProvider(
                                {
                                  'id': issueId,
                                  'rating': rating,
                                },
                              ).future,
                            )
                          : ref.read(
                              rateComicProvider(
                                {
                                  'slug': comicSlug,
                                  'rating': rating,
                                },
                              ).future,
                            );
                    },
                    additionalChild: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
                      child: RatingStars(),
                    ),
                  );
                },
              );
            }
          : null,
      child: isContainerWidget
          ? Container(
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(minWidth: 64),
              decoration: BoxDecoration(
                color: isRatedByMe
                    ? ColorPalette.dReaderYellow100.withOpacity(.4)
                    : ColorPalette.appBackgroundColor,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isRatedByMe
                      ? Colors.transparent
                      : ColorPalette.boxBackground400,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isRatedByMe
                      ? SvgPicture.asset(
                          'assets/icons/star_bold.svg',
                          width: 16,
                          height: 16,
                        )
                      : SvgPicture.asset(
                          'assets/icons/star_light.svg',
                          width: 16,
                          height: 16,
                        ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    initialRating > 0.0 ? initialRating.toString() : '--',
                    style: textTheme.labelMedium,
                  ),
                ],
              ),
            )
          : Row(
              children: [
                isRatedByMe
                    ? SvgPicture.asset(
                        'assets/icons/star_bold.svg',
                        width: 16,
                        height: 16,
                      )
                    : SvgPicture.asset(
                        'assets/icons/star_light.svg',
                        width: 16,
                        height: 16,
                      ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  initialRating > 0.0 ? initialRating.toString() : '--',
                  style: textTheme.labelMedium,
                ),
              ],
            ),
    );
  }
}

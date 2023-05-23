import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/core/providers/comic_provider.dart';
import 'package:d_reader_flutter/core/providers/selected_rating_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/show_snackbar.dart';
import 'package:d_reader_flutter/ui/widgets/common/confirmation_dialog.dart';
import 'package:d_reader_flutter/ui/widgets/common/rating_stars.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RatingIcon extends ConsumerWidget {
  final double initialRating;
  final int? issueId;
  final String? comicSlug;
  final bool isRatedByMe;
  const RatingIcon({
    Key? key,
    required this.initialRating,
    this.isRatedByMe = false,
    this.issueId,
    this.comicSlug,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: !isRatedByMe && (issueId != null || comicSlug != null)
          ? () async {
              final result = await showDialog(
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

              if (context.mounted && result != null) {
                final isString = result is String;
                showSnackBar(
                  context: context,
                  text: isString ? result : 'Submitted successfully.',
                  duration: 3000,
                  backgroundColor: isString
                      ? ColorPalette.dReaderRed
                      : ColorPalette.dReaderGreen,
                );
              }
            }
          : null,
      child: Row(
        children: [
          Icon(
            isRatedByMe ? Icons.star : Icons.star_outline_outlined,
            color: isRatedByMe ? ColorPalette.dReaderYellow100 : Colors.white,
            size: 16,
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

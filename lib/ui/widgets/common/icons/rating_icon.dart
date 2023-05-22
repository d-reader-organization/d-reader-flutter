import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
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
  final bool isRatedByMe;
  const RatingIcon({
    Key? key,
    required this.initialRating,
    this.isRatedByMe = false,
    this.issueId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: !isRatedByMe && issueId != null
          ? () async {
              final result = await showDialog(
                context: context,
                builder: (context) {
                  return const ConfirmationDialog(
                    title: 'Rate the episode',
                    subtitle: 'Tap a star to give ratings!',
                    additionalChild: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
                      child: RatingStars(),
                    ),
                  );
                },
              );
              final int rating = ref.read(selectedRatingStarIndex) + 1;
              if (result != null && result && rating > 0) {
                final result = await ref.read(
                  rateComicIssueProvider(
                    {
                      'id': issueId,
                      'rating': rating,
                    },
                  ).future,
                );

                if (context.mounted) {
                  showSnackBar(
                    context: context,
                    text: result is String ? result : 'Submitted successfully.',
                    duration: 3000,
                    backgroundColor: result is String
                        ? ColorPalette.dReaderRed
                        : ColorPalette.dReaderGreen,
                  );
                }
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

import 'package:d_reader_flutter/core/providers/unsorted/rating_controller.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
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
          ? () {
              ref.read(ratingControllerProvider.notifier).handleOnTap(
                    context: context,
                    issueId: issueId,
                    comicSlug: comicSlug,
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
                      : ColorPalette.greyscale300,
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
                    style: textTheme.labelLarge?.copyWith(
                      color: ColorPalette.greyscale100,
                    ),
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
                  style: textTheme.labelLarge?.copyWith(
                    color: ColorPalette.greyscale100,
                  ),
                ),
              ],
            ),
    );
  }
}

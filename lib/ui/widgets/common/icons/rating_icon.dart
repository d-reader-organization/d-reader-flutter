import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/core/models/user.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/core/providers/comic_provider.dart';
import 'package:d_reader_flutter/core/providers/selected_rating_provider.dart';
import 'package:d_reader_flutter/core/providers/user/user_provider.dart';
import 'package:d_reader_flutter/core/states/environment_state.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/show_snackbar.dart';
import 'package:d_reader_flutter/ui/utils/trigger_walkthrough_dialog.dart';
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

  _triggerSendVerificationEmail({
    required BuildContext context,
    required WidgetRef ref,
    bool isResending = false,
  }) {
    ref.read(requestEmailVerificationProvider.future);
    Navigator.pop(context);
    showSnackBar(
      context: context,
      text: 'Verification email has been ${isResending ? 'resent' : 'sent'}.',
      milisecondsDuration: 2000,
      backgroundColor: ColorPalette.dReaderGreen,
    );
  }

  _showVerificationWalkthroughDialog({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    triggerWalkthroughDialog(
      context: context,
      title: 'Verify your email',
      subtitle:
          'To rate a ${issueId != null ? 'comic issue' : 'comic'}, first you need to verify your email. Check your email inbox and keep judging!',
      assetPath: '$walkthroughAssetsPath/verify_email.jpg',
      bottomWidget: GestureDetector(
        onTap: () {
          _triggerSendVerificationEmail(
            context: context,
            ref: ref,
            isResending: true,
          );
        },
        child: const Text(
          'Didn\'t get the code?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      onSubmit: () {
        Navigator.pop(context);
      },
    );
  }

  _triggerRatingDialog({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return ConfirmationDialog(
          title: issueId != null ? 'Rate the episode' : 'Rate the comic',
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
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
            child: RatingStars(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: (issueId != null || comicSlug != null)
          ? () async {
              UserModel? user = ref.read(environmentProvider).user;
              if (user != null && !user.isEmailVerified) {
                final result = await ref.read(userRepositoryProvider).myUser();
                final bool isVerified =
                    result != null && result.isEmailVerified;
                if (!isVerified && context.mounted) {
                  return _showVerificationWalkthroughDialog(
                    context: context,
                    ref: ref,
                  );
                }
                ref.read(environmentProvider.notifier).updateEnvironmentState(
                      EnvironmentStateUpdateInput(
                        user: result,
                      ),
                    );
              }
              if (context.mounted) {
                await _triggerRatingDialog(context: context, ref: ref);
              }
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

import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/selected_rating_provider.dart';
import 'package:d_reader_flutter/core/providers/user/user_provider.dart';
import 'package:d_reader_flutter/features/comic/presentation/providers/comic_providers.dart';
import 'package:d_reader_flutter/features/user/domain/models/user.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/state/environment_state.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/show_snackbar.dart';
import 'package:d_reader_flutter/ui/utils/trigger_walkthrough_dialog.dart';
import 'package:d_reader_flutter/ui/widgets/common/dialogs/confirmation_dialog.dart';
import 'package:d_reader_flutter/ui/widgets/common/rating/rating_stars.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'rating_controller.g.dart';

@riverpod
class RatingController extends _$RatingController {
  late StateController<GlobalState> globalNotifier;
  @override
  FutureOr<void> build() {
    globalNotifier = ref.read(globalStateProvider.notifier);
  }

  _triggerSendVerificationEmail({
    required BuildContext context,
    bool isResending = false,
  }) {
    ref.read(requestEmailVerificationProvider.future);
    context.pop();
    showSnackBar(
      context: context,
      text: 'Verification email has been ${isResending ? 'resent' : 'sent'}.',
      backgroundColor: ColorPalette.dReaderGreen,
    );
  }

  void _triggerRatingDialog({
    required BuildContext context,
    int? issueId,
    String? comicSlug,
  }) {
    showDialog(
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

  void _showVerificationWalkthroughDialog({
    required BuildContext context,
    int? issueId,
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
            isResending: true,
          );
        },
        child: Text(
          'Didn\'t get the code?',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(decoration: TextDecoration.underline),
        ),
      ),
      onSubmit: () {
        context.pop();
      },
    );
  }

  Future<void> handleOnTap({
    required BuildContext context,
    int? issueId,
    String? comicSlug,
  }) async {
    UserModel? user = ref.read(environmentProvider).user;
    if (user != null && !user.isEmailVerified) {
      final result = await ref.read(userRepositoryProvider).myUser();
      final bool isVerified = result != null && result.isEmailVerified;
      if (!isVerified && context.mounted) {
        return _showVerificationWalkthroughDialog(
          context: context,
          issueId: issueId,
        );
      }
      ref.read(environmentProvider.notifier).updateEnvironmentState(
            EnvironmentStateUpdateInput(
              user: result,
            ),
          );
    }
    if (context.mounted) {
      _triggerRatingDialog(
        context: context,
        issueId: issueId,
        comicSlug: comicSlug,
      );
    }
  }
}

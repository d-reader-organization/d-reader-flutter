import 'package:d_reader_flutter/core/providers/user/user_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/referrals/body.dart';
import 'package:d_reader_flutter/ui/widgets/referrals/bottom_navigation.dart';
import 'package:d_reader_flutter/ui/widgets/settings/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:skeleton_text/skeleton_text.dart';

class ReferralsView extends ConsumerWidget {
  const ReferralsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myUser = ref.watch(myUserProvider);
    return myUser.when(
      data: (user) {
        if (user == null) {
          return const Center(
            child: Text(
              'Failed to get user',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          );
        }
        return const SettingsScaffold(
          appBarTitle: 'Referrals',
          body: ReferralBody(),
          bottomNavigationBar: ReferralBottomNavigation(),
        );
      },
      error: (error, stackTrace) {
        Sentry.captureException(error,
            stackTrace: 'referrals fail ${stackTrace.toString()}');
        return const Text('');
      },
      loading: () {
        return Scaffold(
          appBar: AppBar(
            shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            leading: SkeletonAnimation(
              shimmerDuration: 1000,
              child: Center(
                child: Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    color: ColorPalette.dReaderGrey,
                    borderRadius: BorderRadius.circular(
                      16,
                    ),
                  ),
                ),
              ),
            ),
            title: SkeletonAnimation(
              shimmerDuration: 1000,
              child: Container(
                height: 32,
                width: 96,
                color: ColorPalette.dReaderGrey,
              ),
            ),
          ),
          body: Column(
            children: [
              const SizedBox(
                height: 8,
              ),
              SkeletonAnimation(
                shimmerDuration: 1000,
                child: Container(
                  height: 126,
                  width: 130,
                  color: ColorPalette.dReaderGrey,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              SkeletonAnimation(
                child: Container(
                  height: 24,
                  width: 240,
                  color: ColorPalette.dReaderGrey,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SkeletonAnimation(
                child: Container(
                  height: 16,
                  width: 160,
                  color: ColorPalette.dReaderGrey,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              SkeletonAnimation(
                child: Container(
                  height: 16,
                  width: 180,
                  color: ColorPalette.dReaderGrey,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Center(
                child: SkeletonAnimation(
                  child: Container(
                    height: 16,
                    width: 96,
                    color: ColorPalette.dReaderGrey,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

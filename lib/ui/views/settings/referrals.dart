import 'package:d_reader_flutter/core/providers/user/user_provider.dart';
import 'package:d_reader_flutter/ui/widgets/referrals/body.dart';
import 'package:d_reader_flutter/ui/widgets/referrals/bottom_navigation.dart';
import 'package:d_reader_flutter/ui/widgets/settings/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

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
        Sentry.captureException(error, stackTrace: stackTrace);
        return const Text('');
      },
      loading: () {
        return const SizedBox();
      },
    );
  }
}

import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/models/user.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/providers/user/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BetaAccessWrapper extends ConsumerWidget {
  final Widget child;
  const BetaAccessWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(environmentProvider).solanaCluster ==
            SolanaCluster.devnet.value
        ? ref.watch(myUserProvider).maybeWhen(
            data: (data) {
              if (data == null || data.role == UserRole.tester.name) {
                return const Center(
                  child: Text(
                    "You do not have alpha access. Go to 'settings > referrals' to claim it",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }
              return child;
            },
            orElse: () {
              return const SizedBox();
            },
          )
        : child;
  }
}

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
    return const Text('Hey change');
    // return ref.watch(myWalletProvider).maybeWhen(
    //   data: (data) {
    //     // TODO: we should actually check if the user.role is 'Tester' instead of isEmailVerified
    //     if (data == null || !data.isEmailVerified) {
    //       return const Center(
    //         child: Text(
    //           "You do not have alpha access. Go to 'settings > referrals' to claim it",
    //           textAlign: TextAlign.center,
    //           style: TextStyle(
    //             fontSize: 18,
    //             fontWeight: FontWeight.w600,
    //           ),
    //         ),
    //       );
    //     }
    //     return child;
    //   },
    //   orElse: () {
    //     return const SizedBox();
    //   },
    // );
  }
}

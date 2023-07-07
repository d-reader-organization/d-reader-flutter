import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MintingProgressWidget extends ConsumerWidget {
  final EdgeInsetsGeometry? margin;
  const MintingProgressWidget({
    super.key,
    this.margin,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SizedBox();
    // ref.watch(globalStateProvider).isMinting != null
    //     ? Container(
    //         margin: margin,
    //         padding: const EdgeInsets.symmetric(
    //           vertical: 16,
    //         ),
    //         width: double.infinity,
    //         decoration: BoxDecoration(
    //           color: ref.watch(globalStateProvider).isMinting!
    //               ? ColorPalette.dReaderBlue
    //               : ColorPalette.dReaderGreen,
    //         ),
    //         child: Text(
    //           ref.watch(globalStateProvider).isMinting!
    //               ? 'Confirming transaction'
    //               : 'Transaction successful',
    //           textAlign: TextAlign.center,
    //           style: const TextStyle(
    //             fontSize: 14,
    //             fontWeight: FontWeight.normal,
    //             letterSpacing: 0.2,
    //           ),
    //         ),
    //       )
    //     : const SizedBox();
  }
}

import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TestModeWidget extends ConsumerWidget {
  const TestModeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(environmentProvider).solanaCluster ==
            SolanaCluster.devnet.value
        ? Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: ColorPalette.dReaderOrange,
            ),
            child: const Text(
              'You\'re in test mode!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        : const SizedBox();
  }
}

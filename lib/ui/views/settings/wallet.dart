import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/providers/wallet/wallet_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(
      getWalletProvider(
        address: ref.read(environmentProvider).publicKey?.toBase58() ?? '',
      ),
    );
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      body: provider.when(
        data: (data) {
          if (data == null) {
            return const Center(
              child: Text(
                'User does not have a connected wallet',
              ),
            );
          }
          return ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: ColorPalette.boxBackground200,
                  borderRadius: BorderRadius.circular(
                    8,
                  ),
                ),
                child: Text('Wallet ${data.address}'),
              ),
            ],
          );
        },
        error: (error, stackTrace) {
          Sentry.captureException(error, stackTrace: stackTrace);
          return const Center(
            child: Text('Something went wrong'),
          );
        },
        loading: () => const SizedBox(),
      ),
      bottomNavigationBar: CustomTextButton(
        borderRadius: BorderRadius.circular(8),
        onPressed: () {},
        size: const Size(double.infinity, 50),
        padding: const EdgeInsets.all(16),
        child: const Text(
          'Add / Connect Wallet',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

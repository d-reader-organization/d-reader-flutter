import 'package:d_reader_flutter/features/wallet/presentation/providers/local_wallet/local_wallet_notifier.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/widgets/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const String createWallet = 'Create wallet';
const String deleteWallet = 'Delete wallet';

class CreateAWalletButton extends ConsumerWidget {
  const CreateAWalletButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(localWalletNotifierProvider).when(
      data: (data) {
        return data == null
            ? CustomTextButton(
                padding: const EdgeInsets.all(16),
                size: const Size(double.infinity, 50),
                onPressed:
                    ref.read(localWalletNotifierProvider.notifier).createWallet,
                child: const Text(
                  createWallet,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            : CustomTextButton(
                padding: const EdgeInsets.all(16),
                size: const Size(double.infinity, 50),
                onPressed:
                    ref.read(localWalletNotifierProvider.notifier).deleteWallet,
                child: const Text(
                  deleteWallet,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
      },
      error: (Object error, StackTrace stackTrace) {
        return const SizedBox();
      },
      loading: () {
        return CustomTextButton(
          padding: const EdgeInsets.all(16),
          size: const Size(double.infinity, 50),
          onPressed:
              ref.read(localWalletNotifierProvider.notifier).deleteWallet,
          isLoading: true,
          loadingColor: ColorPalette.appBackgroundColor,
          child: const Text(
            deleteWallet,
          ),
        );
      },
    );
  }
}

import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/providers/auth_provider.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/solana_client_provider.dart';
import 'package:d_reader_flutter/ui/views/splash.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WelcomeView extends HookConsumerWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final globalHook = useGlobalState();
    return globalHook.value.showSplash
        ? const SplashView()
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(Config.logoTextPath),
                const SizedBox(
                  height: 24,
                ),
                RoundedButton(
                  text: 'Connect',
                  size: const Size(double.infinity, 52),
                  isLoading: globalHook.value.isLoading,
                  fontSize: 24,
                  onPressed: () async {
                    globalHook.value =
                        globalHook.value.copyWith(isLoading: true);
                    final result = await ref
                        .read(solanaProvider.notifier)
                        .authorizeAndSignMessage();
                    if (result == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Failed to sign a message.',
                          ),
                        ),
                      );
                      globalHook.value = globalHook.value
                          .copyWith(isLoading: false, showSplash: false);
                      return;
                    }
                    final String token = await ref
                        .read(solanaProvider.notifier)
                        .getTokenAfterSigning(result);
                    globalHook.value = globalHook.value
                        .copyWith(isLoading: false, showSplash: true);
                    Future.delayed(
                        const Duration(
                          milliseconds: 2000,
                        ), () async {
                      globalHook.value = globalHook.value
                          .copyWith(isLoading: false, showSplash: false);
                      await ref.read(authProvider.notifier).storeToken(token);
                    });
                  },
                ),
                // RoundedButton(
                //   text: 'Mint',
                //   size: const Size(double.infinity, 48),
                //   fontSize: 22,
                //   onPressed: () async {
                //     bool response =
                //         await ref.read(solanaProvider.notifier).mint();
                //   },
                // ),
              ],
            ),
          );
  }
}

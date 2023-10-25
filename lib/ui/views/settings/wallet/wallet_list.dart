import 'package:d_reader_flutter/core/models/exceptions.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/notifiers/owned_comics_notifier.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/solana_client_provider.dart';
import 'package:d_reader_flutter/core/providers/user/user_provider.dart';
import 'package:d_reader_flutter/core/providers/wallet/wallet_provider.dart';
import 'package:d_reader_flutter/core/states/environment_state.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/format_address.dart';
import 'package:d_reader_flutter/ui/utils/format_price.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/utils/show_snackbar.dart';
import 'package:d_reader_flutter/ui/utils/trigger_bottom_sheet.dart';
import 'package:d_reader_flutter/ui/utils/trigger_walkthrough_dialog.dart';
import 'package:d_reader_flutter/ui/views/settings/wallet/wallet_info.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/why_need_wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:solana/solana.dart' show Ed25519HDPublicKey;

class WalletListScreen extends ConsumerWidget {
  final int userId;
  const WalletListScreen({
    super.key,
    required this.userId,
  });

  final topTextStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  final bottomTextStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: ColorPalette.greyscale100,
  );

  _handleWalletSelect(WidgetRef ref, String address) async {
    final signature =
        ref.read(environmentProvider).wallets?[address]?.signature;
    final walletAuthToken =
        ref.read(environmentProvider).wallets?[address]?.authToken;
    if (signature == null) {
      return await ref.read(solanaProvider.notifier).authorizeAndSignMessage();
    }
    ref.read(environmentProvider.notifier).updateEnvironmentState(
          EnvironmentStateUpdateInput(
              publicKey: Ed25519HDPublicKey.fromBase58(
                address,
              ),
              signature: signature.codeUnits,
              authToken: walletAuthToken),
        );
    ref.read(selectedWalletProvider.notifier).update(
          (state) => address,
        );
  }

  _handleWalletConnect({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final globalNotifier = ref.read(globalStateProvider.notifier);

    try {
      final result = await ref
          .read(solanaProvider.notifier)
          .authorizeAndSignMessage(null, () {
        globalNotifier.update(
          (state) => state.copyWith(
            isLoading: true,
          ),
        );
      });

      globalNotifier.update(
        (state) => state.copyWith(
          isLoading: false,
        ),
      );
      final bool isConnected = result == 'OK';
      if (context.mounted) {
        showSnackBar(
          context: context,
          milisecondsDuration: 2000,
          text: isConnected ? 'Wallet has been connected.' : result,
        );
        if (isConnected) {
          ref.invalidate(selectedWalletProvider);
          ref.invalidate(userWalletsProvider);
          ref.invalidate(ownedComicsAsyncProvider);
        }
      }
    } catch (exception) {
      globalNotifier.update(
        (state) => state.copyWith(
          isLoading: false,
        ),
      );
      if (context.mounted) {
        if (exception is LowPowerModeException) {
          return triggerLowPowerModeDialog(context);
        } else if (exception is NoWalletFoundException) {
          return triggerInstallWalletBottomSheet(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletsProvider = ref.watch(
      userWalletsProvider(
        id: userId,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Wallet',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: walletsProvider.when(
          data: (data) {
            if (data.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SvgPicture.asset(
                    'assets/icons/intro/splash_2.svg',
                    height: 281,
                    width: 238,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    ref.watch(isWalletAvailableProvider).maybeWhen(
                          data: (data) {
                            return data
                                ? 'No wallet connected'
                                : 'No wallet detected';
                          },
                          orElse: () => '',
                        ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const WhyDoINeedWalletWidget(),
                ],
              );
            }
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final walletName = data[index].label.isNotEmpty
                    ? data[index].label
                    : 'Wallet ${index + 1}';
                return GestureDetector(
                  onTap: () {
                    nextScreenPush(
                      context,
                      WalletInfoScreen(
                        address: data[index].address,
                        name: walletName,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: ColorPalette.greyscale400,
                      borderRadius: BorderRadius.circular(
                        8,
                      ),
                      border: Border.all(
                        color: ref.watch(selectedWalletProvider) ==
                                data[index].address
                            ? ColorPalette.dReaderYellow100
                            : ColorPalette.greyscale400,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                walletName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: topTextStyle,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                formatAddress(data[index].address, 4),
                                style: bottomTextStyle,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 48,
                          child: VerticalDivider(
                            color: ColorPalette.greyscale300,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ref
                                      .watch(
                                    accountInfoProvider(
                                      address: data[index].address,
                                    ),
                                  )
                                      .when(
                                    data: (accountData) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${formatPriceWithSignificant((accountData.value?.lamports ?? 0))} \$SOL',
                                            style: bottomTextStyle,
                                          ),
                                        ],
                                      );
                                    },
                                    error: (error, stackTrace) {
                                      return const SizedBox();
                                    },
                                    loading: () {
                                      return const SizedBox();
                                    },
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  _handleWalletSelect(ref, data[index].address);
                                },
                                child: Icon(
                                  ref.watch(selectedWalletProvider) ==
                                          data[index].address
                                      ? Icons.circle
                                      : Icons.circle_outlined,
                                  color: ref.watch(selectedWalletProvider) ==
                                          data[index].address
                                      ? ColorPalette.dReaderYellow100
                                      : ColorPalette.greyscale300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
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
      ),
      bottomNavigationBar: CustomTextButton(
        borderRadius: BorderRadius.circular(8),
        onPressed: () async {
          await _handleWalletConnect(context: context, ref: ref);
        },
        size: const Size(double.infinity, 50),
        isLoading: ref.watch(globalStateProvider).isLoading,
        padding: const EdgeInsets.all(16),
        child: Text(
          ref.watch(isWalletAvailableProvider).maybeWhen(
            data: (data) {
              return data ? 'Add / Connect Wallet' : 'Install wallet';
            },
            orElse: () {
              return '';
            },
          ),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

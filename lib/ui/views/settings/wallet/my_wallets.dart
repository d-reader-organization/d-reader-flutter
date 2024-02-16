import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/constants/enums.dart';
import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/notifiers/owned_comics_notifier.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/solana_client_provider.dart';
import 'package:d_reader_flutter/core/providers/user/user_provider.dart';
import 'package:d_reader_flutter/core/providers/wallet/wallet_notifier.dart';
import 'package:d_reader_flutter/core/providers/wallet/wallet_provider.dart';
import 'package:d_reader_flutter/core/states/environment_state.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/dialog_triggers.dart';
import 'package:d_reader_flutter/ui/utils/formatter.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/utils/show_snackbar.dart';
import 'package:d_reader_flutter/ui/utils/trigger_walkthrough_dialog.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/confirmation_dialog.dart';
import 'package:d_reader_flutter/ui/widgets/common/why_need_wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solana/solana.dart' show Ed25519HDPublicKey;

class MyWalletsScreen extends ConsumerWidget {
  final int userId;
  const MyWalletsScreen({
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

  _handleWalletSelect({
    required WidgetRef ref,
    required BuildContext context,
    required String address,
  }) async {
    final walletAuthToken =
        ref.read(environmentProvider).wallets?[address]?.authToken;
    if (walletAuthToken == null) {
      final shouldAuthorize = await showDialog<bool>(
            context: context,
            builder: (context) {
              return ConfirmationDialog(
                title: '',
                subtitle:
                    'Wallet ${Formatter.formatAddress(address, 3)} is not authorized on the dReader mobile app. Would you like to grant dReader the rights to communicate with your mobile wallet?',
              );
            },
          ) ??
          false;
      if (!shouldAuthorize) {
        return;
      }

      await ref.read(solanaProvider.notifier).authorizeIfNeededWithOnComplete();
      ref.read(selectedWalletProvider.notifier).update((state) =>
          ref.read(environmentProvider).publicKey?.toBase58() ?? address);
      return ref.invalidate(userWalletsProvider);
    }
    ref.read(environmentProvider.notifier).updateEnvironmentState(
          EnvironmentStateUpdateInput(
            publicKey: Ed25519HDPublicKey.fromBase58(
              address,
            ),
            authToken: walletAuthToken,
          ),
        );
    ref.read(selectedWalletProvider.notifier).update(
          (state) => address,
        );
  }

  _handleWalletConnect({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    await ref.read(walletControllerProvider.notifier).connectWallet(
      onSuccess: () {
        showSnackBar(
          context: context,
          text: 'Wallet has been connected',
          backgroundColor: ColorPalette.dReaderGreen,
        );
        ref.invalidate(selectedWalletProvider);
        ref.invalidate(userWalletsProvider);
        ref.invalidate(ownedComicsAsyncProvider);
      },
      onFail: (String result) {
        showSnackBar(
          context: context,
          text: result,
          backgroundColor: ColorPalette.dReaderRed,
        );
      },
      onError: (exception) {
        triggerLowPowerOrNoWallet(context, exception);
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletsProvider = ref.watch(
      userWalletsProvider(
        id: userId,
      ),
    );
    return walletsProvider.when(
      data: (data) {
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
            child: data.isEmpty
                ? Column(
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
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(userWalletsProvider);
                    },
                    backgroundColor: ColorPalette.dReaderYellow100,
                    color: ColorPalette.appBackgroundColor,
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final walletName = data[index].label.isNotEmpty
                            ? data[index].label
                            : 'Wallet ${index + 1}';
                        return GestureDetector(
                          onTap: () {
                            nextScreenPush(
                              context: context,
                              path:
                                  '${RoutePath.walletInfo}?address=${data[index].address}&name=$walletName',
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        Formatter.formatAddress(
                                            data[index].address, 4),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                    '${Formatter.formatPriceWithSignificant((accountData.value?.lamports ?? 0))} \$SOL',
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
                                          _handleWalletSelect(
                                            ref: ref,
                                            context: context,
                                            address: data[index].address,
                                          );
                                        },
                                        child: Icon(
                                          ref.watch(selectedWalletProvider) ==
                                                  data[index].address
                                              ? Icons.circle
                                              : Icons.circle_outlined,
                                          color: ref.watch(
                                                      selectedWalletProvider) ==
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
                    ),
                  ),
          ),
          bottomNavigationBar: CustomTextButton(
            borderRadius: BorderRadius.circular(8),
            onPressed: ref.watch(isOpeningSessionProvider)
                ? null
                : () async {
                    if (data.isNotEmpty) {
                      await triggerWalkthroughDialogIfNeeded(
                        context: context,
                        key: WalkthroughKeys.multipleWallet.name,
                        title: 'Another wallet',
                        subtitle:
                            'When connecting multiple wallets to dReader bare in mind to always match the wallet selected on dReader with the mobile wallet app which holds its private keys',
                        assetPath: '$walkthroughAssetsPath/multiple_wallet.jpg',
                        onSubmit: () {
                          context.pop();
                        },
                      );
                    }
                    if (context.mounted) {
                      await _handleWalletConnect(context: context, ref: ref);
                    }
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
      },
      error: (error, stackTrace) {
        return const Center(
          child: Text('Failed to fetch data'),
        );
      },
      loading: () {
        return const SizedBox();
      },
    );
  }
}

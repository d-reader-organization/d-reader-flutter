import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/constants/enums.dart';
import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/features/library/presentation/providers/owned/owned_providers.dart';
// import 'package:d_reader_flutter/features/settings/presentation/widgets/create_wallet_button.dart';
import 'package:d_reader_flutter/features/user/presentation/providers/user_providers.dart';
import 'package:d_reader_flutter/features/wallet/presentation/providers/wallet_notifier.dart';
import 'package:d_reader_flutter/features/wallet/presentation/providers/wallet_providers.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/mobile_wallet_adapter/solana_providers.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/dialog_triggers.dart';
import 'package:d_reader_flutter/shared/utils/formatter.dart';
import 'package:d_reader_flutter/shared/utils/screen_navigation.dart';
import 'package:d_reader_flutter/shared/utils/show_snackbar.dart';
import 'package:d_reader_flutter/shared/widgets/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/features/wallet/presentation/widgets/why_need_wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
            actions: data.isEmpty
                ? null
                : [
                    IconButton(
                      onPressed: () {
                        ref
                            .read(walletControllerProvider.notifier)
                            .handleSyncWallets(
                          afterSync: () {
                            showSnackBar(
                              context: context,
                              text: 'Wallets synced successfully',
                              backgroundColor: ColorPalette.dReaderGreen,
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.refresh,
                      ),
                    ),
                  ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: data.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/no_wallet_detected.svg',
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
                      ref
                          .read(walletControllerProvider.notifier)
                          .handleSyncWallets(
                        afterSync: () {
                          showSnackBar(
                            context: context,
                            text: 'Wallets synced successfully',
                            backgroundColor: ColorPalette.dReaderGreen,
                          );
                        },
                      );
                    },
                    backgroundColor: ColorPalette.dReaderYellow100,
                    color: ColorPalette.appBackgroundColor,
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final wallet = data[index];
                        final walletName = wallet.label.isNotEmpty
                            ? wallet.label
                            : 'Wallet ${index + 1}';
                        final existingAuthToken = ref
                                .read(environmentProvider)
                                .walletAuthTokenMap?[wallet.address] ??
                            '';
                        final bool isSelected =
                            ref.watch(selectedWalletProvider) == wallet.address;
                        return GestureDetector(
                          onTap: () {
                            if (isSelected) {
                              return;
                            }
                            ref
                                .read(walletControllerProvider.notifier)
                                .handleWalletSelect(
                                  address: wallet.address,
                                  onAuthorizeNeeded: () async {
                                    return await triggerConfirmationDialog(
                                      context: context,
                                      title: '',
                                      subtitle:
                                          'Wallet ${Formatter.formatAddress(wallet.address, 3)} is not authorized on the dReader mobile app. Would you like to grant dReader the rights to communicate with your mobile wallet?',
                                    );
                                  },
                                )
                                .then((value) {
                              if (value) {
                                showSnackBar(
                                  context: context,
                                  milisecondsDuration: 1800,
                                  text:
                                      'Wallet with ${Formatter.formatAddress(wallet.address, 4)} is selected as active',
                                );
                              }
                            });
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
                                color: isSelected
                                    ? ColorPalette.dReaderYellow100
                                    : ColorPalette.greyscale400,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        existingAuthToken.isNotEmpty
                                            ? 'assets/icons/link_wallet.svg'
                                            : 'assets/icons/unlink_wallet.svg',
                                        colorFilter: ColorFilter.mode(
                                          existingAuthToken.isNotEmpty
                                              ? Colors.white
                                              : ColorPalette.greyscale100,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      Column(
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
                                                wallet.address, 4),
                                            style: bottomTextStyle,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: SizedBox(
                                    height: 48,
                                    child: VerticalDivider(
                                      color: ColorPalette.greyscale300,
                                    ),
                                  ),
                                ),
                                Expanded(
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
                                              address: wallet.address,
                                            ),
                                          )
                                              .when(
                                            data: (accountData) {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${Formatter.formatPriceWithSignificant((accountData.value?.lamports ?? 0))} SOL',
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
                                      IconButton(
                                        padding: const EdgeInsets.only(
                                          top: 24,
                                          bottom: 24,
                                          left: 16,
                                          right: 4,
                                        ),
                                        onPressed: () {
                                          nextScreenPush(
                                            context: context,
                                            path:
                                                '${RoutePath.walletInfo}?address=${wallet.address}&name=$walletName',
                                          );
                                        },
                                        icon: SvgPicture.asset(
                                          'assets/icons/more.svg',
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
          bottomNavigationBar: SafeArea(
            child: Wrap(
              children: [
                // const CreateAWalletButton(),
                CustomTextButton(
                  borderRadius: BorderRadius.circular(8),
                  onPressed: ref.watch(isOpeningSessionProvider)
                      ? null
                      : () async {
                          if (data.isNotEmpty) {
                            await triggerWalkthroughDialogIfNeeded(
                              context: context,
                              key: WalkthroughKeys.multipleWallet.name,
                              title: 'Multiple wallets',
                              subtitle:
                                  "When 2 or more wallets are connected to dReader, one will always be selected as 'active'. To switch the active wallet, click on any of the wallets listed on this screen",
                              assetPath:
                                  '$walkthroughAssetsPath/multiple_wallet.jpg',
                              onSubmit: () {
                                context.pop();
                              },
                            );
                          }
                          await ref
                              .read(walletControllerProvider.notifier)
                              .connectWallet(
                            onSuccess: () {
                              showSnackBar(
                                context: context,
                                text: 'Wallet has been connected',
                                backgroundColor: ColorPalette.dReaderGreen,
                              );
                              ref.invalidate(userWalletsProvider);
                              ref.invalidate(ownedComicsProvider);
                            },
                            onFail: (String result) {
                              showSnackBar(
                                context: context,
                                text: result,
                                backgroundColor: ColorPalette.dReaderRed,
                              );
                            },
                            onException: (exception) {
                              triggerLowPowerOrNoWallet(context, exception);
                            },
                          );
                        },
                  size: const Size(double.infinity, 50),
                  isLoading: ref.watch(globalNotifierProvider).isLoading,
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
              ],
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

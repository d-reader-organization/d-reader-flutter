import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/providers/auth/auth_provider.dart';
import 'package:d_reader_flutter/core/providers/chain_subscription_client.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/solana_client_provider.dart';
import 'package:d_reader_flutter/core/providers/user/user_provider.dart';
import 'package:d_reader_flutter/core/providers/wallet/wallet_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/formatter.dart';
import 'package:d_reader_flutter/ui/utils/show_snackbar.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/rounded_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/text_field.dart';
import 'package:d_reader_flutter/ui/widgets/settings/list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WalletInfoScreen extends StatefulHookConsumerWidget {
  final String address, name;
  const WalletInfoScreen({
    super.key,
    required this.address,
    required this.name,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WalletInfoScreenState();
}

class _WalletInfoScreenState extends ConsumerState<WalletInfoScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
  }

  Future _handleDisconnectWallet(BuildContext context, WidgetRef ref) async {
    await ref.read(authRepositoryProvider).disconnectWallet(
          address: widget.address,
        );
    final envState = ref.read(environmentProvider);
    envState.wallets?.removeWhere((key, value) => key == widget.address);
    if (ref.read(environmentProvider).publicKey?.toBase58() == widget.address) {
      ref.read(environmentProvider.notifier).clearPublicKey();
    }
    ref.read(environmentProvider.notifier).putStateIntoLocalStore();
    ref.invalidate(userWalletsProvider);
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  _handleUpdateWallet(BuildContext context, WidgetRef ref) async {
    final globalNotifier = ref.read(globalStateProvider.notifier);
    globalNotifier.update(
      (state) => state.copyWith(
        isLoading: true,
      ),
    );

    final result = await ref.read(walletRepositoryProvider).updateWallet(
          address: widget.address,
          label: _nameController.text.trim(),
        );
    globalNotifier.update(
      (state) => state.copyWith(
        isLoading: false,
      ),
    );
    ref.invalidate(walletNameProvider);
    ref.invalidate(userWalletsProvider);
    if (context.mounted) {
      return showSnackBar(
        context: context,
        text: result is String ? result : 'Wallet updated successfully',
        backgroundColor: result is String
            ? ColorPalette.dReaderRed
            : ColorPalette.dReaderGreen,
      );
    }
  }

  _syncWallet({
    required BuildContext context,
    required WidgetRef ref,
    required String address,
  }) async {
    final notifier = ref.read(privateLoadingProvider.notifier);

    notifier.update((state) => true);
    await ref.read(syncWalletProvider(address).future);
    notifier.update((state) => false);
    ref.invalidate(userWalletsProvider);

    if (context.mounted) {
      showSnackBar(
        context: context,
        text: 'Wallet synced successfully',
        backgroundColor: ColorPalette.dReaderGreen,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final globalHook = useGlobalState();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Text(
          widget.name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: [
          ref.watch(chainSubscriptionClientProvider(widget.address)).when(
            data: (data) {
              return Text(
                '${Formatter.formatPriceWithSignificant(data?.lamports ?? 0)} \$SOL',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              );
            },
            error: (error, stackTrace) {
              return const SizedBox();
            },
            loading: () {
              return const Center(
                child: CircularProgressIndicator(
                  color: ColorPalette.greyscale500,
                ),
              );
            },
          ),
          const SizedBox(
            height: 16,
          ),
          CustomTextField(
            labelText: 'Name',
            controller: _nameController,
            onChange: (value) {
              ref.read(walletNameProvider.notifier).update((state) => value);
            },
          ),
          CustomTextField(
            labelText: 'Address',
            isReadOnly: true,
            hintText: Formatter.formatAddress(widget.address),
            suffix: GestureDetector(
              onTap: () async {
                await Clipboard.setData(
                  ClipboardData(
                    text: widget.address,
                  ),
                ).then(
                  (value) => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Wallet address copied to clipboard",
                      ),
                    ),
                  ),
                );
              },
              child: const Icon(
                Icons.copy,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
          const Divider(
            color: ColorPalette.greyscale400,
          ),
          SettingsCommonListTile(
            title: 'Sync wallet',
            leadingPath: '${Config.settingsAssetsPath}/light/wallet.svg',
            overrideColor: Colors.green,
            overrideLeading: ref.watch(privateLoadingProvider)
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: ColorPalette.dReaderGreen,
                    ),
                  )
                : null,
            overrideTrailing: const SizedBox(),
            onTap: ref.watch(globalStateProvider).isLoading
                ? null
                : () async {
                    await _syncWallet(
                      context: context,
                      ref: ref,
                      address: widget.address,
                    );
                  },
          ),
          if (ref.read(environmentProvider).solanaCluster ==
              SolanaCluster.devnet.value) ...[
            SettingsCommonListTile(
              title: 'Airdrop \$SOL',
              leadingPath: '${Config.settingsAssetsPath}/light/arrow_down.svg',
              overrideColor: ref.watch(globalStateProvider).isLoading
                  ? ColorPalette.greyscale300
                  : ColorPalette.dReaderGreen,
              overrideLeading: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: SvgPicture.asset(
                  '${Config.settingsAssetsPath}/light/arrow_down.svg',
                  colorFilter: ColorFilter.mode(
                    ref.watch(globalStateProvider).isLoading
                        ? ColorPalette.greyscale300
                        : ColorPalette.dReaderGreen,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              overrideTrailing: globalHook.value.isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: ColorPalette.greyscale300,
                      ),
                    )
                  : null,
              onTap: globalHook.value.isLoading
                  ? null
                  : () async {
                      globalHook.value =
                          globalHook.value.copyWith(isLoading: true);
                      final airdropResult = await ref
                          .read(solanaProvider.notifier)
                          .requestAirdrop(widget.address);

                      globalHook.value =
                          globalHook.value.copyWith(isLoading: false);
                      if (context.mounted) {
                        bool isSuccessful =
                            airdropResult?.contains('SOL') ?? false;

                        showSnackBar(
                          context: context,
                          text: isSuccessful
                              ? airdropResult ??
                                  "Successfully airdropped 2 \$SOL "
                              : 'Failed to airdrop 2 \$SOL',
                          backgroundColor: isSuccessful
                              ? ColorPalette.dReaderGreen
                              : ColorPalette.dReaderRed,
                        );
                      }
                    },
            ),
          ],
          SettingsCommonListTile(
            title: 'Disconnect wallet',
            leadingPath: '${Config.settingsAssetsPath}/light/logout.svg',
            overrideColor: ColorPalette.dReaderRed,
            onTap: () async {
              await _handleDisconnectWallet(context, ref);
            },
          ),
        ],
      ),
      bottomNavigationBar: AnimatedOpacity(
        opacity: ref.watch(walletNameProvider).isNotEmpty &&
                ref.watch(walletNameProvider).trim() != widget.name
            ? 1.0
            : 0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 8,
          ),
          child: Row(
            children: [
              Expanded(
                child: RoundedButton(
                  text: 'Cancel',
                  backgroundColor: Colors.transparent,
                  textColor: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: ColorPalette.greyscale50,
                  ),
                  borderColor: ColorPalette.greyscale50,
                  size: const Size(
                    0,
                    50,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Expanded(
                child: RoundedButton(
                  text: 'Save',
                  isLoading: ref.watch(globalStateProvider).isLoading,
                  backgroundColor: ColorPalette.dReaderYellow100,
                  textColor: Colors.black,
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  size: const Size(
                    0,
                    50,
                  ),
                  onPressed: () async {
                    await _handleUpdateWallet(context, ref);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

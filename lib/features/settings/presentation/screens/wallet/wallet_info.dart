import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/features/wallet/presentation/providers/local_wallet/local_wallet_notifier.dart';
import 'package:d_reader_flutter/features/wallet/presentation/providers/wallet_notifier.dart';
import 'package:d_reader_flutter/features/wallet/presentation/providers/wallet_providers.dart';
import 'package:d_reader_flutter/shared/data/local/secure_store.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_providers.dart';
import 'package:d_reader_flutter/shared/utils/utils.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/formatter.dart';
import 'package:d_reader_flutter/shared/utils/show_snackbar.dart';
import 'package:d_reader_flutter/shared/widgets/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/shared/widgets/dialogs/confirmation_dialog.dart';
import 'package:d_reader_flutter/shared/widgets/textfields/text_field.dart';
import 'package:d_reader_flutter/features/settings/presentation/widgets/list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
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

  @override
  Widget build(BuildContext context) {
    final globalHook = useGlobalState();
    final textTheme = Theme.of(context).textTheme;
    final isLocalWallet =
        ref.read(localWalletNotifierProvider).value?.address == widget.address;
    final shouldConnectWallet =
        ref.read(environmentProvider).walletAuthTokenMap?[widget.address] ==
            null;
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
                '${Formatter.formatPriceWithSignificant(data?.lamports ?? 0)} SOL',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
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
          shouldConnectWallet && !isLocalWallet
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 35,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          8,
                        ),
                        border: Border.all(color: ColorPalette.greyscale200),
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/unlink_wallet.svg',
                        colorFilter: const ColorFilter.mode(
                          ColorPalette.greyscale200,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    CustomTextButton(
                      onPressed: () {
                        ref
                            .read(walletControllerProvider.notifier)
                            .handleWalletSelect(
                              address: widget.address,
                              onAuthorizeNeeded: () async {
                                return true;
                              },
                            );
                      },
                      padding: EdgeInsets.zero,
                      borderColor: ColorPalette.greyscale200,
                      backgroundColor: Colors.transparent,
                      child: Text(
                        'Set as active wallet',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: ColorPalette.greyscale200,
                            ),
                      ),
                    )
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ref.watch(selectedWalletProvider) == widget.address
                        ? CustomTextButton(
                            onPressed: null,
                            padding: EdgeInsets.zero,
                            backgroundColor:
                                ColorPalette.dReaderYellow100.withOpacity(.1),
                            child: Text(
                              'Active wallet',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: ColorPalette.dReaderYellow100,
                                  ),
                            ),
                          )
                        : CustomTextButton(
                            padding: EdgeInsets.zero,
                            backgroundColor: Colors.transparent,
                            onPressed: () {
                              ref
                                  .read(environmentProvider.notifier)
                                  .updatePublicKeyFromBase58(widget.address);
                              showSnackBar(
                                context: context,
                                milisecondsDuration: 1800,
                                text: 'Wallet is selected as active',
                              );
                            },
                            borderColor: ColorPalette.dReaderYellow100,
                            child: Text(
                              'Set as active wallet',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: ColorPalette.dReaderYellow100,
                                  ),
                            ),
                          ),
                  ],
                ),
          const SizedBox(
            height: 16,
          ),
          if (widget.address ==
              ref.read(localWalletNotifierProvider).value?.address) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextButton(
                  onPressed: () async {
                    final storage = ref.read(secureStorageProvider);
                    storage.read(key: Config.mnemonicKey).then(
                      (value) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            contentPadding: const EdgeInsets.all(8),
                            backgroundColor: ColorPalette.greyscale400,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            content: Text(
                              value ?? '',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  size: const Size(0, 50),
                  child: Text(
                    'Export seed phrase',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.black,
                        ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(
            height: 32,
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
            hintText: Formatter.formatAddress(widget.address, 8),
            suffix: GestureDetector(
              onTap: () async {
                await Clipboard.setData(
                  ClipboardData(
                    text: widget.address,
                  ),
                ).then(
                  (value) {
                    showSnackBar(
                      context: context,
                      text: "Wallet address copied to clipboard",
                    );
                  },
                );
              },
              child: SvgPicture.asset(
                '${Config.settingsAssetsPath}/bold/copy.svg',
              ),
            ),
          ),
          const Divider(
            height: 32,
            color: ColorPalette.greyscale400,
          ),
          shouldConnectWallet
              ? SettingsCommonListTile(
                  title: 'Connect wallet to dReader',
                  leadingPath: 'assets/icons/link_wallet.svg',
                  overrideFontSize: 16,
                  onTap: () async {
                    await ref
                        .read(walletControllerProvider.notifier)
                        .handleWalletSelect(
                          address: widget.address,
                          onAuthorizeNeeded: () async {
                            return true;
                          },
                        );
                  },
                )
              : const SizedBox(),
          if (ref.read(environmentProvider).solanaCluster ==
              SolanaCluster.devnet.value) ...[
            SettingsCommonListTile(
              title: 'Airdrop \$SOL',
              leadingPath: '${Config.settingsAssetsPath}/light/arrow_down.svg',
              overrideColor: ref.watch(globalNotifierProvider).isLoading
                  ? ColorPalette.greyscale300
                  : ColorPalette.dReaderGreen,
              overrideFontSize: 16,
              overrideLeading: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: SvgPicture.asset(
                  '${Config.settingsAssetsPath}/light/arrow_down.svg',
                  colorFilter: ColorFilter.mode(
                    ref.watch(globalNotifierProvider).isLoading
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
                      final airdropResult =
                          await requestAirdrop(widget.address);

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
            leadingPath: 'assets/icons/close_square.svg',
            overrideColor: ColorPalette.dReaderRed,
            overrideFontSize: 16,
            onTap: () async {
              final bool shouldDisconnect = await showDialog(
                    context: context,
                    builder: (context) {
                      return const ConfirmationDialog(
                        title: 'Disconnect Wallet',
                        subtitle: 'Are you sure you want to disconnect wallet?',
                      );
                    },
                  ) ??
                  false;
              if (!shouldDisconnect) {
                return;
              }
              if (context.mounted) {
                await ref
                    .read(walletControllerProvider.notifier)
                    .handleDisconnectWallet(
                      address: widget.address,
                      callback: context.pop,
                    );
              }
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
                child: CustomTextButton(
                  backgroundColor: Colors.transparent,
                  borderColor: ColorPalette.greyscale50,
                  size: const Size(
                    0,
                    50,
                  ),
                  onPressed: () {
                    context.pop();
                  },
                  child: Text('Cancel', style: textTheme.titleSmall),
                ),
              ),
              Expanded(
                child: CustomTextButton(
                  isLoading: ref.watch(globalNotifierProvider).isLoading,
                  backgroundColor: ColorPalette.dReaderYellow100,
                  size: const Size(
                    0,
                    50,
                  ),
                  onPressed: () async {
                    await ref
                        .read(walletControllerProvider.notifier)
                        .handleUpdateWallet(
                          address: widget.address,
                          label: _nameController.text.trim(),
                          callback: (result) {
                            showSnackBar(
                              context: context,
                              text: result is String
                                  ? result
                                  : 'Wallet updated successfully',
                              backgroundColor: result is String
                                  ? ColorPalette.dReaderRed
                                  : ColorPalette.dReaderGreen,
                            );
                          },
                        );
                  },
                  child: Text(
                    'Save',
                    style: textTheme.titleSmall?.copyWith(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

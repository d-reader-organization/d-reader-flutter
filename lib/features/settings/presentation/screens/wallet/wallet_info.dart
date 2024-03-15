import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/features/wallet/presentation/providers/wallet_notifier.dart';
import 'package:d_reader_flutter/features/wallet/presentation/providers/wallet_providers.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_providers.dart';
import 'package:d_reader_flutter/shared/utils/utils.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/formatter.dart';
import 'package:d_reader_flutter/shared/utils/show_snackbar.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/textfields/text_field.dart';
import 'package:d_reader_flutter/ui/widgets/settings/list_tile.dart';
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
                  (value) {
                    showSnackBar(
                      context: context,
                      text: "Wallet address copied to clipboard",
                    );
                  },
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
            onTap: ref.watch(globalNotifierProvider).isLoading
                ? null
                : () {
                    ref.read(walletControllerProvider.notifier).syncWallet(
                          address: widget.address,
                          callback: () {
                            showSnackBar(
                              context: context,
                              text: 'Wallet synced successfully',
                              backgroundColor: ColorPalette.dReaderGreen,
                            );
                          },
                        );
                  },
          ),
          if (ref.read(environmentProvider).solanaCluster ==
              SolanaCluster.devnet.value) ...[
            SettingsCommonListTile(
              title: 'Airdrop \$SOL',
              leadingPath: '${Config.settingsAssetsPath}/light/arrow_down.svg',
              overrideColor: ref.watch(globalNotifierProvider).isLoading
                  ? ColorPalette.greyscale300
                  : ColorPalette.dReaderGreen,
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
            leadingPath: '${Config.settingsAssetsPath}/light/logout.svg',
            overrideColor: ColorPalette.dReaderRed,
            onTap: () async {
              await ref
                  .read(walletControllerProvider.notifier)
                  .handleDisconnectWallet(
                    address: widget.address,
                    callback: context.pop,
                  );
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

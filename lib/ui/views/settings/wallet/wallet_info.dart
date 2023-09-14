import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/providers/auth/auth_provider.dart';
import 'package:d_reader_flutter/core/providers/chain_subscription_client.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/user/user_provider.dart';
import 'package:d_reader_flutter/core/providers/wallet/wallet_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/format_address.dart';
import 'package:d_reader_flutter/ui/utils/format_price.dart';
import 'package:d_reader_flutter/ui/utils/show_snackbar.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/rounded_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/text_field.dart';
import 'package:d_reader_flutter/ui/widgets/settings/list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WalletInfoScreen extends ConsumerStatefulWidget {
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
    ref
        .read(environmentProvider)
        .wallets
        ?.removeWhere((key, value) => key == widget.address);
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

  @override
  Widget build(BuildContext context) {
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
                '${formatPriceWithSignificant(data?.lamports ?? 0)} \$SOL',
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
                  color: ColorPalette.boxBackground200,
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
          ),
          CustomTextField(
            labelText: 'Address',
            isReadOnly: true,
            hintText: formatAddress(widget.address),
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
            color: ColorPalette.boxBackground300,
          ),
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
      bottomNavigationBar: Padding(
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
                onPressed: () {},
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
    );
  }
}

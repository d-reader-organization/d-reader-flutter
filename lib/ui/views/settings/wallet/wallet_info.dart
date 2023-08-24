import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/providers/chain_subscription_client.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/format_address.dart';
import 'package:d_reader_flutter/ui/utils/format_price.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/rounded_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/text_field.dart';
import 'package:d_reader_flutter/ui/widgets/settings/list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WalletInfoScreen extends ConsumerWidget {
  final String address, name;

  const WalletInfoScreen({
    super.key,
    required this.address,
    required this.name,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Text(
          name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: [
          ref.watch(chainSubscriptionClientProvider(address)).when(
            data: (data) {
              return Text(
                '\$ ${formatPriceWithSignificant(data?.lamports ?? 0)} SOL',
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
            defaultValue: name,
          ),
          GestureDetector(
            onTap: () {
              Clipboard.setData(
                ClipboardData(
                  text: address,
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
            child: CustomTextField(
              labelText: 'Address',
              isReadOnly: true,
              hintText: formatAddress(address),
              suffix: const Icon(
                Icons.copy,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
          const Divider(
            color: ColorPalette.boxBackground300,
          ),
          const SettingsCommonListTile(
            title: 'Disconnect wallet',
            leadingPath: '${Config.settingsAssetsPath}/light/logout.svg',
            overrideColor: ColorPalette.dReaderRed,
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
                  color: Color(0xFFEBEDF3),
                ),
                borderColor: const Color(0xFFEBEDF3),
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
                onPressed: () async {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

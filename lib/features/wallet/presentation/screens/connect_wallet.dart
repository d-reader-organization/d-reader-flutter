import 'package:d_reader_flutter/features/wallet/presentation/providers/deep_links/wallet_deep_links_notifier.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/screen_navigation.dart';
import 'package:d_reader_flutter/shared/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ConnectWalletScreen extends ConsumerStatefulWidget {
  final Map<String, String> query;
  const ConnectWalletScreen({super.key, required this.query});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<ConnectWalletScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 500),
      () => ref
          .read(walletDeepLinksNotifierProvider.notifier)
          .afterConnect(widget.query),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      walletDeepLinksNotifierProvider,
      (previous, next) {
        next.maybeWhen(
          success: (message) {
            nextScreenReplace(
              context: context,
              path: widget.query['from'] ?? '/',
              homeSubRoute: false,
            );
          },
          failed: (message) {
            // context.pop();
            showSnackBar(context: context, text: message);
          },
          orElse: () => null,
        );
      },
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: ColorPalette.appBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Connect wallet',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

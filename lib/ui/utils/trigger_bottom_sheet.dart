import 'package:d_reader_flutter/ui/widgets/common/install_wallet_bottom_sheet.dart';
import 'package:flutter/material.dart';

triggerInstallWalletBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.65,
        minChildSize: 0.65,
        maxChildSize: 0.8,
        builder: (context, scrollController) {
          return const InstallWalletBottomSheet();
        },
      );
    },
  );
}

import 'package:d_reader_flutter/core/providers/auth_provider.dart';
import 'package:d_reader_flutter/core/providers/solana_client_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LogoutButton extends ConsumerWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () async {
        await ref.read(solanaProvider.notifier).deauthorize();
        await ref.read(authProvider.notifier).clearToken();
      },
      icon: const Icon(
        Icons.logout,
      ),
    );
  }
}

import 'package:d_reader_flutter/core/providers/wallet/wallet_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final walletNameProvider = StateProvider<String>((ref) {
  return '';
});

final validateWalletNameProvider =
    FutureProvider.autoDispose.family<bool, String>(
  (ref, name) {
    return ref.read(walletRepositoryProvider).validateName(name);
  },
);

final isValidWalletNameValue = StateProvider<bool>(
  (ref) {
    return true;
  },
);

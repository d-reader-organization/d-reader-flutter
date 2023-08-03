import 'package:hooks_riverpod/hooks_riverpod.dart';

final walletNameProvider = StateProvider<String>((ref) {
  return '';
});

final isValidWalletNameValue = StateProvider<bool>(
  (ref) {
    return true;
  },
);

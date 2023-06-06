import 'package:d_reader_flutter/core/providers/wallet/wallet_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final referrerNameProvider = StateProvider<String>((ref) {
  return '';
});

final updateReferrer = FutureProvider.autoDispose.family<String, String>(
  (ref, referrer) {
    return ref.read(walletRepositoryProvider).updateReferrer(referrer);
  },
);

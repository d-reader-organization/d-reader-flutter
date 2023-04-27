import 'package:d_reader_flutter/core/repositories/wallet/repository_impl.dart';
import 'package:d_reader_flutter/ioc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final hasReferralProvider = StateProvider<bool>((ref) {
  return false;
});

final referrerNameProvider = StateProvider<String>((ref) {
  return '';
});

final updateReferrer = FutureProvider.autoDispose.family<String, String>(
  (ref, referrer) {
    return IoCContainer.resolveContainer<WalletRepositoryImpl>()
        .updateReferrer(referrer);
  },
);

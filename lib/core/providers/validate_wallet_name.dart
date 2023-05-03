import 'package:d_reader_flutter/core/repositories/wallet/repository_impl.dart';
import 'package:d_reader_flutter/ioc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final validateWalletNameProvider =
    FutureProvider.autoDispose.family<bool, String>(
  (ref, name) {
    return IoCContainer.resolveContainer<WalletRepositoryImpl>()
        .validateName(name);
  },
);

final isValidWalletNameValue = StateProvider<bool>(
  (ref) {
    return true;
  },
);

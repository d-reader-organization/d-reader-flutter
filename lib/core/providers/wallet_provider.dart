import 'package:d_reader_flutter/core/repositories/wallet/repository_impl.dart';
import 'package:d_reader_flutter/ioc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final walletAssetsProvider = FutureProvider((_) {
  return IoCContainer.resolveContainer<WalletRepositoryImpl>().myAssets();
});

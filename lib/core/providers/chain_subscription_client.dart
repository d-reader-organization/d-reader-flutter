import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/providers/wallet/wallet_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solana/dto.dart' show Account;
import 'package:solana/solana.dart';

final chainSubscriptionClientProvider =
    StreamProvider.family.autoDispose<Account?, String>((
  ref,
  address,
) async* {
  final currentAccountData =
      await ref.read(accountInfoProvider(address: address).future);
  final subscriptionClient = SubscriptionClient.connect(
      ref.read(environmentProvider).solanaCluster == SolanaCluster.devnet.value
          ? Config.rpcUrlDevnet.replaceAll(
              'https',
              'ws',
            )
          : Config.rpcUrlMainnet.replaceAll(
              'https',
              'ws',
            ));
  try {
    Account? accountData = currentAccountData.value;
    subscriptionClient
        .accountSubscribe(
      address,
    )
        .listen((event) {
      accountData = event;
    });
    yield accountData;
  } catch (error) {
    throw Exception(error);
  }
});
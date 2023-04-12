import 'package:d_reader_flutter/config/config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final selectedNetworkProvider = StateProvider<String>((ref) {
  return SolanaCluster.mainnet.value;
});

import 'package:d_reader_flutter/core/models/nft.dart';
import 'package:d_reader_flutter/core/providers/dio_provider.dart';
import 'package:d_reader_flutter/core/repositories/nft/repository_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final nftRepositoryProvider = Provider<NftRepositoryImpl>(
  (ref) {
    return NftRepositoryImpl(
      client: ref.watch(
        dioProvider(
          null,
        ),
      ),
    );
  },
);

final nftProvider =
    FutureProvider.autoDispose.family<NftModel?, String>((ref, address) {
  return ref.read(nftRepositoryProvider).getNft(address);
});

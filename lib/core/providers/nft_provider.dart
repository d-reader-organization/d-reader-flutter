import 'package:d_reader_flutter/core/models/nft.dart';
import 'package:d_reader_flutter/core/repositories/nft/repository_impl.dart';
import 'package:d_reader_flutter/ioc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final nftProvider =
    FutureProvider.autoDispose.family<NftModel?, String>((ref, address) {
  return IoCContainer.resolveContainer<NftRepositoryImpl>().getNft(address);
});

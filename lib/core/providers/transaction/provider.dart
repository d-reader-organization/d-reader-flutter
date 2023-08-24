import 'package:d_reader_flutter/core/providers/dio/dio_provider.dart';
import 'package:d_reader_flutter/core/repositories/transaction/repository_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final transactionRepositoryProvider =
    Provider<TransactionRepositoryImpl>((ref) {
  return TransactionRepositoryImpl(client: ref.watch(dioProvider));
});

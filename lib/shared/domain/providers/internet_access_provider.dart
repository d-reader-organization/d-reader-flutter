import 'package:d_reader_flutter/shared/domain/providers/dio_network_service_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final internetAccessProvider = FutureProvider.autoDispose<bool>((ref) async {
  final networkService = ref.read(networkServiceProvider);
  final response = await networkService.get('https://google.com');
  return response.fold((exception) => false, (result) {
    return result.statusCode == 200;
  });
});

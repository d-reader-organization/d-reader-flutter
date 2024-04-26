import 'package:d_reader_flutter/features/settings/domain/models/spl_token.dart';
import 'package:d_reader_flutter/features/settings/domain/providers/settings_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final splTokensProvider = FutureProvider<List<SplToken>>(
  (ref) async {
    final response = await ref.read(settingsRepositoryProvider).getSplTokens();
    return response.fold((exception) => [], (data) => data);
  },
);

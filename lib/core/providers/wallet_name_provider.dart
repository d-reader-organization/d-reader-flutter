import 'package:hooks_riverpod/hooks_riverpod.dart';

final walletNameProvider = StateProvider.autoDispose<String>((ref) {
  return '';
});

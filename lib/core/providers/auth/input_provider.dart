import 'package:hooks_riverpod/hooks_riverpod.dart';

final obscureTextProvider = StateProvider.autoDispose<bool>((ref) {
  return true;
});

final additionalObscureTextProvider = StateProvider.autoDispose<bool>((ref) {
  return true;
});

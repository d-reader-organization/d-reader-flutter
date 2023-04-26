import 'package:hooks_riverpod/hooks_riverpod.dart';

final hasReferralProvider = StateProvider<bool>((ref) {
  return false;
});

final referrerNameProvider = StateProvider<String>((ref) {
  return '';
});

import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/core/providers/validate_wallet_name.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

String? validateUsername({required String? value, required WidgetRef ref}) {
  if (value == null || value.isEmpty) {
    return "Please enter username.";
  } else if (value.length > 40) {
    return "Must be less than 40 characters.";
  } else if (!usernameRegex.hasMatch(value)) {
    return "Usernames can only contain letters and numbers.";
  }
  final result = ref.watch(isValidWalletNameValue);
  return result ? null : '$value already taken.';
}

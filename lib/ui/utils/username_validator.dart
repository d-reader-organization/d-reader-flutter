import 'package:d_reader_flutter/constants/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

String? validateUsername({required String? value, required WidgetRef ref}) {
  if (value == null || value.isEmpty) {
    return "Please enter username.";
  } else if (value.length > 20) {
    return "Must be less than 20 characters.";
  } else if (value.length < 3) {
    return "Must be greater than 2 characters.";
  } else if (!usernameRegex.hasMatch(value)) {
    return "Usernames can only contain letters and numbers.";
  }
  return null;
}

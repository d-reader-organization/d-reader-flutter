import 'package:d_reader_flutter/constants/constants.dart';

String? usernameValidation(String? username) {
  if (username == null || username.isEmpty) {
    return 'Field cannot be empty.';
  } else if (username.length < 3 || username.length > 20) {
    return 'Username must be 3 to 20 characters long.';
  } else if (!usernameRegex.hasMatch(username)) {
    return 'Letters, numbers, dashes and underscores are allowed.';
  }
  return null;
}

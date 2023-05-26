import 'package:hooks_riverpod/hooks_riverpod.dart';

final isPageByPageReadingMode = StateProvider<bool>(
  (ref) {
    return false;
  },
);

import 'package:hooks_riverpod/hooks_riverpod.dart';

final expandedCandyMachineGroup = StateProvider<String>((ref) {
  return 'none';
});

final activeMintPrice = StateProvider<int>((ref) {
  return 0;
});

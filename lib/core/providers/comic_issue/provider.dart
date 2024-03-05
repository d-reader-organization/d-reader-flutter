import 'package:d_reader_flutter/features/candy_machine/domain/models/candy_machine_group.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final expandedCandyMachineGroup = StateProvider<String>((ref) {
  return 'none';
});

final activeCandyMachineGroup = StateProvider<CandyMachineGroupModel?>((ref) {
  return null;
});

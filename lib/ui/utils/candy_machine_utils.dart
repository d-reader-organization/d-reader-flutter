import 'package:d_reader_flutter/core/models/candy_machine_group.dart';
import 'package:collection/collection.dart';

CandyMachineGroupModel? getActiveGroup(List<CandyMachineGroupModel> groups) {
  final currentDate = DateTime.now();
  return groups.firstWhereOrNull(
    (group) {
      final isStartDateLessOrEqualThanCurrent = group.startDate != null &&
          (group.startDate!.isBefore(currentDate) ||
              group.startDate!.isAtSameMomentAs(currentDate));
      final isEndDateBiggerThanCurrent =
          group.endDate != null && currentDate.isBefore(group.endDate!);
      return isStartDateLessOrEqualThanCurrent && isEndDateBiggerThanCurrent;
    },
  );
}

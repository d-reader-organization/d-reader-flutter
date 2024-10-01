import 'package:d_reader_flutter/features/candy_machine/domain/models/candy_machine_coupon.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'candy_machine_data.freezed.dart';

@freezed
sealed class CandyMachineData with _$CandyMachineData {
  const factory CandyMachineData({
    CandyMachineCoupon? selectedCoupon,
    CouponCurrencySetting? selectedCurrency,
    @Default(1) int numberOfItems,
  }) = _CandyMachineData;
}

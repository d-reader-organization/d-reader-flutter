import 'package:d_reader_flutter/features/candy_machine/domain/models/candy_machine_coupon.dart';
import 'package:d_reader_flutter/features/candy_machine/presentations/state/candy_machine_data.dart';
import 'package:d_reader_flutter/shared/utils/extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'candy_machine_notifier.g.dart';

@riverpod
class CandyMachineNotifier extends _$CandyMachineNotifier {
  @override
  CandyMachineData build() {
    return CandyMachineData();
  }

  void updateSelectedCoupon(CandyMachineCoupon selectedCoupon) {
    state = state.copyWith(selectedCoupon: selectedCoupon);
  }

  void updateSelectedCurrency(CouponCurrencySetting selectedCurrency) {
    state = state.copyWith(selectedCurrency: selectedCurrency);
  }

  void updateNumberOfItems(int numberOfItems) {
    state = state.copyWith(numberOfItems: numberOfItems);
  }

  int getMintPrice() {
    final selectedCoupon = state.selectedCoupon;
    final selectedCurrency = state.selectedCurrency;
    return (selectedCoupon?.prices.firstWhereOrNull((price) {
              return price.splTokenAddress == selectedCurrency?.splTokenAddress;
            })?.mintPrice ??
            0) *
        state.numberOfItems;
  }
}

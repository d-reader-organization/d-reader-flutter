import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/features/candy_machine/domain/models/candy_machine_coupon.dart';

class CandyMachineModel {
  String address;
  int supply, itemsMinted;
  List<CandyMachineCoupon> coupons;

  CandyMachineModel({
    required this.address,
    required this.supply,
    required this.itemsMinted,
    required this.coupons,
  });

  factory CandyMachineModel.fromJson(json) {
    return CandyMachineModel(
      address: json['address'],
      supply: json['supply'],
      itemsMinted: json['itemsMinted'] ?? 0,
      coupons: json['coupons'] != null
          ? List<CandyMachineCoupon>.from(
              json['coupons'].map(
                (item) => CandyMachineCoupon.fromJson(
                  item,
                ),
              ),
            )
              .where((coupon) =>
                  coupon.type != CouponType.publicUser.getString() &&
                  coupon.name != dAuthCouponName)
              .toList()
          : [],
    );
  }
}

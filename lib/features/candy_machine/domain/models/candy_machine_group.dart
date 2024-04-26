import 'package:d_reader_flutter/features/user/domain/models/user_group.dart';
import 'package:d_reader_flutter/features/wallet/domain/models/wallet_group.dart';

class CandyMachineGroupModel {
  final int itemsMinted, mintLimit, mintPrice, supply;
  final String label, displayLabel, splTokenAddress;
  final DateTime? startDate, endDate;
  final bool isActive;
  final WalletGroupModel? wallet;
  final UserGroupModel? user;

  CandyMachineGroupModel({
    required this.mintPrice,
    required this.itemsMinted,
    required this.mintLimit,
    required this.supply,
    required this.label,
    required this.displayLabel,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.splTokenAddress,
    this.wallet,
    this.user,
  });

  factory CandyMachineGroupModel.fromJson(dynamic json) {
    return CandyMachineGroupModel(
      mintPrice: json['mintPrice'] ?? 0,
      itemsMinted: json['itemsMinted'] ?? 0,
      mintLimit: json['mintLimit'] ?? 0,
      supply: json['supply'] ?? 0,
      label: json['label'],
      displayLabel: json['displayLabel'],
      splTokenAddress: json['splTokenAddress'],
      startDate: json['startDate'] != null
          ? DateTime.parse(
              json['startDate'],
            )
          : null,
      endDate: json['endDate'] != null
          ? DateTime.parse(
              json['endDate'],
            )
          : null,
      isActive: json['isActive'],
      wallet: json['wallet'] != null
          ? WalletGroupModel.fromJson(
              json['wallet'],
            )
          : null,
      user: json['user'] != null ? UserGroupModel.fromJson(json['user']) : null,
    );
  }
}

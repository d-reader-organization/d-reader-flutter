import 'package:d_reader_flutter/core/models/wallet_group.dart';

class CandyMachineGroupModel {
  final double mintPrice;
  final int itemsMinted, mintLimit, supply;
  final String label, displayLabel, splTokenAddress;
  final DateTime? startDate, endDate;
  final bool isActive;
  final WalletGroupModel wallet;

  CandyMachineGroupModel({
    required this.mintPrice,
    required this.itemsMinted,
    required this.mintLimit,
    required this.supply,
    required this.label,
    required this.displayLabel,
    required this.splTokenAddress,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.wallet,
  });

  factory CandyMachineGroupModel.fromJson(dynamic json) {
    return CandyMachineGroupModel(
      mintPrice: double.tryParse('${json['mintPrice']}') ?? 0,
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
      wallet: WalletGroupModel.fromJson(
        json['wallet'],
      ),
    );
  }
}

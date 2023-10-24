import 'package:d_reader_flutter/core/models/candy_machine_group.dart';

class CandyMachineModel {
  String address;
  int supply, itemsMinted;
  List<CandyMachineGroupModel> groups;

  CandyMachineModel({
    required this.address,
    required this.supply,
    required this.itemsMinted,
    required this.groups,
  });

  factory CandyMachineModel.fromJson(json) {
    return CandyMachineModel(
        address: json['address'],
        supply: json['supply'],
        itemsMinted: json['itemsMinted'],
        groups: json['groups'] != null
            ? List.from(
                json['groups'].map(
                  (item) => CandyMachineGroupModel.fromJson(
                    item,
                  ),
                ),
              )
            : []);
  }
}

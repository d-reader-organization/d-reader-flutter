import 'package:d_reader_flutter/constants/constants.dart';
import 'package:hive/hive.dart';

class LocalStore {
  static Box get instance => Hive.box(localStoreName);

  init() async {
    await Hive.openBox(localStoreName);
  }
}

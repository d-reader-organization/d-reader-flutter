import 'package:d_reader_flutter/config/config.dart';
import 'package:hive/hive.dart';

class LocalStore {
  static Box get instance => Hive.box(Config.localStoreName);

  init() async {
    await Hive.openBox(Config.localStoreName);
  }
}

import 'package:d_reader_flutter/core/services/api_service.dart';
import 'package:kiwi/kiwi.dart';

abstract class IoCContainer {
  static void register() {
    KiwiContainer container = KiwiContainer();
    container.registerSingleton((container) => ApiService());
  }

  static T resolveContainer<T>() {
    return KiwiContainer().resolve<T>();
  }
}

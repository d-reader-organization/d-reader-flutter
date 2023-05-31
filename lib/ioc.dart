import 'package:d_reader_flutter/core/repositories/auth/auth_repository_impl.dart';
import 'package:d_reader_flutter/core/repositories/creator/creator_repository_impl.dart';
import 'package:d_reader_flutter/core/repositories/nft/repository_impl.dart';
import 'package:d_reader_flutter/core/repositories/wallet/repository_impl.dart';
import 'package:d_reader_flutter/core/services/api_service.dart';
import 'package:kiwi/kiwi.dart';

abstract class IoCContainer {
  static void register() {
    KiwiContainer container = KiwiContainer();
    container.registerSingleton((container) => AuthRepositoryImpl());
    container.registerSingleton((container) => CreatorRepositoryImpl());
    container.registerSingleton((container) => ApiService());
    container.registerSingleton((container) => WalletRepositoryImpl());
    container.registerSingleton((container) => NftRepositoryImpl());
  }

  static T resolveContainer<T>() {
    return KiwiContainer().resolve<T>();
  }
}

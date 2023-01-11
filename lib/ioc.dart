import 'package:d_reader_flutter/core/repositories/auth/auth_repository_impl.dart';
import 'package:d_reader_flutter/core/repositories/carousel/carousel_repository_impl.dart';
import 'package:d_reader_flutter/core/repositories/comic/comic_repository_impl.dart';
import 'package:d_reader_flutter/core/repositories/comic_issues/comic_issue_repository_impl.dart';
import 'package:d_reader_flutter/core/repositories/creator/creator_repository_impl.dart';
import 'package:d_reader_flutter/core/repositories/genre/genre_repository_impl.dart';
import 'package:d_reader_flutter/core/repositories/playground/playground_repository_impl.dart';
import 'package:d_reader_flutter/core/services/api_service.dart';
import 'package:kiwi/kiwi.dart';

abstract class IoCContainer {
  static void register() {
    KiwiContainer container = KiwiContainer();
    container.registerSingleton((container) => AuthRepositoryImpl());
    container.registerSingleton((container) => CarouselRepositoryImpl());
    container.registerSingleton((container) => ComicRepositoryImpl());
    container.registerSingleton((container) => ComicIssueRepositoryImpl());
    container.registerSingleton((container) => CreatorRepositoryImpl());
    container.registerSingleton((container) => GenreRepositoryImpl());
    container.registerSingleton((container) => PlaygroundRepositoryImpl());
    container.registerSingleton((container) => ApiService());
  }

  static T resolveContainer<T>() {
    return KiwiContainer().resolve<T>();
  }
}

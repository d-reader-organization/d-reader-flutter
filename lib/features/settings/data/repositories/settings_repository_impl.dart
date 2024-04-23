import 'package:d_reader_flutter/features/settings/data/datasource/settings_remote_source.dart';
import 'package:d_reader_flutter/features/settings/domain/models/spl_token.dart';
import 'package:d_reader_flutter/features/settings/domain/repositories/settings_repository.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteSource dataSource;

  SettingsRepositoryImpl(this.dataSource);

  @override
  Future<Either<AppException, List<SplToken>>> getSplTokens() {
    return dataSource.getSplTokens();
  }
}

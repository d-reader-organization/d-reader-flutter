import 'dart:io' show Platform;
import 'package:d_reader_flutter/shared/data/local/local_store.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_providers.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:upgrader/upgrader.dart';
part 'check_for_app_version_provider.g.dart';

const String appCheckKey = 'app_check_date';
const String sagaModel = 'Saga';

@riverpod
Future<bool> shouldTriggerAppVersionUpdate(Ref ref) async {
  final localStore = LocalStore.instance;
  final DateTime? lastCheck = localStore.get(appCheckKey, defaultValue: null);
  final packageInfo = await ref.read(packageInfoProvider.future);
  final bool ignoreCheck = lastCheck != null &&
      !lastCheck.isBefore(DateTime.now().subtract(const Duration(days: 2)));
  if (ignoreCheck) {
    return false;
  }
  localStore.put(
    appCheckKey,
    DateTime.now(),
  );

  final storeVersion = await getStoreVersion(packageInfo.packageName);
  if (storeVersion == null) {
    return false;
  }

  return _areDifferentVersions(
    currentVersion: packageInfo.version,
    storeVersion: storeVersion,
  );
}

bool _areDifferentVersions({
  required String currentVersion,
  required String storeVersion,
}) {
  final currentSplitted = currentVersion.split('.');
  final storeSplitted = storeVersion.split('.');
  bool areDifferent = false;
  for (var i = 0; i < storeSplitted.length; ++i) {
    final currentParsed = int.parse(currentSplitted[i]);
    final storeParsed = int.parse(storeSplitted[i]);
    if (currentParsed != storeParsed) {
      areDifferent = true;
      break;
    }
  }
  return areDifferent;
}

Future<String?> getStoreVersion(String myAppBundleId) async {
  String? storeVersion;
  final deviceModel =
      await DeviceInfoPlugin().deviceInfo.then((value) => value.data['model']);

  if (deviceModel == sagaModel) {
    return null;
  }
  if (Platform.isAndroid) {
    PlayStoreSearchAPI playStoreSearchAPI = PlayStoreSearchAPI();
    final result = await playStoreSearchAPI.lookupById(myAppBundleId);
    if (result != null) storeVersion = playStoreSearchAPI.version(result);
  } else if (Platform.isIOS) {
    ITunesSearchAPI iTunesSearchAPI = ITunesSearchAPI();
    Map<dynamic, dynamic>? result =
        await iTunesSearchAPI.lookupByBundleId(myAppBundleId);
    if (result != null) storeVersion = iTunesSearchAPI.version(result);
  } else {
    storeVersion = null;
  }
  return storeVersion;
}

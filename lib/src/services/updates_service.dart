import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

class UpdateService {
  Future<Version> getLatestVersion() async {
    final versionData = await GetIt.I<FirebaseDatabase>()
        .ref()
        .child('config')
        .child('latest_version')
        .once();
    return Version.parse(versionData.snapshot.value?.toString() ?? '0.0.0.0');
  }

  Future<Version> getLatestDeprecatedVersion() async {
    final versionData = await GetIt.I<FirebaseDatabase>()
        .ref()
        .child('config')
        .child('deprecated_from')
        .once();
    return Version.parse(versionData.snapshot.value?.toString() ?? '0.0.0.0');
  }

  Future<Version> getCurrentVersion() async {
    return Version.parse((await PackageInfo.fromPlatform()).version);
  }

  Future<bool> isUpToDate() async {
    return await getCurrentVersion() >= await getLatestVersion();
  }

  Future<bool> currentIsDeprecated() async {
    return await getCurrentVersion() <= await getLatestDeprecatedVersion();
  }
}

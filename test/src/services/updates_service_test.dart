import 'package:churchdata_core/src/services/updates_service.dart';
import 'package:churchdata_core_mocks/churchdata_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group(
    'UpdatesService tests ->',
    () {
      setUp(
        () async {
          GetIt.I.pushNewScope(scopeName: 'UpdatesServiceTestsScope');
          registerFirebaseMocks();

          PackageInfo.setMockInitialValues(
            appName: 'churchdata_core',
            packageName: 'churchdata_core',
            version: '0.2.0',
            buildNumber: '1',
            buildSignature: 'buildSignature',
          );
        },
      );

      tearDown(
        () async {
          await GetIt.I.reset();
        },
      );

      test(
        'Latest Version',
        () async {
          await GetIt.I<FirebaseDatabase>()
              .ref()
              .child('config')
              .child('latest_version')
              .set('1.0.0');

          final unit = UpdateService();

          expect(await unit.getLatestVersion(), Version(1, 0, 0));
          expect(await unit.isUpToDate(), isFalse);
        },
      );

      test(
        'Deprecated Version',
        () async {
          await GetIt.I<FirebaseDatabase>()
              .ref()
              .child('config')
              .child('deprecated_from')
              .set('1.0.0');

          final unit = UpdateService();

          expect(await unit.getLatestDeprecatedVersion(), Version(1, 0, 0));
          expect(await unit.currentIsDeprecated(), isTrue);
        },
      );

      test(
        'Current Version',
        () async {
          await GetIt.I<FirebaseDatabase>()
              .ref()
              .child('config')
              .child('deprecated_from')
              .set('1.0.0');

          final unit = UpdateService();

          expect(await unit.getCurrentVersion(), Version(0, 2, 0));
        },
      );
    },
  );
}

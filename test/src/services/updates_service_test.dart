import 'dart:async';

import 'package:churchdata_core/churchdata_core.dart';
import 'package:churchdata_core/src/services/updates_service.dart';
import 'package:churchdata_core_mocks/churchdata_core.dart';
import 'package:churchdata_core_mocks/services/updates_service_test.mocks.dart';
import 'package:churchdata_core_mocks/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

@GenerateMocks([LauncherService])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group(
    'UpdatesService tests: ',
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

          final mockLauncherService = MockLauncherService();
          when(mockLauncherService.launchUrl(captureAny))
              .thenAnswer((_) async => true);
          GetIt.I.registerSingleton<LauncherService>(mockLauncherService);
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
              .child('updates')
              .child('latest_version')
              .set('1.0.0');

          final unit = UpdatesService();

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
              .child('updates')
              .child('deprecated_from')
              .set('1.0.0');

          final unit = UpdatesService();

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
              .child('updates')
              .child('deprecated_from')
              .set('1.0.0');

          final unit = UpdatesService();

          expect(await unit.getCurrentVersion(), Version(0, 2, 0));
        },
      );

      final updateDialogVariant = UpdateDialogVariant();
      testWidgets(
        'Show Update Dialog',
        (tester) async {
          await GetIt.I<FirebaseDatabase>()
              .ref()
              .child('config')
              .child('updates')
              .child('download_link')
              .set('https://example.com/downloadLink');

          await GetIt.I<FirebaseDatabase>()
              .ref()
              .child('config')
              .child('updates')
              .child('release_notes')
              .set('https://example.com/releaseNotesLink');

          final navigator = GlobalKey<NavigatorState>();

          await tester.pumpWidget(
              wrapWithMaterialApp(const Scaffold(), navigatorKey: navigator));
          await tester.pumpAndSettle();

          final unit = UpdatesService();

          unawaited(unit.showUpdateDialog(navigator.currentContext!,
              content: const Text('Content')));
          await tester.pumpAndSettle();

          expect(find.byType(AlertDialog), findsOneWidget);
          expect(find.text('أخبار سارة! يوجد تحديث جديد🎉'), findsOneWidget);
          expect(find.text('Content'), findsOneWidget);
          expect(find.widgetWithText(OutlinedButton, 'تحديث'), findsOneWidget);
          expect(find.widgetWithText(TextButton, 'الاطلاع على التغييرات'),
              findsOneWidget);

          await tester
              .tap(find.widgetWithText(TextButton, 'الاطلاع على التغييرات'));

          verify(GetIt.I<LauncherService>()
              .launchUrl(Uri.parse('https://example.com/releaseNotesLink')));

          if (updateDialogVariant.current == VersionMode.supported) {
            unawaited(unit.showUpdateDialog(navigator.currentContext!,
                content: const Text('Content')));
            await tester.pumpAndSettle();
          }

          await tester.tap(find.widgetWithText(OutlinedButton, 'تحديث'));

          verify(GetIt.I<LauncherService>()
              .launchUrl(Uri.parse('https://example.com/downloadLink')));

          await tester.tapAt(const Offset(5, 5));
          await tester.pumpAndSettle();

          expect(
            find.text('أخبار سارة! يوجد تحديث جديد🎉'),
            updateDialogVariant.current == VersionMode.deprecated
                ? findsOneWidget
                : findsNothing,
          );
        },
        variant: updateDialogVariant,
      );
    },
  );
}

class UpdateDialogVariant extends TestVariant<VersionMode> {
  VersionMode? _current;
  VersionMode? get current => _current;

  @override
  String describeValue(VersionMode value) {
    return value.name;
  }

  @override
  Future<VersionMode> setUp(VersionMode value) async {
    if (value == VersionMode.deprecated)
      await GetIt.I<FirebaseDatabase>()
          .ref()
          .child('config')
          .child('updates')
          .child('deprecated_from')
          .set('1.0.0.0');
    else
      await GetIt.I<FirebaseDatabase>()
          .ref()
          .child('config')
          .child('updates')
          .child('deprecated_from')
          .set('0.0.1.0');

    return _current = value;
  }

  @override
  Future<void> tearDown(VersionMode value, covariant Object? memento) async {}

  @override
  Iterable<VersionMode> get values => VersionMode.values;
}

enum VersionMode { supported, deprecated }

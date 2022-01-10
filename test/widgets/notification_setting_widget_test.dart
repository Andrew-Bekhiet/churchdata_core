import 'dart:math';

import 'package:churchdata_core/churchdata_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';

import '../churchdata_core_test.dart';
import '../fakes/fake_cache_repo.dart';
import '../fakes/fake_notifications_repo.dart';
import '../utils.dart';

void main() {
  group(
    'Notification Setting widget tests ->',
    () {
      setUp(
        () async {
          GetIt.I.pushNewScope(scopeName: 'NotificationsTestsScope');
          registerFirebaseMocks();

          GetIt.I.registerSingleton<CacheRepository>(FakeCacheRepo());
          GetIt.I.registerSingleton<NotificationsService>(
              MockNotificationsService());

          await GetIt.I<CacheRepository>()
              .openBox<NotificationSetting>('NotificationsSettings');

          await initializeDateFormatting('ar-EG');
        },
      );

      tearDown(
        () async {
          await GetIt.I.reset();
        },
      );

      testWidgets(
        'Widget structure',
        (tester) async {
          await GetIt.I<CacheRepository>()
              .box<NotificationSetting>('NotificationsSettings')
              .put(
                'Notification',
                const NotificationSetting(
                  20,
                  17,
                  1,
                ),
              );

          final navigator = GlobalKey<NavigatorState>();

          await tester.pumpWidget(
            wrapWithMaterialApp(
              Scaffold(
                body: NotificationSettingWidget(
                  alarmId: 'alarm'.hashCode,
                  hiveKey: 'Notification',
                  label: 'اشعار',
                  notificationCallback: () {},
                ),
              ),
              navigatorKey: navigator,
            ),
          );

          expect(find.text('اشعار'), findsOneWidget);
          expect(find.widgetWithText(TextField, '1'), findsOneWidget);
          expect(find.widgetWithText(DropdownButtonFormField<DateType>, 'يوم'),
              findsOneWidget);
          expect(
            find.widgetWithText(
              TappableFormField<TimeOfDay>,
              DateFormat(
                'h:m a',
                'ar-EG',
              ).format(
                DateTime.now().replaceTimeOfDay(
                  const TimeOfDay(hour: 20, minute: 17),
                ),
              ),
            ),
            findsOneWidget,
          );
        },
      );

      group(
        'Different Intervals',
        () {
          testWidgets(
            'Weeks',
            (tester) async {
              await GetIt.I<CacheRepository>()
                  .box<NotificationSetting>('NotificationsSettings')
                  .put(
                    'Notification',
                    const NotificationSetting(
                      20,
                      17,
                      21,
                    ),
                  );

              final navigator = GlobalKey<NavigatorState>();

              await tester.pumpWidget(
                wrapWithMaterialApp(
                  Scaffold(
                    body: NotificationSettingWidget(
                      alarmId: 'alarm'.hashCode,
                      hiveKey: 'Notification',
                      label: 'اشعار',
                      notificationCallback: () {},
                    ),
                  ),
                  navigatorKey: navigator,
                ),
              );

              expect(find.widgetWithText(TextField, '3'), findsOneWidget);
              expect(
                  find.widgetWithText(
                      DropdownButtonFormField<DateType>, 'أسبوع'),
                  findsOneWidget);
              expect(
                find.widgetWithText(
                  TappableFormField<TimeOfDay>,
                  DateFormat(
                    'h:m a',
                    'ar-EG',
                  ).format(
                    DateTime.now().replaceTimeOfDay(
                      const TimeOfDay(hour: 20, minute: 17),
                    ),
                  ),
                ),
                findsOneWidget,
              );
            },
          );

          testWidgets(
            'Months',
            (tester) async {
              await GetIt.I<CacheRepository>()
                  .box<NotificationSetting>('NotificationsSettings')
                  .put(
                    'Notification',
                    const NotificationSetting(
                      20,
                      16,
                      60,
                    ),
                  );

              final navigator = GlobalKey<NavigatorState>();

              await tester.pumpWidget(
                wrapWithMaterialApp(
                  Scaffold(
                    body: NotificationSettingWidget(
                      alarmId: 'alarm'.hashCode,
                      hiveKey: 'Notification',
                      label: 'اشعار',
                      notificationCallback: () {},
                    ),
                  ),
                  navigatorKey: navigator,
                ),
              );

              expect(find.widgetWithText(TextField, '2'), findsOneWidget);
              expect(
                  find.widgetWithText(DropdownButtonFormField<DateType>, 'شهر'),
                  findsOneWidget);
              expect(
                find.widgetWithText(
                  TappableFormField<TimeOfDay>,
                  DateFormat(
                    'h:m a',
                    'ar-EG',
                  ).format(
                    DateTime.now().replaceTimeOfDay(
                      const TimeOfDay(hour: 20, minute: 16),
                    ),
                  ),
                ),
                findsOneWidget,
              );
            },
          );
        },
      );

      testWidgets(
        'Changing time',
        (tester) async {
          await GetIt.I<CacheRepository>()
              .box<NotificationSetting>('NotificationsSettings')
              .put(
                'Notification',
                const NotificationSetting(
                  20,
                  16,
                  60,
                ),
              );

          final navigator = GlobalKey<NavigatorState>();

          await tester.pumpWidget(
            wrapWithMaterialApp(
              Scaffold(
                body: NotificationSettingWidget(
                  alarmId: 'alarm'.hashCode,
                  hiveKey: 'Notification',
                  label: 'اشعار',
                  notificationCallback: () {},
                ),
              ),
              navigatorKey: navigator,
            ),
          );

          await tester.tap(
            find.widgetWithText(
              TappableFormField<TimeOfDay>,
              DateFormat(
                'h:m a',
                'ar-EG',
              ).format(
                DateTime.now().replaceTimeOfDay(
                  const TimeOfDay(hour: 20, minute: 16),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.byType(TimePickerDialog), findsOneWidget);

          //What a horrible way to test a TimePicker Dialog!!
          //

          final finder = find
              .ancestor(
                  of: find.byKey(const ValueKey('time-picker-dial')),
                  matching: find.byType(Listener))
              .first;

          const hoursAngleDeg = 10 * 360 / 12;
          const minutesAngleDeg = 50 * 360 / 60;
          final center = tester.getCenter(finder);
          final topRight = tester.getTopRight(finder);
          final radius = topRight.dx - center.dx;
          final tapAtHours = Offset(
              center.dx + radius * cos((hoursAngleDeg - 90) * pi / 180),
              center.dy + radius * sin((hoursAngleDeg - 90) * pi / 180));
          final tapAtMinutes = Offset(
              center.dx + radius * cos((minutesAngleDeg - 90) * pi / 180),
              center.dy + radius * sin((minutesAngleDeg - 90) * pi / 180));
          await tester.pumpAndSettle();
          await tester.tapAt(tapAtHours);
          await tester.pumpAndSettle();
          await tester.tapAt(tapAtMinutes);
          await tester.pumpAndSettle();

          //
          await tester.tap(
            find.text(MaterialLocalizations.of(navigator.currentContext!)
                .okButtonLabel),
          );
          await tester.pumpAndSettle();

          expect(
            find.widgetWithText(
              TappableFormField<TimeOfDay>,
              DateFormat(
                'h:m a',
                'ar-EG',
              ).format(
                DateTime.now().replaceTimeOfDay(
                  const TimeOfDay(hour: 22, minute: 50),
                ),
              ),
            ),
            findsOneWidget,
          );
        },
      );
      testWidgets(
        'Saving',
        (tester) async {
          GetIt.I.pushNewScope(
            scopeName: 'MockNotificationsService',
            init: (i) => i.registerSingleton<NotificationsService>(
              MockNotificationsService(),
            ),
          );

          when((GetIt.I<NotificationsService>() as MockNotificationsService)
              .schedulePeriodic(
            any,
            any,
            any,
            exact: true,
            startAt: anyNamed('startAt'),
            rescheduleOnReboot: true,
          )).thenAnswer((_) async => true);

          await GetIt.I<CacheRepository>()
              .box<NotificationSetting>('NotificationsSettings')
              .put(
                'Notification',
                const NotificationSetting(
                  20,
                  16,
                  60,
                ),
              );

          final navigator = GlobalKey<NavigatorState>();
          final form = GlobalKey<FormState>();

          await tester.pumpWidget(
            wrapWithMaterialApp(
              Scaffold(
                body: Form(
                  key: form,
                  child: NotificationSettingWidget(
                    alarmId: 'alarm'.hashCode,
                    hiveKey: 'Notification',
                    label: 'اشعار',
                    notificationCallback: () {},
                  ),
                ),
              ),
              navigatorKey: navigator,
            ),
          );

          await tester.tap(
            find.widgetWithText(
              TappableFormField<TimeOfDay>,
              DateFormat(
                'h:m a',
                'ar-EG',
              ).format(
                DateTime.now().replaceTimeOfDay(
                  const TimeOfDay(hour: 20, minute: 16),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.byType(TimePickerDialog), findsOneWidget);

          //What a horrible way to test a TimePicker Dialog!!
          //

          final finder = find
              .ancestor(
                  of: find.byKey(const ValueKey('time-picker-dial')),
                  matching: find.byType(Listener))
              .first;

          const hoursAngleDeg = 10 * 360 / 12;
          const minutesAngleDeg = 50 * 360 / 60;
          final center = tester.getCenter(finder);
          final topRight = tester.getTopRight(finder);
          final radius = topRight.dx - center.dx;
          final tapAtHours = Offset(
              center.dx + radius * cos((hoursAngleDeg - 90) * pi / 180),
              center.dy + radius * sin((hoursAngleDeg - 90) * pi / 180));
          final tapAtMinutes = Offset(
              center.dx + radius * cos((minutesAngleDeg - 90) * pi / 180),
              center.dy + radius * sin((minutesAngleDeg - 90) * pi / 180));
          await tester.pumpAndSettle();
          await tester.tapAt(tapAtHours);
          await tester.pumpAndSettle();
          await tester.tapAt(tapAtMinutes);
          await tester.pumpAndSettle();

          //
          await tester.tap(
            find.text(MaterialLocalizations.of(navigator.currentContext!)
                .okButtonLabel),
          );
          await tester.pumpAndSettle();

          form.currentState!.save();
          await tester.pumpAndSettle();

          expect(
            GetIt.I<CacheRepository>()
                .box('NotificationsSettings')
                .get('Notification'),
            const NotificationSetting(22, 50, 60),
          );

          verify((GetIt.I<NotificationsService>() as MockNotificationsService)
              .schedulePeriodic(
            const Duration(days: 60),
            'alarm'.hashCode,
            any,
            exact: true,
            startAt: anyNamed('startAt'),
            rescheduleOnReboot: true,
          ));
        },
      );
    },
  );
}

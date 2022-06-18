import 'package:churchdata_core/churchdata_core.dart';
import 'package:churchdata_core_mocks/churchdata_core.dart';
import 'package:churchdata_core_mocks/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  group(
    'Copiable Property widget tests ->',
    () {
      group(
        'Widget structure ->',
        () {
          testWidgets(
            'Normal',
            (tester) async {
              final navigator = GlobalKey<NavigatorState>();

              await tester.pumpWidget(
                wrapWithMaterialApp(
                  const Scaffold(
                    body: CopiablePropertyWidget(
                      'propName',
                      'value',
                    ),
                  ),
                  navigatorKey: navigator,
                ),
              );

              expect(find.widgetWithText(ListTile, 'propName'), findsOneWidget);
              expect(find.widgetWithText(ListTile, 'value'), findsOneWidget);
              expect(
                  find.widgetWithIcon(IconButton, Icons.copy), findsOneWidget);
            },
          );

          testWidgets(
            'With Additional Options',
            (tester) async {
              final navigator = GlobalKey<NavigatorState>();

              await tester.pumpWidget(
                wrapWithMaterialApp(
                  const Scaffold(
                    body: CopiablePropertyWidget(
                      'propName',
                      'value',
                      additionalOptions: [
                        SizedBox(
                          width: 10,
                          child: Placeholder(
                            key: Key('option'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  navigatorKey: navigator,
                ),
              );

              expect(find.widgetWithText(ListTile, 'propName'), findsOneWidget);
              expect(find.widgetWithText(ListTile, 'value'), findsOneWidget);
              expect(
                  find.widgetWithIcon(IconButton, Icons.copy), findsOneWidget);
              expect(find.byKey(const Key('option')), findsOneWidget);
            },
          );
        },
      );

      testWidgets(
        'Empty data',
        (tester) async {
          final navigator = GlobalKey<NavigatorState>();

          await tester.pumpWidget(
            wrapWithMaterialApp(
              const Scaffold(
                body: CopiablePropertyWidget(
                  'propName',
                  null,
                ),
              ),
              navigatorKey: navigator,
            ),
          );

          expect(find.widgetWithText(ListTile, 'propName'), findsOneWidget);
          expect(find.widgetWithIcon(ListTile, Icons.warning), findsOneWidget);
          expect(find.widgetWithIcon(IconButton, Icons.copy), findsNothing);
        },
      );

      testWidgets(
        'Empty data suppressed',
        (tester) async {
          final navigator = GlobalKey<NavigatorState>();

          await tester.pumpWidget(
            wrapWithMaterialApp(
              const Scaffold(
                body: CopiablePropertyWidget(
                  'propName',
                  null,
                  showErrorIfEmpty: false,
                ),
              ),
              navigatorKey: navigator,
            ),
          );

          expect(find.widgetWithText(ListTile, 'propName'), findsOneWidget);
          expect(find.widgetWithIcon(ListTile, Icons.warning), findsNothing);
          expect(find.widgetWithIcon(IconButton, Icons.copy), findsNothing);
        },
      );
    },
  );
  group(
    'PhoneNumber Property widget tests ->',
    () {
      setUp(
        () async {
          GetIt.I.pushNewScope(scopeName: 'NotificationsTestsScope');
          registerFirebaseMocks();
        },
      );

      tearDown(
        () async {
          await GetIt.I.reset();
        },
      );

      group(
        'Widget structure ->',
        () {
          testWidgets(
            'Normal',
            (tester) async {
              final navigator = GlobalKey<NavigatorState>();

              await tester.pumpWidget(
                wrapWithMaterialApp(
                  Scaffold(
                    body: PhoneNumberProperty(
                        'propName', 'value', (_) {}, (_) {}),
                  ),
                  navigatorKey: navigator,
                ),
              );

              await tester.pumpAndSettle();

              expect(find.widgetWithText(ListTile, 'propName'), findsOneWidget);
              expect(find.widgetWithText(ListTile, 'value'), findsOneWidget);
              expect(
                  find.widgetWithIcon(IconButton, Icons.phone), findsOneWidget);
              expect(find.widgetWithIcon(IconButton, Icons.person_add_alt),
                  findsOneWidget);
              expect(find.widgetWithIcon(IconButton, Icons.more_vert),
                  findsOneWidget);
            },
          );
        },
      );
      testWidgets(
        'Empty data',
        (tester) async {
          final navigator = GlobalKey<NavigatorState>();

          await tester.pumpWidget(
            wrapWithMaterialApp(
              Scaffold(
                body: PhoneNumberProperty('propName', null, (_) {}, (_) {}),
              ),
              navigatorKey: navigator,
            ),
          );

          await tester.pumpAndSettle();

          expect(find.widgetWithText(ListTile, 'propName'), findsOneWidget);
          expect(find.widgetWithIcon(ListTile, Icons.warning), findsOneWidget);
          expect(find.widgetWithIcon(IconButton, Icons.phone), findsNothing);
          expect(find.widgetWithIcon(IconButton, Icons.person_add_alt),
              findsNothing);
          expect(
              find.widgetWithIcon(IconButton, Icons.more_vert), findsNothing);
        },
      );

      testWidgets(
        'Empty data suppressed',
        (tester) async {
          final navigator = GlobalKey<NavigatorState>();

          await tester.pumpWidget(
            wrapWithMaterialApp(
              Scaffold(
                body: PhoneNumberProperty(
                  'propName',
                  null,
                  (_) {},
                  (_) {},
                  showErrorIfEmpty: false,
                ),
              ),
              navigatorKey: navigator,
            ),
          );

          await tester.pumpAndSettle();

          expect(find.widgetWithText(ListTile, 'propName'), findsOneWidget);
          expect(find.widgetWithIcon(ListTile, Icons.warning), findsNothing);
          expect(find.widgetWithIcon(IconButton, Icons.phone), findsNothing);
          expect(find.widgetWithIcon(IconButton, Icons.person_add_alt),
              findsNothing);
          expect(
              find.widgetWithIcon(IconButton, Icons.more_vert), findsNothing);
        },
      );
    },
  );
  testWidgets(
    'Functioning',
    (tester) async {
      bool phoneCall = false;
      bool contactAdd = false;
      final navigator = GlobalKey<NavigatorState>();

      await tester.pumpWidget(
        wrapWithMaterialApp(
          Scaffold(
            body: PhoneNumberProperty(
              'propName',
              'value',
              (_) => phoneCall = true,
              (_) => contactAdd = true,
            ),
          ),
          navigatorKey: navigator,
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithIcon(IconButton, Icons.phone));
      await tester.tap(find.widgetWithIcon(IconButton, Icons.person_add_alt));

      expect(contactAdd, isTrue);
      expect(phoneCall, isTrue);
    },
  );
}

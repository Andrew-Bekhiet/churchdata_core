import 'dart:async';

import 'package:churchdata_core/churchdata_core.dart';
import 'package:churchdata_core_mocks/churchdata_core.dart';
import 'package:churchdata_core_mocks/fakes/fake_cache_repo.dart';
import 'package:churchdata_core_mocks/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  group(
    'DataObjectWidget tests ->',
    () {
      setUp(
        () async {
          GetIt.I.pushNewScope(scopeName: 'DataObjectWidgetTestsScope');

          registerFirebaseMocks();

          GetIt.I.registerSingleton(DatabaseRepository());
          GetIt.I.registerSingleton<CacheRepository>(FakeCacheRepo());
        },
      );

      tearDown(
        () async {
          await GetIt.I.reset();
        },
      );

      group(
        'Widget structure',
        () {
          testWidgets(
            'Widget structure',
            (tester) async {
              final navigator = GlobalKey<NavigatorState>();

              await tester.pumpWidget(
                wrapWithMaterialApp(
                  Scaffold(
                    body: Container(),
                  ),
                  navigatorKey: navigator,
                ),
              );

              final person = PersonBase(
                ref: GetIt.I<DatabaseRepository>()
                    .collection('Persons')
                    .doc('id'),
                name: 'person',
              );

              GetIt.I.registerSingleton(
                DefaultViewableObjectTapHandler(navigator),
              );

              unawaited(
                navigator.currentState!.push(
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      body: ViewableObjectWidget<PersonBase>(person),
                    ),
                  ),
                ),
              );

              await tester.pumpAndSettle();

              expect(find.byType(Card), findsOneWidget);
              expect(
                find.descendant(
                  of: find.byType(Card),
                  matching: find.byType(ListTile),
                ),
                findsOneWidget,
              );

              expect(
                find.descendant(
                  of: find.byType(ListTile),
                  matching: find.text(person.name),
                ),
                findsOneWidget,
              );

              expect(
                find.descendant(
                  of: find.byType(ListTile),
                  matching: find.byType(PhotoObjectWidget),
                ),
                findsOneWidget,
              );
            },
          );
          testWidgets(
            'Custom parameters',
            (tester) async {
              final navigator = GlobalKey<NavigatorState>();

              await tester.pumpWidget(
                wrapWithMaterialApp(
                  Scaffold(
                    body: Container(),
                  ),
                  navigatorKey: navigator,
                ),
              );

              final person = PersonBase(
                ref: GetIt.I<DatabaseRepository>()
                    .collection('Persons')
                    .doc('id'),
                name: 'person',
              );

              GetIt.I.registerSingleton(
                DefaultViewableObjectTapHandler(navigator),
              );

              unawaited(
                navigator.currentState!.push(
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      body: ViewableObjectWidget<PersonBase>(
                        person,
                        trailing: const SizedBox(
                          width: 56,
                          height: 56,
                          child: Placeholder(
                            key: Key('trailing'),
                          ),
                        ),
                        photo: const SizedBox(
                          width: 56,
                          height: 56,
                          child: Placeholder(key: Key('photo')),
                        ),
                        subtitle: const Text('subtitle'),
                        title: const Text('title'),
                      ),
                    ),
                  ),
                ),
              );

              await tester.pumpAndSettle();

              expect(find.text(person.name), findsNothing);

              expect(find.byType(PhotoObjectWidget), findsNothing);
              expect(find.byType(Card), findsOneWidget);
              expect(
                find.descendant(
                  of: find.byType(Card),
                  matching: find.byType(ListTile),
                ),
                findsOneWidget,
              );
              expect(
                find.descendant(
                  of: find.byType(ListTile),
                  matching: find.byKey(const Key('photo')),
                ),
                findsOneWidget,
              );
              expect(
                find.descendant(
                  of: find.byType(ListTile),
                  matching: find.byKey(const Key('trailing')),
                ),
                findsOneWidget,
              );
              expect(
                find.descendant(
                  of: find.byType(ListTile),
                  matching: find.text('title'),
                ),
                findsOneWidget,
              );
              expect(
                find.descendant(
                  of: find.byType(ListTile),
                  matching: find.text('subtitle'),
                ),
                findsOneWidget,
              );
            },
          );
        },
      );

      testWidgets(
        'Behavior',
        (tester) async {
          bool longPressed = false;
          final navigator = GlobalKey<NavigatorState>();

          await tester.pumpWidget(
            wrapWithMaterialApp(
              Scaffold(
                body: Container(),
              ),
              routes: {
                'PersonInfo': (context) => const Scaffold(
                      body: Text('PersonInfo'),
                    ),
              },
              navigatorKey: navigator,
            ),
          );

          final person = PersonBase(
            ref: GetIt.I<DatabaseRepository>().collection('Persons').doc('id'),
            name: 'person',
          );

          GetIt.I.registerSingleton(
            DefaultViewableObjectTapHandler(navigator),
          );

          unawaited(
            navigator.currentState!.push(
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  body: ViewableObjectWidget<PersonBase>(
                    person,
                    onLongPress: () => longPressed = true,
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          await tester.tap(find.byType(ViewableObjectWidget<PersonBase>));
          await tester.pumpAndSettle();

          expect(find.text('PersonInfo'), findsOneWidget);
          navigator.currentState!.pop();
          await tester.pumpAndSettle();

          await tester.longPress(find.byType(ViewableObjectWidget<PersonBase>));

          expect(longPressed, isTrue);
        },
      );
    },
  );
}

import 'dart:async';

import 'package:churchdata_core/churchdata_core.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import '../churchdata_core.dart';
import '../churchdata_core.mocks.dart';
import '../fakes/fake_functions_repo.dart';
import '../utils.dart';

void main() {
  group(
    'Database repository tests ->',
    () {
      setUp(
        () async {
          GetIt.I.pushNewScope(scopeName: 'DatabaseTestsScope');
          registerFirebaseMocks();

          GetIt.I.registerSingleton(DatabaseRepository());
          GetIt.I.registerSingleton<FunctionsService>(FunctionsService());
        },
      );

      tearDown(() async {
        await GetIt.I.reset();
      });

      group(
        'Persons Stream ->',
        () {
          test(
            'Default behavior',
            () async {
              final person = PersonBase(
                ref: GetIt.I<DatabaseRepository>().doc('Persons/person'),
                name: 'person',
              );
              await person.set();

              await expectLater(
                GetIt.I<DatabaseRepository>().getPersonsStream(),
                emits([person]),
              );
            },
            timeout: const Timeout(Duration(seconds: 15)),
          );

          test(
            'Query Completer',
            () async {
              final person = PersonBase(
                ref: GetIt.I<DatabaseRepository>().doc('Persons/person'),
                name: 'person',
              );
              await person.set();

              await expectLater(
                GetIt.I<DatabaseRepository>().getPersonsStream(
                  orderBy: 'Field',
                  descending: true,
                  queryCompleter: (query, f, d) {
                    // expect(
                    //   query,
                    //   GetIt.I<DatabaseRepo>().collection('Persons'),
                    // );
                    expect(f, 'Field');
                    expect(d, isTrue);
                    return query.where('Name', isEqualTo: 'non existent');
                  },
                ),
                emits([]),
              );
            },
            timeout: const Timeout(Duration(seconds: 15)),
          );
        },
      );

      test(
        'Person from id',
        () async {
          final person = PersonBase(
            ref: GetIt.I<DatabaseRepository>().doc('Persons/Id'),
            name: 'some person',
          );
          await person.set();

          expect(
            await GetIt.I<DatabaseRepository>().getPerson(person.id),
            person,
          );

          expect(
            await GetIt.I<DatabaseRepository>().getPerson('anotherId'),
            isNull,
          );
        },
      );

      test(
        'UserData from UID',
        () async {
          final person = PersonBase(
            ref:
                GetIt.I<DatabaseRepository>().doc('Persons/personWithUserData'),
            name: 'some user',
          );
          await person.ref.set({...person.toJson(), 'UID': 'userId234'});

          expect(
            await GetIt.I<DatabaseRepository>().getUserData('userId234'),
            person,
          );

          expect(
            await GetIt.I<DatabaseRepository>().getUserData('userId23'),
            isNull,
          );
        },
      );

      group(
        'Object From Link ->',
        () {
          test(
            'Invalid links',
            () async {
              expect(
                () async => GetIt.I<DatabaseRepository>().getObjectFromLink(
                  Uri.https(
                    'churchdata.page.link',
                    'PersonInfo',
                    {'Id': null},
                  ),
                ),
                throwsException,
              );

              expect(
                () => GetIt.I<DatabaseRepository>().getObjectFromLink(
                  Uri.https(
                    'churchdata.page.link',
                    'UserInfo',
                    {'UID': null},
                  ),
                ),
                throwsException,
              );
            },
          );

          test(
            'View Person',
            () async {
              final person = PersonBase(
                ref: GetIt.I<DatabaseRepository>().doc('Persons/person'),
                name: 'person',
              );
              await person.set();

              expect(
                await GetIt.I<DatabaseRepository>().getObjectFromLink(
                  Uri.https(
                    'churchdata.page.link',
                    'PersonInfo',
                    {'Id': 'person'},
                  ),
                ),
                person,
              );
            },
          );

          test(
            'View User',
            () async {
              final person = PersonBase(
                ref: GetIt.I<DatabaseRepository>()
                    .doc('Persons/personWithUserData'),
                name: 'some user',
              );
              await person.ref.set({...person.toJson(), 'UID': 'userId234'});

              expect(
                await GetIt.I<DatabaseRepository>().getObjectFromLink(
                  Uri.https(
                    'churchdata.page.link',
                    'UserInfo',
                    {'UID': 'userId234'},
                  ),
                ),
                person,
              );
            },
          );

          test(
            'View Query',
            () async {
              final query = QueryInfo(
                collection: GetIt.I<DatabaseRepository>().collection('path'),
                fieldPath: 'field',
                operator: '=',
                order: false,
                descending: false,
                orderBy: 'field',
                queryValue: 'SomeString',
              );

              expect(
                await GetIt.I<DatabaseRepository>().getObjectFromLink(
                  Uri.parse('https://churchdata.page.link/viewQuery').replace(
                    queryParameters: query.toJson(),
                  ),
                ),
                query,
              );
            },
          );
        },
      );

      group(
        'Recovering Deleted Document',
        () {
          testWidgets(
            'Dialog structure',
            (tester) async {
              final navigator = GlobalKey<NavigatorState>();

              await tester.pumpWidget(
                wrapWithMaterialApp(
                  const Scaffold(),
                  navigatorKey: navigator,
                ),
              );

              unawaited(GetIt.I<DatabaseRepository>().recoverDocument(
                navigator.currentContext!,
                GetIt.I<DatabaseRepository>().doc('collection/document'),
              ));
              await tester.pumpAndSettle();

              expect(find.text('استرجع ايضا العناصر بداخل هذا العنصر'),
                  findsOneWidget);
              expect(find.text('ابقاء البيانات المحذوفة'), findsOneWidget);
              expect(
                  find.widgetWithText(TextButton, 'استرجاع'), findsOneWidget);
            },
            tags: ['uses_widgets_tester'],
          );
          testWidgets(
            'Behavior',
            (tester) async {
              final fakeHttpsCallable = FakeHttpsCallable();
              when(fakeHttpsCallable(any))
                  .thenAnswer((_) async => FakeHttpsCallableResult());

              when((GetIt.I<FirebaseFunctions>() as MockFirebaseFunctions)
                      .httpsCallable('recoverDoc'))
                  .thenReturn(fakeHttpsCallable);

              final navigator = GlobalKey<NavigatorState>();

              await tester.pumpWidget(
                wrapWithMaterialApp(
                  const Scaffold(),
                  navigatorKey: navigator,
                ),
              );

              unawaited(GetIt.I<DatabaseRepository>().recoverDocument(
                navigator.currentContext!,
                GetIt.I<DatabaseRepository>().doc('collection/document'),
              ));
              await tester.pumpAndSettle();

              await tester.tap(find.widgetWithText(TextButton, 'استرجاع'));

              verify(
                fakeHttpsCallable.call(
                  argThat(
                    predicate<Map>(
                      (p) =>
                          p['deletedPath'] == 'collection/document' &&
                          p['keepBackup'] == true &&
                          p['nested'] == true,
                    ),
                  ),
                ),
              );
            },
            tags: ['uses_widgets_tester'],
          );
        },
      );
    },
  );
}

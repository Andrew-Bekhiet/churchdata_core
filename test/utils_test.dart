import 'package:churchdata_core/churchdata_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import 'churchdata_core.dart';

void main() {
  group(
    'Utillities ->',
    () {
      test(
        'Formatting phone',
        () async {
          const expected1 = '201234567890';
          const expected2 = '401234567890';
          const expected3 = '01234567890';
          const expected4 = '1234567890';

          expect(formatPhone('+201234567890'), expected1);
          expect(formatPhone('201234567890'), expected1);
          expect(formatPhone('01234567890'), expected1);
          expect(formatPhone('1234567890'), expected1);

          expect(formatPhone('+401234567890'), expected2);
          expect(formatPhone('401234567890'), expected2);

          expect(formatPhone('01234567890', false), expected3);
          expect(formatPhone('1234567890', false), expected4);
        },
      );

      test(
        'Rise day calculation',
        () async {
          expect(getRiseDay(2000), DateTime(2000, 4, 30));
          expect(getRiseDay(2019), DateTime(2019, 4, 28));
          expect(getRiseDay(2021), DateTime(2021, 5, 2));
          expect(getRiseDay(2022), DateTime(2022, 4, 24));
          expect(getRiseDay(2023), DateTime(2023, 4, 16));
          expect(getRiseDay(2032), DateTime(2032, 5, 2));
        },
      );

      test(
        'SplitList',
        () async {
          final list = ['foo', 'bar', 'f', 'b', 't'];

          expect(list.split(1), [
            ['foo'],
            ['bar'],
            ['f'],
            ['b'],
            ['t']
          ]);
          expect(list.split(2), [
            ['foo', 'bar'],
            ['f', 'b'],
            ['t']
          ]);
          expect(list.split(3), [
            ['foo', 'bar', 'f'],
            ['b', 't']
          ]);
          expect(list.split(4), [
            ['foo', 'bar', 'f', 'b'],
            ['t']
          ]);
          expect(list.split(5), [
            ['foo', 'bar', 'f', 'b', 't']
          ]);
        },
      );
      test(
        'Stream.next',
        () async {
          final stream = BehaviorSubject.seeded('')..add('Value');

          String? captured = await stream.next;

          expect(stream.value, 'Value');
          expect(captured, 'Value');

          try {
            stream.addError(Exception('message'));
            captured = await stream.next;

            fail('`next` did not thow an error');
          } on Exception catch (e) {
            expect(stream.error, e);
            expect((e as dynamic).message, 'message');
          }

          await stream.close();
        },
      );

      testWidgets(
        'DefaultDataObjectTapHandler',
        (tester) async {
          registerFirebaseMocks();
          GetIt.I.registerSingleton(DatabaseRepository());

          addTearDown(GetIt.I.reset);

          final key = GlobalKey<NavigatorState>();

          await tester.pumpWidget(
            MaterialApp(
              navigatorKey: key,
              routes: {
                '/': (context) => const Scaffold(
                      body: Text('Root'),
                    ),
                'PersonInfo': (context) => Scaffold(
                      body: Text(
                        (ModalRoute.of(context)!.settings.arguments!
                                as PersonBase)
                            .name,
                      ),
                    ),
                'SearchQuery': (context) => Scaffold(
                      body: Text(
                        (ModalRoute.of(context)!.settings.arguments!
                                as QueryInfo)
                            .name,
                      ),
                    ),
              },
            ),
          );

          final unit = DefaultDataObjectTapHandler(key)
            ..onTap(
              PersonBase(
                  ref: GetIt.I<DatabaseRepository>().doc('Persons/person'),
                  name: 'person'),
            );

          await tester.pumpAndSettle();

          expect(find.text('person'), findsOneWidget);

          unit.onTap(
            QueryInfo(
              collection:
                  GetIt.I<DatabaseRepository>().collection('collection'),
              fieldPath: 'f',
              operator: '==',
              order: false,
              queryValue: '',
            ),
          );

          await tester.pumpAndSettle();

          expect(find.text('بحث مفصل'), findsOneWidget);
        },
        tags: ['uses_widgets_tester'],
      );
    },
  );
}

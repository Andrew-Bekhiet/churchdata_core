import 'package:churchdata_core/churchdata_core.dart';
import 'package:churchdata_core_mocks/churchdata_core.dart';
import 'package:churchdata_core_mocks/models/basic_data_object.dart';
import 'package:churchdata_core_mocks/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  group(
    'PaginatableStream<T> tests ->',
    () {
      setUp(
        () async {
          GetIt.I.pushNewScope(scopeName: 'PaginatableStream<T>TestsScope');

          registerFirebaseMocks();

          GetIt.I.registerSingleton(DatabaseRepository());
        },
      );

      tearDown(
        () async {
          await GetIt.I.reset();
        },
      );

      test(
        'loadAll constructor',
        () async {
          final stream = BehaviorSubject<List<BasicDataObject>>();
          final unit = PaginatableStream<BasicDataObject>.loadAll(
            stream: stream,
          );

          addTearDown(unit.dispose);
          addTearDown(stream.close);

          expect(unit.isLoading, true);
          expect(unit.canPaginateBackward, false);
          expect(unit.canPaginateForward, false);
          expect(unit.loadNextPage(), throwsStateError);
          expect(unit.loadPreviousPage(), throwsStateError);

          stream.add(
            [
              BasicDataObject(
                name: '',
                ref: GetIt.I<DatabaseRepository>()
                    .collection('Persons')
                    .doc('asd'),
              ),
            ],
          );

          await Future(() {});

          expect(unit.isLoading, false);
          expect(unit.canPaginateBackward, false);
          expect(unit.canPaginateForward, false);

          expect(unit.loadNextPage(), throwsStateError);
          expect(unit.loadPreviousPage(), throwsStateError);

          expect(unit.loadPage(0), throwsStateError);
        },
      );

      test(
        'Basic pagination',
        () async {
          final randomPersons = (await populateWithRandomPersons(
            GetIt.I<DatabaseRepository>().collection('Persons'),
            25,
          ))
              .sortedBy((p) => p.name);

          final unit = PaginatableStream<BasicDataObject>.query(
            query: GetIt.I<DatabaseRepository>()
                .collection('Persons')
                .orderBy('Name'),
            mapper: BasicDataObject.fromJsonDoc,
            limit: 5,
          );

          addTearDown(unit.dispose);

          expect(
            unit.stream,
            emitsInOrder(
              [
                randomPersons.take(5).toList(),
                randomPersons.take(10).toList(),
                randomPersons.take(15).toList(),
                randomPersons.take(15).toList(),
                randomPersons.take(15).toList(),
                randomPersons.take(20).toList(),
              ],
            ),
          );

          expect(unit.canPaginateBackward, isFalse);
          expect(unit.canPaginateForward, isFalse);
          expect(unit.isLoading, isTrue);

          await unit.stream.next;

          expect(unit.canPaginateBackward, isFalse);
          expect(unit.canPaginateForward, isTrue);
          expect(unit.isLoading, isFalse);

          await unit.loadNextPage();

          expect(unit.canPaginateBackward, isFalse);
          expect(unit.canPaginateForward, isFalse);
          expect(unit.isLoading, isTrue);

          await unit.stream.next;

          expect(unit.canPaginateBackward, isTrue);
          expect(unit.canPaginateForward, isTrue);
          expect(unit.isLoading, isFalse);

          await unit.loadNextPage();
          await unit.stream.next;

          expect(unit.canPaginateBackward, isTrue);
          expect(unit.canPaginateForward, isTrue);
          expect(unit.isLoading, isFalse);

          await unit.loadPreviousPage();

          expect(unit.canPaginateBackward, isFalse);
          expect(unit.canPaginateForward, isTrue);
          expect(unit.isLoading, isTrue);

          await unit.stream.next;

          await unit.loadPreviousPage();

          await unit.stream.next;

          expect(unit.canPaginateBackward, isFalse);
          expect(unit.canPaginateForward, isTrue);
          expect(unit.isLoading, isFalse);

          await unit.loadPage(3);

          await unit.stream.next;

          expect(unit.canPaginateBackward, isTrue);
          expect(unit.canPaginateForward, isTrue);
          expect(unit.isLoading, isFalse);
        },
        timeout: const Timeout(Duration(seconds: 15)),
      );

      test(
        'Changing query on the go',
        () async {
          final randomPersons = (await populateWithRandomPersons(
            GetIt.I<DatabaseRepository>().collection('Persons'),
            25,
          ))
              .sortedBy((p) => p.name);

          final randomPersons2 = (await populateWithRandomPersons(
            GetIt.I<DatabaseRepository>().collection('OtherPersons'),
            25,
          ))
              .sortedBy((p) => p.name);

          final queryController = BehaviorSubject<QueryOfJson>.seeded(
            GetIt.I<DatabaseRepository>().collection('Persons').orderBy('Name'),
          );

          addTearDown(queryController.close);

          final unit = PaginatableStream<BasicDataObject>(
            query: queryController,
            mapper: BasicDataObject.fromJsonDoc,
            limit: 10,
          );

          addTearDown(unit.dispose);

          expect(
            unit.stream,
            emitsInOrder(
              [
                randomPersons.take(10).toList(),
                randomPersons2.take(10).toList(),
              ],
            ),
          );

          await unit.stream.next;

          queryController.add(GetIt.I<DatabaseRepository>()
              .collection('OtherPersons')
              .orderBy('Name'));
        },
        timeout: const Timeout(Duration(seconds: 15)),
      );
    },
  );
}

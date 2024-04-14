import 'package:churchdata_core/churchdata_core.dart';
import 'package:churchdata_core_mocks/churchdata_core.dart';
import 'package:churchdata_core_mocks/models/basic_data_object.dart';
import 'package:churchdata_core_mocks/utils.dart';
import 'package:collection/collection.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mock_data/mock_data.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

import 'list_controller_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<PaginatableStream>(unsupportedMembers: {#mapper})
])
void main() {
  group(
    'ListController<T> tests ->',
    () {
      setUp(
        () async {
          GetIt.I.pushNewScope(scopeName: 'ListController<T>TestsScope');

          registerFirebaseMocks();

          GetIt.I.registerSingleton(DatabaseRepository());
        },
      );

      tearDown(
        () async {
          await GetIt.I.reset();
        },
      );

      group(
        'ObjectsStream',
        () {
          test(
            'Basic',
            () async {
              final unit = ListController<void, BasicDataObject>(
                objectsPaginatableStream: PaginatableStream.query(
                  query: GetIt.I<DatabaseRepository>()
                      .collection('Persons')
                      .orderBy('Name'),
                  mapper: BasicDataObject.fromJsonDoc,
                ),
              );

              addTearDown(unit.dispose);

              final persons = (await populateWithRandomPersons(
                GetIt.I<DatabaseRepository>().collection('Persons'),
                6,
              ))
                  .sortedBy((o) => o.name);

              final person = BasicDataObject(
                name: 'new guy!',
                ref: GetIt.I<DatabaseRepository>().collection('Persons').doc(),
              );
              await person.set();

              expect(
                unit.objectsStream,
                emitsInOrder(
                  [
                    persons,
                    [...persons, person].sortedBy((o) => o.name),
                  ],
                ),
              );
            },
            timeout: const Timeout(Duration(seconds: 15)),
          );

          group(
            'With pagination',
            () {
              test(
                'Basic pagination',
                () async {
                  final unit = ListController<void, BasicDataObject>(
                    objectsPaginatableStream: PaginatableStream.query(
                      query: GetIt.I<DatabaseRepository>()
                          .collection('Persons')
                          .orderBy('Name'),
                      mapper: BasicDataObject.fromJsonDoc,
                      limit: 8,
                    ),
                  );

                  addTearDown(unit.dispose);

                  final persons = (await populateWithRandomPersons(
                    GetIt.I<DatabaseRepository>().collection('Persons'),
                    11,
                  ))
                      .sortedBy((o) => o.name);

                  final person = BasicDataObject(
                    name: 'zz last guy!',
                    ref: GetIt.I<DatabaseRepository>()
                        .collection('Persons')
                        .doc(),
                  );
                  await person.set();

                  expect(
                    unit.objectsStream,
                    emitsInOrder(
                      [
                        persons.take(8),
                        [...persons.take(16), person].sortedBy((o) => o.name),
                        [...persons.take(16), person].sortedBy((o) => o.name),
                      ],
                    ),
                  );

                  await unit.objectsStream.next();
                  await unit.loadNextPage();
                  await unit.objectsStream.next();
                  await unit.loadPreviousPage();
                },
                timeout: const Timeout(Duration(seconds: 15)),
              );

              group(
                'Advanced pagination',
                () {
                  MockPaginatableStream<BasicDataObject> _getMockStream({
                    int limit = 20,
                    int currentOffset = 1,
                    bool isLoading = false,
                    bool canPaginateForward = true,
                    bool canPaginateBackward = true,
                    bool canPaginate = true,
                  }) {
                    final objectsPaginatableStream =
                        MockPaginatableStream<BasicDataObject>();

                    when(objectsPaginatableStream.stream)
                        .thenAnswer((_) => BehaviorSubject());
                    when(objectsPaginatableStream.canPaginate)
                        .thenReturn(canPaginate);
                    when(objectsPaginatableStream.canPaginateBackward)
                        .thenReturn(canPaginateBackward);
                    when(objectsPaginatableStream.canPaginateForward)
                        .thenReturn(canPaginateForward);
                    when(objectsPaginatableStream.currentOffset)
                        .thenReturn(currentOffset);
                    when(objectsPaginatableStream.limit).thenReturn(limit);
                    when(objectsPaginatableStream.isLoading)
                        .thenReturn(isLoading);
                    when(objectsPaginatableStream.loadPage(captureAny))
                        .thenAnswer((_) async {});
                    return objectsPaginatableStream;
                  }

                  test(
                    'Throttling',
                    () async {
                      // ignore: unawaited_futures
                      fakeAsync(
                        (fakeTime) async {
                          final MockPaginatableStream<BasicDataObject>
                              objectsPaginatableStream =
                              // ignore: avoid_redundant_argument_values
                              _getMockStream(currentOffset: 1, limit: 20);

                          final unit = ListController<void, BasicDataObject>(
                            objectsPaginatableStream: objectsPaginatableStream,
                          );

                          addTearDown(unit.dispose);

                          //Adds 10 of every number from 0 to 9 ...
                          for (var i = 0; i < 100; i++) {
                            unit.ensureItemPageLoaded((i / 10).floor());
                          }

                          fakeTime.elapse(const Duration(seconds: 2));

                          when(objectsPaginatableStream.currentOffset)
                              .thenReturn(0);

                          //... then 2 of 20, so that it loads next offset
                          unit
                            ..ensureItemPageLoaded(20)
                            ..ensureItemPageLoaded(20);

                          fakeTime.elapse(const Duration(seconds: 2));

                          //Change to different offset so that we make sure
                          //it is never loading an already loaded page
                          when(objectsPaginatableStream.currentOffset)
                              .thenReturn(2);

                          unit
                            ..ensureItemPageLoaded(40)
                            ..ensureItemPageLoaded(40);

                          fakeTime.elapse(const Duration(seconds: 2));

                          verify(objectsPaginatableStream.loadPage(0))
                              .called(1);
                          verify(objectsPaginatableStream.loadPage(1))
                              .called(1);
                          verifyNever(objectsPaginatableStream.loadPage(2));
                        },
                      );
                    },
                  );

                  test(
                    'Respects isLoading & currentOffset',
                    () async {
                      // ignore: unawaited_futures
                      fakeAsync(
                        (fakeTime) async {
                          final MockPaginatableStream<BasicDataObject>
                              objectsPaginatableStream =
                              // ignore: avoid_redundant_argument_values
                              _getMockStream(currentOffset: 0, limit: 20);

                          final unit = ListController<void, BasicDataObject>(
                            objectsPaginatableStream: objectsPaginatableStream,
                          );

                          addTearDown(unit.dispose);

                          unit
                            ..ensureItemPageLoaded(0)
                            ..ensureItemPageLoaded(0)
                            ..ensureItemPageLoaded(0);
                          fakeTime.elapse(const Duration(seconds: 2));
                          verifyNever(objectsPaginatableStream.loadPage(0));

                          when(objectsPaginatableStream.currentOffset)
                              .thenReturn(1);
                          when(objectsPaginatableStream.isLoading)
                              .thenReturn(true);

                          unit
                            ..ensureItemPageLoaded(0)
                            ..ensureItemPageLoaded(0)
                            ..ensureItemPageLoaded(0);
                          fakeTime.elapse(const Duration(seconds: 2));
                          verifyNever(objectsPaginatableStream.loadPage(0));

                          when(objectsPaginatableStream.isLoading)
                              .thenReturn(false);

                          unit
                            ..ensureItemPageLoaded(0)
                            ..ensureItemPageLoaded(0)
                            ..ensureItemPageLoaded(0);
                          fakeTime.elapse(const Duration(seconds: 2));
                          verify(objectsPaginatableStream.loadPage(0))
                              .called(1);
                        },
                      );
                    },
                  );

                  test(
                    'loadPage forces loading page',
                    () async {
                      // ignore: unawaited_futures
                      fakeAsync(
                        (fakeTime) async {
                          final MockPaginatableStream<BasicDataObject>
                              objectsPaginatableStream =
                              // ignore: avoid_redundant_argument_values
                              _getMockStream(currentOffset: 0, limit: 20);

                          final unit = ListController<void, BasicDataObject>(
                            objectsPaginatableStream: objectsPaginatableStream,
                          );

                          addTearDown(unit.dispose);

                          unit.loadPage(0);
                          fakeTime.elapse(const Duration(seconds: 2));
                          verify(objectsPaginatableStream.loadPage(0))
                              .called(1);

                          when(objectsPaginatableStream.currentOffset)
                              .thenReturn(1);
                          when(objectsPaginatableStream.isLoading)
                              .thenReturn(true);

                          unit.loadPage(0);
                          fakeTime.elapse(const Duration(seconds: 2));
                          verify(objectsPaginatableStream.loadPage(0))
                              .called(2);

                          when(objectsPaginatableStream.isLoading)
                              .thenReturn(false);

                          unit.loadPage(0);
                          fakeTime.elapse(const Duration(seconds: 2));
                          verify(objectsPaginatableStream.loadPage(0))
                              .called(3);
                        },
                      );
                    },
                  );
                },
              );
            },
          );

          test(
            'With Search',
            () async {
              final persons = (await populateWithRandomPersons(
                GetIt.I<DatabaseRepository>().collection('Persons'),
                6,
              ))
                  .sortedBy((o) => o.name);

              final person = BasicDataObject(
                name: 'someguy!',
                ref: GetIt.I<DatabaseRepository>().collection('Persons').doc(),
              );
              await person.set();

              final unit = ListController<void, BasicDataObject>(
                objectsPaginatableStream: PaginatableStream.query(
                  query: GetIt.I<DatabaseRepository>()
                      .collection('Persons')
                      .orderBy('Name'),
                  mapper: BasicDataObject.fromJsonDoc,
                ),
              );

              addTearDown(unit.dispose);

              expect(
                unit.objectsStream,
                emitsInOrder(
                  [
                    [...persons, person].sortedBy((o) => o.name),
                    [person],
                    [person],
                    [...persons, person].sortedBy((o) => o.name),
                  ],
                ),
              );

              await unit.searchSubject.next();
              await unit.searchSubject.next();

              unit.searchSubject.add('someguy');
              unit.searchSubject.add('some');
              unit.searchSubject.add('');
            },
            timeout: const Timeout(Duration(seconds: 15)),
          );
        },
      );

      test(
        'Selecting Objects',
        () async {
          final persons = (await populateWithRandomPersons(
            GetIt.I<DatabaseRepository>().collection('Persons'),
            10,
          ))
              .sortedBy((o) => o.name);

          final unit = ListController<void, BasicDataObject>(
            objectsPaginatableStream: PaginatableStream.query(
              query: GetIt.I<DatabaseRepository>()
                  .collection('Persons')
                  .orderBy('Name'),
              mapper: BasicDataObject.fromJsonDoc,
            ),
          );

          addTearDown(unit.dispose);

          expect(
            unit.selectionStream,
            emitsInOrder(
              [
                isNull,
                persons.toSet(),
                <BasicDataObject>{},
                {persons.first},
                <BasicDataObject>{},
                {persons.last},
                {persons.last, persons.first},
                isNull,
              ],
            ),
          );

          await unit.objectsStream.next();

          unit.selectAll();
          expect(unit.currentSelection, persons.toSet());

          unit.deselectAll();
          expect(unit.currentSelection, <BasicDataObject>{});

          unit.select(persons.first);
          expect(unit.currentSelection, {persons.first});

          unit.deselect(persons.first);
          expect(unit.currentSelection, <BasicDataObject>{});

          unit.toggleSelected(persons.last);
          expect(unit.currentSelection, {persons.last});

          unit.toggleSelected(persons.first);
          expect(unit.currentSelection, {persons.last, persons.first});

          unit.exitSelectionMode();
          expect(unit.currentSelection, null);
        },
        timeout: const Timeout(Duration(seconds: 15)),
      );

      test(
        'Grouping',
        () async {
          final List<Color> colors = [
            Colors.red.shade500,
            Colors.red.shade500,
            Colors.red.shade500,
            Colors.green.shade500,
            Colors.green.shade500,
            Colors.green.shade500,
            Colors.blue.shade500,
            Colors.blue.shade500,
            Colors.blue.shade500,
            Colors.black,
            Colors.black,
            Colors.black,
          ];

          final persons = List.generate(
            10,
            (index) => BasicDataObject(
              ref: GetIt.I<DatabaseRepository>().collection('Persons').doc(),
              name: mockName(),
              color: colors[index],
            ),
          ).sortedBy((p) => p.name);

          await Future.wait(persons.map((e) => e.set()));

          final paginatableStream = PaginatableStream.query(
            query: GetIt.I<DatabaseRepository>()
                .collection('Persons')
                .orderBy('Name'),
            mapper: BasicDataObject.fromJsonDoc,
          );
          final unit = ListController<Color?, BasicDataObject>(
            objectsPaginatableStream: paginatableStream,
            groupingStream: Stream.value(true),
            groupBy: (o) {
              return o.groupListsBy<Color?>((element) => element.color);
            },
          );

          addTearDown(unit.dispose);

          final grouped = persons.groupListsBy((p) => p.color);

          expect(
            unit.groupedObjectsStream,
            emitsInOrder([
              {
                for (final c in colors.toSet()) c: [],
              },
              {
                for (final c in colors.toSet()) c: [],
                Colors.red.shade500: grouped[Colors.red.shade500],
              },
              {
                for (final c in colors.toSet()) c: [],
                Colors.red.shade500: grouped[Colors.red.shade500],
                Colors.green.shade500: grouped[Colors.green.shade500],
              },
              {
                for (final c in colors.toSet()) c: [],
                Colors.red.shade500: grouped[Colors.red.shade500],
                Colors.green.shade500: grouped[Colors.green.shade500],
                Colors.blue.shade500: grouped[Colors.blue.shade500],
              },
              grouped,
              persons
                  .where((p) => p != persons.last)
                  .groupListsBy((p) => p.color),
            ]),
          );

          await unit.groupedObjectsStream.next();

          unit
            ..openGroup(Colors.red.shade500)
            ..openGroup(Colors.green.shade500)
            ..openGroup(Colors.blue.shade500)
            ..openGroup(Colors.black);

          await persons.last.ref.delete();

          await unit.groupedObjectsStream.next();
        },
        timeout: const Timeout(Duration(seconds: 15)),
      );

      test(
        'Opening/Closing groups',
        () async {
          final List<Color> colors = [
            Colors.red.shade500,
            Colors.red.shade500,
            Colors.red.shade500,
            Colors.green.shade500,
            Colors.green.shade500,
            Colors.green.shade500,
            Colors.blue.shade500,
            Colors.blue.shade500,
            Colors.blue.shade500,
            Colors.black,
            Colors.black,
            Colors.black,
          ];

          final persons = List.generate(
            10,
            (index) => BasicDataObject(
              ref: GetIt.I<DatabaseRepository>().collection('Persons').doc(),
              name: index.toString() + mockName(),
              color: colors[index],
            ),
          ).sortedBy((p) => p.name);

          await Future.wait(persons.map((e) => e.set()));

          final unit = ListController<Color?, BasicDataObject>(
            objectsPaginatableStream: PaginatableStream.query(
              query: GetIt.I<DatabaseRepository>()
                  .collection('Persons')
                  .orderBy('Name'),
              mapper: BasicDataObject.fromJsonDoc,
            ),
            groupingStream: Stream.value(true),
            groupByStream: (o) async* {
              yield o.groupListsBy<Color?>((element) => element.color);
            },
          );

          addTearDown(unit.dispose);

          await unit.openedGroupsStream.next();
          await unit.objectsStream.next();

          final grouped =
              persons.groupListsBy<Color?>((element) => element.color);

          expect(
            unit.openedGroupsStream,
            emitsInOrder(
              [
                <Color?>{},
                {persons.first.color},
                {persons.first.color, persons.last.color},
                {persons.last.color},
                <Color?>{},
                {persons.last.color},
              ],
            ),
          );

          expect(
            unit.groupedObjectsStream,
            emitsInOrder(
              [
                {
                  for (final c in colors.toSet()) c: [],
                },
                {
                  for (final c in colors.toSet()) c: [],
                  persons.first.color: grouped[persons.first.color],
                },
                {
                  for (final c in colors.toSet()) c: [],
                  persons.first.color: grouped[persons.first.color]!,
                  persons.last.color: grouped[persons.last.color]!
                },
                {
                  for (final c in colors.toSet()) c: [],
                  persons.last.color: grouped[persons.last.color],
                },
                {
                  for (final c in colors.toSet()) c: [],
                },
                {
                  for (final c in colors.toSet()) c: [],
                  persons.last.color: grouped[persons.last.color],
                },
              ],
            ),
          );

          unit
            ..openGroup(persons.first.color)
            ..openGroup(persons.last.color)
            ..closeGroup(persons.first.color)
            ..closeGroup(persons.last.color)
            ..toggleGroup(persons.last.color);
        },
        timeout: const Timeout(Duration(seconds: 15)),
      );
    },
  );
}

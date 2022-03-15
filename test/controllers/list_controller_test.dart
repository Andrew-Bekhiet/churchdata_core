import 'package:churchdata_core/churchdata_core.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mock_data/mock_data.dart';

import '../churchdata_core.dart';
import '../models/basic_data_object.dart';
import '../utils.dart';

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

          test(
            'With pagination',
            () async {
              final unit = ListController<void, BasicDataObject>(
                objectsPaginatableStream: PaginatableStream.query(
                  query: GetIt.I<DatabaseRepository>()
                      .collection('Persons')
                      .orderBy('Name'),
                  mapper: BasicDataObject.fromJsonDoc,
                  pageLimit: 4,
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
                ref: GetIt.I<DatabaseRepository>().collection('Persons').doc(),
              );
              await person.set();

              expect(
                unit.objectsStream,
                emitsInOrder(
                  [
                    persons.take(8),
                    [...persons.skip(4).take(8), person]
                        .sortedBy((o) => o.name),
                    persons.take(8),
                  ],
                ),
              );

              await unit.objectsStream.next;
              await unit.loadNextPage();
              await unit.objectsStream.next;
              await unit.loadPreviousPage();
            },
            timeout: const Timeout(Duration(seconds: 15)),
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

              await unit.searchSubject.next;
              await unit.searchSubject.next;

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

          await unit.objectsStream.next;

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

          final unit = ListController<Color?, BasicDataObject>(
            objectsPaginatableStream: PaginatableStream.query(
              query: GetIt.I<DatabaseRepository>()
                  .collection('Persons')
                  .orderBy('Name'),
              mapper: BasicDataObject.fromJsonDoc,
            ),
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

          await unit.groupedObjectsStream.next;

          unit
            ..openGroup(Colors.red.shade500)
            ..openGroup(Colors.green.shade500)
            ..openGroup(Colors.blue.shade500)
            ..openGroup(Colors.black);

          await persons.last.ref.delete();
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
            groupBy: (o) {
              return o.groupListsBy<Color?>((element) => element.color);
            },
          );

          addTearDown(unit.dispose);

          await unit.openedGroupsStream.next;
          await unit.objectsStream.next;

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

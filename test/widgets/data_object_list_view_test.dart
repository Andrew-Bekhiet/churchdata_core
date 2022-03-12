import 'dart:math';

import 'package:churchdata_core/churchdata_core.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:mock_data/mock_data.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../churchdata_core.dart';
import '../models/basic_data_object.dart';
import '../utils.dart';
import 'data_object_list_view_test.mocks.dart';

@GenerateMocks([ShareService])
void main() {
  group(
    'DataObjectListView widget tests ->',
    () {
      setUp(
        () async {
          GetIt.I.pushNewScope(scopeName: 'DatabaseTestsScope');

          registerFirebaseMocks();

          GetIt.I.registerSingleton(DatabaseRepository());
          GetIt.I.registerSingleton<ShareService>(MockShareService());
          // GetIt.I.registerSingleton(DefaultViewableObjectTapHandler());
        },
      );

      tearDown(() async => GetIt.I.reset());

      testWidgets(
        'Basic data',
        (tester) async {
          const int pageLimit = 30;
          const double scrollDelta = 90;

          final objects = (await populateWithRandomPersons(
            GetIt.I<DatabaseRepository>().collection('Persons'),
          ))
              .sortedBy((o) => o.name);

          final listController = ListController(
            objectsPaginatableStream: PaginatableStream.query(
              query: GetIt.I<DatabaseRepository>()
                  .collection('Persons')
                  .orderBy('Name'),
              mapper: BasicDataObject.fromJsonDoc,
              pageLimit: pageLimit,
            ),
          );

          addTearDown(listController.dispose);

          await tester.pumpWidget(
            wrapWithMaterialApp(
              Scaffold(
                body: DataObjectListView<void, BasicDataObject>(
                  autoDisposeController: false,
                  controller: listController,
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.byType(ListView), findsOneWidget);
          expect(
            find.descendant(
              of: find.byType(ListView),
              matching: find.byType(ViewableObjectWidget<BasicDataObject>),
            ),
            findsWidgets,
          );
          expect(
            find.widgetWithText(
              ViewableObjectWidget<BasicDataObject>,
              objects.first.name,
            ),
            findsOneWidget,
          );

          await tester.scrollUntilVisible(
            find.widgetWithText(
              ViewableObjectWidget<BasicDataObject>,
              objects[pageLimit - 1].name,
            ),
            scrollDelta,
          );
          await tester.scrollUntilVisible(
            find.widgetWithText(
              ViewableObjectWidget<BasicDataObject>,
              objects[pageLimit].name,
            ),
            scrollDelta,
          );

          await listController.loadNextPage();
          await tester.pumpAndSettle();

          expect(
            find.widgetWithText(
              ViewableObjectWidget<BasicDataObject>,
              objects.first.name,
            ),
            findsNothing,
          );
          expect(
            find.widgetWithText(
              ViewableObjectWidget<BasicDataObject>,
              objects[pageLimit - 1].name,
            ),
            findsNothing,
          );
          await tester.scrollUntilVisible(
            find.widgetWithText(
              ViewableObjectWidget<BasicDataObject>,
              objects[pageLimit * 2].name,
            ),
            scrollDelta,
          );
          await tester.dragUntilVisible(
            find.byType(Scrollable),
            find.widgetWithText(
              ViewableObjectWidget<BasicDataObject>,
              objects[pageLimit].name,
            ),
            //Scrolling up to check kthe first widget
            const Offset(0, scrollDelta),
          );
        },
      );
      testWidgets(
        'Grouped list',
        (tester) async {
          const int pageLimit = 30;
          const double scrollDelta = 90;

          final colors = Colors.primaries.map((c) => c.shade500).toList();

          final random = Random();
          final objects = List.generate(
            10,
            (index) => BasicDataObject(
              ref: GetIt.I<DatabaseRepository>().collection('Persons').doc(),
              name: index.toString() + mockName(),
              color: colors[random.nextInt(colors.length)],
            ),
          ).sortedBy((p) => p.name);

          await Future.wait(objects.map((e) => e.set()));

          final listController = ListController<Color?, BasicDataObject>(
            objectsPaginatableStream: PaginatableStream.query(
              query: GetIt.I<DatabaseRepository>()
                  .collection('Persons')
                  .orderBy('Name'),
              mapper: BasicDataObject.fromJsonDoc,
              pageLimit: pageLimit,
            ),
            groupBy: (o) => o.groupListsBy(
              (e) => e.color,
            ),
          )..groupingSubject.add(true);

          await tester.pumpWidget(
            wrapWithMaterialApp(
              Scaffold(
                body: DataObjectListView<Color?, BasicDataObject>(
                  autoDisposeController: false,
                  controller: listController,
                  groupBuilder: (
                    c, {
                    onLongPress,
                    onTap,
                    showSubtitle,
                    subtitle,
                    trailing,
                    onTapOnNull,
                  }) =>
                      Container(
                    key: ValueKey(c),
                    color: c,
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.byType(GroupListView), findsOneWidget);
          expect(
            find.descendant(
              of: find.byType(GroupListView),
              matching: find.byType(Container),
            ),
            findsWidgets,
          );
          expect(
            find.widgetWithText(
              ViewableObjectWidget<BasicDataObject>,
              objects.first.name,
            ),
            findsNothing,
          );
          expect(
            find.byKey(ValueKey(objects.first.color)),
            findsOneWidget,
          );

          listController.openGroup(objects.first.color);

          await tester.scrollUntilVisible(
            find.widgetWithText(
              ViewableObjectWidget<BasicDataObject>,
              objects.first.name,
            ),
            scrollDelta,
          );

          await tester.scrollUntilVisible(
            find.byKey(ValueKey(objects[2].color)),
            scrollDelta,
          );

          listController.openGroup(objects[2].color);

          await tester.scrollUntilVisible(
            find.widgetWithText(
              ViewableObjectWidget<BasicDataObject>,
              objects[2].name,
            ),
            scrollDelta,
          );
        },
      );

      testWidgets(
        'Selecting objects',
        (tester) async {
          const int pageLimit = 30;

          final objects = (await populateWithRandomPersons(
            GetIt.I<DatabaseRepository>().collection('Persons'),
            pageLimit,
          ))
              .sortedBy((o) => o.name);

          when(GetIt.I<ShareService>().shareObject(objects[0]))
              .thenAnswer((_) async => Uri.parse('test:url'));
          when(GetIt.I<ShareService>()
                  .shareText(objects[0].name + ': test:url'))
              .thenAnswer((_) async => Never);

          final listController = ListController(
            objectsPaginatableStream: PaginatableStream.query(
              query: GetIt.I<DatabaseRepository>()
                  .collection('Persons')
                  .orderBy('Name'),
              mapper: BasicDataObject.fromJsonDoc,
              pageLimit: pageLimit,
            ),
          );

          await tester.pumpWidget(
            wrapWithMaterialApp(
              Scaffold(
                body: DataObjectListView<void, BasicDataObject>(
                  autoDisposeController: false,
                  controller: listController,
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          await tester.longPress(
              find.byType(ViewableObjectWidget<BasicDataObject>).first);
          await tester.pumpAndSettle();

          expect(
            find.descendant(
              of: find.byType(ViewableObjectWidget<BasicDataObject>),
              matching: find.byType(Checkbox),
            ),
            findsWidgets,
          );

          expect(
            tester.widgetList(find.byType(Checkbox)).toList().cast<Checkbox>(),
            predicate<List<Checkbox>>(
              (l) =>
                  (l.first.value ?? false) &&
                  l.skip(1).every(
                        (c) => !(c.value ?? false),
                      ),
            ),
          );

          await tester
              .tap(find.byType(ViewableObjectWidget<BasicDataObject>).first);
          await tester.pumpAndSettle();

          expect(
            tester.widgetList(find.byType(Checkbox)).toList().cast<Checkbox>(),
            predicate<List<Checkbox>>(
              (l) => l.every(
                (c) => !(c.value ?? false),
              ),
            ),
          );

          await tester
              .tap(find.byType(ViewableObjectWidget<BasicDataObject>).first);
          await tester.pumpAndSettle();

          expect(
            tester.widgetList(find.byType(Checkbox)).toList().cast<Checkbox>(),
            predicate<List<Checkbox>>(
              (l) =>
                  (l.first.value ?? false) &&
                  l.skip(1).every(
                        (c) => !(c.value ?? false),
                      ),
            ),
          );

          await tester.longPress(
              find.byType(ViewableObjectWidget<BasicDataObject>).first);

          verify(GetIt.I<ShareService>().shareObject(objects[0]));
          verify(GetIt.I<ShareService>()
              .shareText(objects[0].name + ': test:url'));
          await tester.pumpAndSettle();

          expect(
            find.byType(Checkbox),
            findsNothing,
          );
        },
      );
    },
  );
}

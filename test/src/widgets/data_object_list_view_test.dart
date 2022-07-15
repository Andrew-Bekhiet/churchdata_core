import 'dart:math';

import 'package:churchdata_core/churchdata_core.dart';
import 'package:churchdata_core_mocks/churchdata_core.dart';
import 'package:churchdata_core_mocks/models/basic_data_object.dart';
import 'package:churchdata_core_mocks/utils.dart';
import 'package:churchdata_core_mocks/widgets/data_object_list_view_test.mocks.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:mock_data/mock_data.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'data_object_list_view_test.mocks.dart';

@GenerateMocks([ListController])
void main() {
  group(
    'DataObjectListView widget tests ->',
    () {
      setUp(
        () async {
          VisibilityDetectorController.instance.updateInterval = Duration.zero;

          GetIt.I.pushNewScope(scopeName: 'DataObjectListViewTestsScope');

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
          const int limit = 30;
          const double scrollDelta = 90;

          final objects = (await populateWithRandomPersons(
            GetIt.I<DatabaseRepository>().collection('Persons'),
          ))
              .sortedBy((o) => o.name);

          final listController =
              MockListControllerBase<void, BasicDataObject>();

          when(listController.objectsStream)
              .thenAnswer((_) => BehaviorSubject.seeded(objects));
          when(listController.groupingSubject)
              .thenAnswer((_) => BehaviorSubject.seeded(false));
          when(listController.selectionStream)
              .thenAnswer((_) => BehaviorSubject.seeded(null));
          when(listController.ensureItemPageLoaded(any)).thenAnswer((_) {});
          when(listController.canPaginateForward).thenReturn(false);
          when(listController.canPaginateBackward).thenReturn(false);
          when(listController.isLoading).thenReturn(false);

          when(listController.loadNextPage()).thenAnswer((_) {});
          when(listController.loadPreviousPage()).thenAnswer((_) {});
          when(listController.loadPage(any)).thenAnswer((_) {});

          await tester.pumpWidget(
            wrapWithMaterialApp(
              Scaffold(
                body: DataObjectListView<void, BasicDataObject>(
                  autoDisposeController: false,
                  controller: listController,
                  changeVisibilityUpdateInterval: false,
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
              objects[limit - 1].name,
            ),
            scrollDelta,
          );
          await tester.scrollUntilVisible(
            find.widgetWithText(
              ViewableObjectWidget<BasicDataObject>,
              objects[limit].name,
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
              objects[limit - 1].name,
            ),
            findsNothing,
          );
          await tester.scrollUntilVisible(
            find.widgetWithText(
              ViewableObjectWidget<BasicDataObject>,
              objects[limit * 2].name,
            ),
            scrollDelta,
          );
          await tester.dragUntilVisible(
            find.byType(Scrollable),
            find.widgetWithText(
              ViewableObjectWidget<BasicDataObject>,
              objects[limit].name,
            ),
            //Scrolling up to check kthe first widget
            const Offset(0, scrollDelta),
          );
        },
      );
      testWidgets(
        'Grouped list',
        (tester) async {
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

          final listController =
              MockListControllerBase<Color?, BasicDataObject>();

          when(listController.objectsStream)
              .thenAnswer((_) => BehaviorSubject.seeded(objects));
          when(listController.groupingSubject)
              .thenAnswer((_) => BehaviorSubject.seeded(true));
          when(listController.selectionStream)
              .thenAnswer((_) => BehaviorSubject.seeded(null));

          final groupedObjectsSubject = BehaviorSubject.seeded(objects
              .groupListsBy(
                (e) => e.color,
              )
              .map((key, value) => MapEntry(key, <BasicDataObject>[])));

          when(listController.currentOpenedGroups).thenReturn({});
          when(listController.groupedObjectsStream).thenAnswer(
            (_) => groupedObjectsSubject,
          );

          when(listController.ensureItemPageLoaded(any, any))
              .thenAnswer((_) {});

          when(listController.canPaginateForward).thenReturn(false);
          when(listController.canPaginateBackward).thenReturn(false);
          when(listController.isLoading).thenReturn(false);

          when(listController.loadNextPage()).thenAnswer((_) {});
          when(listController.loadPreviousPage()).thenAnswer((_) {});
          when(listController.loadPage(any)).thenAnswer((_) {});

          await tester.pumpWidget(
            wrapWithMaterialApp(
              Scaffold(
                body: DataObjectListView<Color?, BasicDataObject>(
                  changeVisibilityUpdateInterval: false,
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

          groupedObjectsSubject.add(
            objects.groupListsBy(
              (e) => e.color,
            ),
          );
          when(listController.currentOpenedGroups)
              .thenReturn({objects.first.color});

          await tester.pumpAndSettle();

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

          await groupedObjectsSubject.close();
        },
      );

      testWidgets(
        'Selecting objects',
        (tester) async {
          const int limit = 30;

          final objects = (await populateWithRandomPersons(
            GetIt.I<DatabaseRepository>().collection('Persons'),
            limit,
          ))
              .sortedBy((o) => o.name);

          when(GetIt.I<ShareService>().shareObject(objects[0]))
              .thenAnswer((_) async => Uri.parse('test:url'));
          when(GetIt.I<ShareService>()
                  .shareText(objects[0].name + ': test:url'))
              .thenAnswer((_) async => Never);

          final listController =
              MockListControllerBase<Color?, BasicDataObject>();

          final selectionSubject =
              BehaviorSubject<Set<BasicDataObject>?>.seeded(null);

          when(listController.objectsStream)
              .thenAnswer((_) => BehaviorSubject.seeded(objects));
          when(listController.groupingSubject)
              .thenAnswer((_) => BehaviorSubject.seeded(false));
          when(listController.selectionSubject)
              .thenAnswer((_) => selectionSubject);
          when(listController.selectionStream)
              .thenAnswer((_) => selectionSubject.shareValue());
          when(listController.currentSelection)
              .thenAnswer((_) => selectionSubject.value);
          when(listController.select(objects.first))
              .thenAnswer((_) => selectionSubject.add({objects.first}));
          when(listController.toggleSelected(objects.first)).thenAnswer(
            (_) => selectionSubject.value!.contains(objects.first)
                ? selectionSubject.add({})
                : selectionSubject.add({objects.first}),
          );
          when(listController.deselect(objects.first))
              .thenAnswer((_) => selectionSubject.add({}));
          when(listController.exitSelectionMode())
              .thenAnswer((_) => selectionSubject.add(null));

          when(listController.ensureItemPageLoaded(any, any))
              .thenAnswer((_) {});

          when(listController.canPaginateForward).thenReturn(false);
          when(listController.canPaginateBackward).thenReturn(false);
          when(listController.isLoading).thenReturn(false);

          when(listController.loadNextPage()).thenAnswer((_) {});
          when(listController.loadPreviousPage()).thenAnswer((_) {});
          when(listController.loadPage(any)).thenAnswer((_) {});

          await tester.pumpWidget(
            wrapWithMaterialApp(
              Scaffold(
                body: DataObjectListView<void, BasicDataObject>(
                  autoDisposeController: false,
                  controller: listController,
                  changeVisibilityUpdateInterval: false,
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

          await selectionSubject.close();
        },
      );
    },
  );
}

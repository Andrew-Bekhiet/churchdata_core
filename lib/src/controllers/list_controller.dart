import 'dart:async';
import 'dart:math';

import 'package:churchdata_core/churchdata_core.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

/*
Pseudo code for firestore pagination:
  Create a variable to store the `middlePointer`
  that points to the middle document in the current
  viewed docs, with limit to size (100)

  Initially:
    middlePointer = null
  When first snapshot is loaded:
    middlePointer = douments[douments.length/2]

  When requesting next page:
    listeningQuery = .startAt(middlePointer).limit(100)
    middlePointer = oldLastDocument

  When requesting previous page
    listeningQuery = .endAt(middlePointer).limit(100)
    middlePointer = oldFirstDocument 
*/

class ListControllerBase<G, T extends ViewableWithID> {
  static Set<S> getEmptySet<S>() => isSubtype<ID?, S>()
      ? EqualitySet<S>(
          EqualityBy<S, String?>((o) => (o as ID?)?.id),
        )
      : <S>{};

  static Set<S> setWrapper<S>(Iterable<S> old) => isSubtype<ID?, S>()
      ? EqualitySet<S>.from(
          EqualityBy<S, String?>((o) => (o as ID?)?.id),
          old,
        )
      : old.toSet();

  @protected
  final PaginatableStreamBase<T> objectsPaginatableStream;
  @protected
  final BehaviorSubject<List<T>> objectsSubject;
  late final StreamSubscription<List<T>> _objectsSubscription;

  @protected
  final BehaviorSubject<Map<G, List<T>>> groupedObjectsSubject;
  late final StreamSubscription<Map<G, List<T>>>? _groupedObjectsSubscription;

  @protected
  final BehaviorSubject<Set<T>?> selectionSubject;
  @protected
  final BehaviorSubject<Set<G>>? openedGroupsSubject;

  final BehaviorSubject<String> searchSubject;
  late final StreamSubscription<String>? _searchSubscription;

  final BehaviorSubject<bool> groupingSubject;
  late final StreamSubscription<bool>? _groupingSubscription;

  late final SearchFunction<T> filter;
  final GroupingFunction<G, T>? groupBy;
  final GroupingStreamFunction<G, T>? groupByStream;

  ValueStream<List<T>> get objectsStream => objectsSubject.shareValue();
  List<T> get currentObjects => objectsSubject.value;
  List<T>? get currentObjectsOrNull => objectsSubject.valueOrNull;

  ValueStream<Map<G, List<T>>> get groupedObjectsStream =>
      groupedObjectsSubject.shareValue();
  Map<G, List<T>> get currentGroupedObjects => groupedObjectsSubject.value;
  Map<G, List<T>>? get currentGroupedObjectsOrNull =>
      groupedObjectsSubject.valueOrNull;

  ValueStream<Set<T>?> get selectionStream => selectionSubject.shareValue();
  Set<T>? get currentSelection => selectionSubject.valueOrNull;

  ValueStream<Set<G>?> get openedGroupsStream {
    assert(openedGroupsSubject != null);
    return openedGroupsSubject!.shareValue();
  }

  Set<G>? get currentOpenedGroups {
    assert(openedGroupsSubject != null);
    return openedGroupsSubject!.valueOrNull;
  }

  final OffsetFunction offsetFromIndex;

  final BehaviorSubject<int> _pageLoaderThrottler = BehaviorSubject();

  late final StreamSubscription<int> _pageLoaderThrottlerListener;

  ListControllerBase({
    required this.objectsPaginatableStream,
    Stream<String>? searchStream,
    Stream<bool>? groupingStream,
    SearchFunction<T>? filter,
    OffsetFunction? offsetFromIndex,
    this.groupBy,
    this.groupByStream,
  })  : assert(groupByStream == null || groupBy == null),
        offsetFromIndex = offsetFromIndex ?? defaultOffsetFromIndex,
        filter = filter ?? defaultSearch<T>,
        objectsSubject = BehaviorSubject<List<T>>(),
        groupedObjectsSubject = BehaviorSubject<Map<G, List<T>>>(),
        searchSubject = BehaviorSubject<String>.seeded(''),
        groupingSubject = BehaviorSubject<bool>.seeded(false),
        selectionSubject = BehaviorSubject<Set<T>?>.seeded(null),
        openedGroupsSubject = groupBy != null || groupByStream != null
            ? BehaviorSubject<Set<G>>.seeded(getEmptySet<G>())
            : null {
    //
    _searchSubscription = searchStream?.listen(searchSubject.add,
        onError: searchSubject.addError);

    _groupingSubscription = groupingStream?.listen(groupingSubject.add,
        onError: groupingSubject.addError);

    _objectsSubscription = getObjectsSubscription(searchStream);

    _groupedObjectsSubscription = groupBy != null || groupByStream != null
        ? getGroupedObjectsSubscription()
        : null;

    _pageLoaderThrottlerListener = _pageLoaderThrottler
        .bufferTime(const Duration(seconds: 1, milliseconds: 450))
        .map(
          (b) => b
              .sublist(b.length - min(b.length, 51), b.length)
              .groupListsBy((element) => element)
              .maxOrNull,
        )
        .whereType<int>()
        .where(
          (o) =>
              objectsPaginatableStream.currentOffset != o &&
              !objectsPaginatableStream.isLoading &&
              objectsPaginatableStream.canPaginate,
        )
        .listen(objectsPaginatableStream.loadPage);
  }

  @protected
  StreamSubscription<Map<G, List<T>>> getGroupedObjectsSubscription() {
    if (groupByStream != null)
      return groupingSubject
          .switchMap(
            (g) => g
                ? Rx.combineLatest2<Map<G, List<T>>, Set<G>, Map<G, List<T>>>(
                    objectsSubject.switchMap(groupByStream!),
                    openedGroupsSubject!,
                    (o, g) => o.map(
                      (k, v) => MapEntry(
                        k,
                        g.contains(k) ? v : [],
                      ),
                    ),
                  )
                : Stream.value(<G, List<T>>{}),
          )
          .listen(groupedObjectsSubject.add,
              onError: groupedObjectsSubject.addError);

    return Rx.combineLatest3<bool, List<T>, Set<G>, Map<G, List<T>>>(
      groupingSubject,
      objectsSubject,
      openedGroupsSubject!,
      (b, o, g) => b
          ? groupBy!(o).map(
              (k, v) => MapEntry(
                k,
                g.contains(k) ? v : [],
              ),
            )
          : {},
    ).listen(groupedObjectsSubject.add,
        onError: groupedObjectsSubject.addError);
  }

  @protected
  StreamSubscription<List<T>> getObjectsSubscription(
      [Stream<String>? searchStream]) {
    return Rx.combineLatest2(
      objectsPaginatableStream.stream,
      searchStream ?? searchSubject,
      filter,
    ).listen(objectsSubject.add, onError: objectsSubject.addError);
  }

  bool get isLoading => objectsPaginatableStream.isLoading;
  bool get canPaginateForward => objectsPaginatableStream.canPaginateForward;
  bool get canPaginateBackward => objectsPaginatableStream.canPaginateBackward;

  int get currentOffset => objectsPaginatableStream.currentOffset;
  int get limit => objectsPaginatableStream.limit;

  FutureOr<void> ensureItemPageLoaded(int itemIndex, [int? itemSection]) async {
    _pageLoaderThrottler.add(
      offsetFromIndex(objectsPaginatableStream.limit, itemIndex, itemSection),
    );
  }

  FutureOr<void> loadPage(int offset) async {
    await objectsPaginatableStream.loadPage(offset);
  }

  FutureOr<void> loadNextPage() async {
    await objectsPaginatableStream.loadNextPage();
  }

  FutureOr<void> loadPreviousPage() async {
    await objectsPaginatableStream.loadPreviousPage();
  }

  void select(T object) {
    selectionSubject.add(
      setWrapper<T>({...currentSelection ?? getEmptySet<T>(), object}),
    );
  }

  void deselect(T object) {
    selectionSubject.add(
      (currentSelection ?? getEmptySet<T>()).difference(
        setWrapper<T>({object}),
      ),
    );
  }

  void selectAll([List<T>? objects]) {
    if (objects != null)
      selectionSubject.add(setWrapper<T>(objects));
    else if (groupingSubject.value)
      selectionSubject.add(
        setWrapper<T>(
          currentGroupedObjects.values.fold([], (p, c) => [...p, ...c]),
        ),
      );
    else
      selectionSubject.add(setWrapper<T>(currentObjects));
  }

  void deselectAll([List<T>? objects]) {
    if (objects == null)
      selectionSubject.add(getEmptySet<T>());
    else
      selectionSubject.add(
        (currentSelection ?? getEmptySet<T>()).difference(
          setWrapper<T>(objects),
        ),
      );
  }

  void exitSelectionMode() {
    selectionSubject.add(null);
  }

  void enterSelectionMode() {
    selectionSubject.add(getEmptySet<T>());
  }

  void toggleSelected(T item) {
    if (currentSelection == null || !currentSelection!.contains(item)) {
      select(item);
    } else {
      deselect(item);
    }
  }

  void openGroup(G group) {
    assert(openedGroupsSubject != null);
    openedGroupsSubject!.add(
      setWrapper<G>({...currentOpenedGroups ?? getEmptySet<G>(), group}),
    );
  }

  void closeGroup(G group) {
    assert(openedGroupsSubject != null);
    openedGroupsSubject!.add(
      (currentOpenedGroups ?? getEmptySet<G>()).difference(
        setWrapper<G>({group}),
      ),
    );
  }

  void toggleGroup(G group) {
    assert(openedGroupsSubject != null);
    if ((currentOpenedGroups ?? getEmptySet<G>()).contains(group)) {
      closeGroup(group);
    } else {
      openGroup(group);
    }
  }

  ListControllerBase<NewG, T> copyWithNewG<NewG>({
    PaginatableStreamBase<T>? objectsPaginatableStream,
    Stream<String>? searchStream,
    SearchFunction<T>? filter,
    required GroupingFunction<NewG, T> groupBy,
  }) {
    return ListControllerBase<NewG, T>(
      objectsPaginatableStream:
          objectsPaginatableStream ?? this.objectsPaginatableStream,
      filter: filter ?? this.filter,
      searchStream: searchStream ?? searchSubject.shareValue(),
      groupBy: groupBy,
    );
  }

  @mustCallSuper
  Future<void> dispose() async {
    await objectsPaginatableStream.dispose();

    await _pageLoaderThrottlerListener.cancel();
    await _pageLoaderThrottler.close();

    await _searchSubscription?.cancel();
    await searchSubject.close();

    await _objectsSubscription.cancel();
    await objectsSubject.close();

    await selectionSubject.close();
    await openedGroupsSubject?.close();

    await _groupingSubscription?.cancel();
    await groupingSubject.close();

    await _groupedObjectsSubscription?.cancel();
    await groupedObjectsSubject.close();
  }
}

extension MaxValueLength<T> on Map<T, List> {
  T? get maxOrNull {
    if (isEmpty) return null;
    var value = entries.first;
    for (final element in entries) {
      final newValue = element;
      if (newValue.value.length > value.value.length) {
        value = newValue;
      }
    }
    return value.key;
  }
}

typedef ListController<G, T extends ViewableWithID> = ListControllerBase<G, T>;

int defaultOffsetFromIndex(int limit, int index, [int? section]) =>
    (index / limit).floor();

///Searches in [objects].[name]
List<T> defaultSearch<T extends ViewableWithID>(
    List<T> objects, String searchTerms) {
  return objects.where((o) => o.name.contains(searchTerms)).toList();
}

///Searches only the beginning of [objects].[name]
List<T> startsWithSearch<T extends DataObject>(
    List<T> objects, String searchTerms) {
  return objects.where((o) => o.name.startsWith(searchTerms)).toList();
}

///Ignores the [searchTerms] and just returns [objects]
List<T> noopSearch<T>(List<T> objects, String searchTerms) {
  return objects;
}

typedef OffsetFunction = int Function(int limit, int index, [int? section]);
typedef SearchFunction<T> = List<T> Function(
    List<T> objects, String searchTerms);
typedef GroupingFunction<G, T> = Map<G, List<T>> Function(List<T> objects);
typedef GroupingStreamFunction<G, T> = Stream<Map<G, List<T>>> Function(
    List<T> objects);

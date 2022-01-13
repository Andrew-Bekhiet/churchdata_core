import 'dart:async';

import 'package:churchdata_core/churchdata_core.dart';
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

class ListController<G, T extends DataObject> {
  @protected
  final PaginatableStream<T> objectsPaginatableStream;
  @protected
  final BehaviorSubject<List<T>> objectsSubject;
  late final StreamSubscription<List<T>> _objectsSubscription;

  @protected
  final BehaviorSubject<Map<G, List<T>>> groupedObjectsSubject;
  late final StreamSubscription<Map<G, List<T>>>? _groupedObjectsSubscription;

  final BehaviorSubject<String> searchSubject;
  late final StreamSubscription<String>? _searchSubscription;

  @protected
  final BehaviorSubject<Set<T>?> selectionSubject;
  @protected
  final BehaviorSubject<Set<G>>? openedGroupsSubject;

  late final SearchFunction<T> filter;
  final GroupingFunction<G, T>? groupBy;

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

  ListController({
    required this.objectsPaginatableStream,
    Stream<String>? searchStream,
    SearchFunction<T>? filter,
    this.groupBy,
  })  : filter = filter ?? defaultSearch<T>,
        objectsSubject = BehaviorSubject<List<T>>(),
        groupedObjectsSubject = BehaviorSubject<Map<G, List<T>>>(),
        searchSubject = BehaviorSubject<String>.seeded(''),
        selectionSubject = BehaviorSubject<Set<T>?>.seeded(null),
        openedGroupsSubject =
            groupBy != null ? BehaviorSubject<Set<G>>.seeded({}) : null {
    //
    _searchSubscription = searchStream?.listen(searchSubject.add,
        onError: searchSubject.addError);

    _objectsSubscription = getObjectsSubscription(searchStream);

    _groupedObjectsSubscription = groupBy != null
        ? Rx.combineLatest2<List<T>, Set<G>, Map<G, List<T>>>(
            objectsSubject,
            openedGroupsSubject!,
            (o, g) => groupBy!(o).map(
              (k, v) => MapEntry(
                k,
                g.contains(k) ? v : [],
              ),
            ),
          ).listen(groupedObjectsSubject.add,
            onError: groupedObjectsSubject.addError)
        : null;
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

  FutureOr<void> loadNextPage() async {
    await objectsPaginatableStream.loadNextPage();
  }

  FutureOr<void> loadPreviousPage() async {
    await objectsPaginatableStream.loadPreviousPage();
  }

  void select(T object) {
    selectionSubject.add({...currentSelection ?? {}, object});
  }

  void deselect(T object) {
    selectionSubject.add({
      ...(currentSelection ?? {}).difference({object})
    });
  }

  void selectAll() {
    selectionSubject.add(currentObjects.toSet());
  }

  void deselectAll() {
    selectionSubject.add({});
  }

  void exitSelectionMode() {
    selectionSubject.add(null);
  }

  void enterSelectionMode() {
    selectionSubject.add({});
  }

  void toggleSelected(T item) {
    if ((currentSelection ?? {}).contains(item)) {
      deselect(item);
    } else {
      select(item);
    }
  }

  void openGroup(G group) {
    assert(openedGroupsSubject != null);
    openedGroupsSubject!.add({...currentOpenedGroups ?? {}, group});
  }

  void closeGroup(G group) {
    assert(openedGroupsSubject != null);
    openedGroupsSubject!.add({
      ...(currentOpenedGroups ?? {}).difference({group}),
    });
  }

  void toggleGroup(G group) {
    assert(openedGroupsSubject != null);
    if ((currentOpenedGroups ?? {}).contains(group)) {
      closeGroup(group);
    } else {
      openGroup(group);
    }
  }

  ListController<NewG, T> copyWithNewG<NewG>({
    PaginatableStream<T>? objectsPaginatableStream,
    Stream<String>? searchStream,
    SearchFunction<T>? filter,
    required GroupingFunction<NewG, T> groupBy,
  }) {
    return ListController<NewG, T>(
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

    await _searchSubscription?.cancel();
    await searchSubject.close();

    await _objectsSubscription.cancel();
    await objectsSubject.close();

    await selectionSubject.close();
    await openedGroupsSubject?.close();

    await _groupedObjectsSubscription?.cancel();
    await groupedObjectsSubject.close();
  }
}

///Searches in [objects].[name]
List<T> defaultSearch<T extends DataObject>(
    List<T> objects, String searchTerms) {
  return objects.where((o) => o.name.contains(searchTerms)).toList();
}

///Searches only the beginning of [objects].[name]
List<T> startsWithSearch<T extends DataObject>(
    List<T> objects, String searchTerms) {
  return objects.where((o) => o.name.startsWith(searchTerms)).toList();
}

///Ignores the [searchTerms] and just returns [objects]
List<T> noopSearch<T extends DataObject>(List<T> objects, String searchTerms) {
  return objects;
}

typedef SearchFunction<T> = List<T> Function(
    List<T> objects, String searchTerms);
typedef GroupingFunction<G, T> = Map<G, List<T>> Function(List<T> objects);

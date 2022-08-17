// Mocks generated by Mockito 5.3.0 from annotations
// in churchdata_core/test/src/widgets/data_object_list_view_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:churchdata_core/churchdata_core.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:rxdart/rxdart.dart' as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakePaginatableStreamBase_0<T> extends _i1.SmartFake
    implements _i2.PaginatableStreamBase<T> {
  _FakePaginatableStreamBase_0(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeBehaviorSubject_1<T> extends _i1.SmartFake
    implements _i3.BehaviorSubject<T> {
  _FakeBehaviorSubject_1(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeValueStream_2<T> extends _i1.SmartFake
    implements _i3.ValueStream<T> {
  _FakeValueStream_2(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeStreamSubscription_3<T> extends _i1.SmartFake
    implements _i4.StreamSubscription<T> {
  _FakeStreamSubscription_3(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeListControllerBase_4<G, T extends _i2.ViewableWithID>
    extends _i1.SmartFake implements _i2.ListControllerBase<G, T> {
  _FakeListControllerBase_4(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

/// A class which mocks [ListControllerBase].
///
/// See the documentation for Mockito's code generation for more information.
class MockListControllerBase<G, T extends _i2.ViewableWithID> extends _i1.Mock
    implements _i2.ListControllerBase<G, T> {
  MockListControllerBase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.PaginatableStreamBase<T> get objectsPaginatableStream =>
      (super.noSuchMethod(Invocation.getter(#objectsPaginatableStream),
              returnValue: _FakePaginatableStreamBase_0<T>(
                  this, Invocation.getter(#objectsPaginatableStream)))
          as _i2.PaginatableStreamBase<T>);
  @override
  _i3.BehaviorSubject<List<T>> get objectsSubject =>
      (super.noSuchMethod(Invocation.getter(#objectsSubject),
              returnValue: _FakeBehaviorSubject_1<List<T>>(
                  this, Invocation.getter(#objectsSubject)))
          as _i3.BehaviorSubject<List<T>>);
  @override
  _i3.BehaviorSubject<Map<G, List<T>>> get groupedObjectsSubject =>
      (super.noSuchMethod(Invocation.getter(#groupedObjectsSubject),
              returnValue: _FakeBehaviorSubject_1<Map<G, List<T>>>(
                  this, Invocation.getter(#groupedObjectsSubject)))
          as _i3.BehaviorSubject<Map<G, List<T>>>);
  @override
  _i3.BehaviorSubject<Set<T>?> get selectionSubject =>
      (super.noSuchMethod(Invocation.getter(#selectionSubject),
              returnValue: _FakeBehaviorSubject_1<Set<T>?>(
                  this, Invocation.getter(#selectionSubject)))
          as _i3.BehaviorSubject<Set<T>?>);
  @override
  _i3.BehaviorSubject<String> get searchSubject =>
      (super.noSuchMethod(Invocation.getter(#searchSubject),
              returnValue: _FakeBehaviorSubject_1<String>(
                  this, Invocation.getter(#searchSubject)))
          as _i3.BehaviorSubject<String>);
  @override
  _i3.BehaviorSubject<bool> get groupingSubject =>
      (super.noSuchMethod(Invocation.getter(#groupingSubject),
              returnValue: _FakeBehaviorSubject_1<bool>(
                  this, Invocation.getter(#groupingSubject)))
          as _i3.BehaviorSubject<bool>);
  @override
  _i2.SearchFunction<T> get filter =>
      (super.noSuchMethod(Invocation.getter(#filter),
              returnValue: (List<T> objects, String searchTerms) => <T>[])
          as _i2.SearchFunction<T>);
  @override
  set filter(_i2.SearchFunction<T>? _filter) =>
      super.noSuchMethod(Invocation.setter(#filter, _filter),
          returnValueForMissingStub: null);
  @override
  _i2.OffsetFunction get offsetFromIndex =>
      (super.noSuchMethod(Invocation.getter(#offsetFromIndex),
              returnValue: (int limit, int index, [int? section]) => 0)
          as _i2.OffsetFunction);
  @override
  _i3.ValueStream<List<T>> get objectsStream =>
      (super.noSuchMethod(Invocation.getter(#objectsStream),
              returnValue: _FakeValueStream_2<List<T>>(
                  this, Invocation.getter(#objectsStream)))
          as _i3.ValueStream<List<T>>);
  @override
  List<T> get currentObjects => (super
          .noSuchMethod(Invocation.getter(#currentObjects), returnValue: <T>[])
      as List<T>);
  @override
  _i3.ValueStream<Map<G, List<T>>> get groupedObjectsStream =>
      (super.noSuchMethod(Invocation.getter(#groupedObjectsStream),
              returnValue: _FakeValueStream_2<Map<G, List<T>>>(
                  this, Invocation.getter(#groupedObjectsStream)))
          as _i3.ValueStream<Map<G, List<T>>>);
  @override
  Map<G, List<T>> get currentGroupedObjects =>
      (super.noSuchMethod(Invocation.getter(#currentGroupedObjects),
          returnValue: <G, List<T>>{}) as Map<G, List<T>>);
  @override
  _i3.ValueStream<Set<T>?> get selectionStream =>
      (super.noSuchMethod(Invocation.getter(#selectionStream),
              returnValue: _FakeValueStream_2<Set<T>?>(
                  this, Invocation.getter(#selectionStream)))
          as _i3.ValueStream<Set<T>?>);
  @override
  _i3.ValueStream<Set<G>?> get openedGroupsStream =>
      (super.noSuchMethod(Invocation.getter(#openedGroupsStream),
              returnValue: _FakeValueStream_2<Set<G>?>(
                  this, Invocation.getter(#openedGroupsStream)))
          as _i3.ValueStream<Set<G>?>);
  @override
  bool get isLoading =>
      (super.noSuchMethod(Invocation.getter(#isLoading), returnValue: false)
          as bool);
  @override
  bool get canPaginateForward =>
      (super.noSuchMethod(Invocation.getter(#canPaginateForward),
          returnValue: false) as bool);
  @override
  bool get canPaginateBackward =>
      (super.noSuchMethod(Invocation.getter(#canPaginateBackward),
          returnValue: false) as bool);
  @override
  int get currentOffset =>
      (super.noSuchMethod(Invocation.getter(#currentOffset), returnValue: 0)
          as int);
  @override
  int get limit =>
      (super.noSuchMethod(Invocation.getter(#limit), returnValue: 0) as int);
  @override
  _i4.StreamSubscription<Map<G, List<T>>> getGroupedObjectsSubscription() =>
      (super.noSuchMethod(Invocation.method(#getGroupedObjectsSubscription, []),
              returnValue: _FakeStreamSubscription_3<Map<G, List<T>>>(
                  this, Invocation.method(#getGroupedObjectsSubscription, [])))
          as _i4.StreamSubscription<Map<G, List<T>>>);
  @override
  _i4.StreamSubscription<List<T>> getObjectsSubscription(
          [_i4.Stream<String>? searchStream]) =>
      (super.noSuchMethod(
              Invocation.method(#getObjectsSubscription, [searchStream]),
              returnValue: _FakeStreamSubscription_3<List<T>>(this,
                  Invocation.method(#getObjectsSubscription, [searchStream])))
          as _i4.StreamSubscription<List<T>>);
  @override
  _i4.FutureOr<void> ensureItemPageLoaded(int? itemIndex, [int? itemSection]) =>
      (super.noSuchMethod(Invocation.method(
              #ensureItemPageLoaded, [itemIndex, itemSection]))
          as _i4.FutureOr<void>);
  @override
  _i4.FutureOr<void> loadPage(int? offset) =>
      (super.noSuchMethod(Invocation.method(#loadPage, [offset]))
          as _i4.FutureOr<void>);
  @override
  void select(T? object) =>
      super.noSuchMethod(Invocation.method(#select, [object]),
          returnValueForMissingStub: null);
  @override
  void deselect(T? object) =>
      super.noSuchMethod(Invocation.method(#deselect, [object]),
          returnValueForMissingStub: null);
  @override
  void selectAll([List<T>? objects]) =>
      super.noSuchMethod(Invocation.method(#selectAll, [objects]),
          returnValueForMissingStub: null);
  @override
  void deselectAll([List<T>? objects]) =>
      super.noSuchMethod(Invocation.method(#deselectAll, [objects]),
          returnValueForMissingStub: null);
  @override
  void exitSelectionMode() =>
      super.noSuchMethod(Invocation.method(#exitSelectionMode, []),
          returnValueForMissingStub: null);
  @override
  void enterSelectionMode() =>
      super.noSuchMethod(Invocation.method(#enterSelectionMode, []),
          returnValueForMissingStub: null);
  @override
  void toggleSelected(T? item) =>
      super.noSuchMethod(Invocation.method(#toggleSelected, [item]),
          returnValueForMissingStub: null);
  @override
  void openGroup(G? group) =>
      super.noSuchMethod(Invocation.method(#openGroup, [group]),
          returnValueForMissingStub: null);
  @override
  void closeGroup(G? group) =>
      super.noSuchMethod(Invocation.method(#closeGroup, [group]),
          returnValueForMissingStub: null);
  @override
  void toggleGroup(G? group) =>
      super.noSuchMethod(Invocation.method(#toggleGroup, [group]),
          returnValueForMissingStub: null);
  @override
  _i2.ListControllerBase<NewG, T> copyWithNewG<NewG>(
          {_i2.PaginatableStreamBase<T>? objectsPaginatableStream,
          _i4.Stream<String>? searchStream,
          _i2.SearchFunction<T>? filter,
          _i2.GroupingFunction<NewG, T>? groupBy}) =>
      (super.noSuchMethod(
          Invocation.method(#copyWithNewG, [], {
            #objectsPaginatableStream: objectsPaginatableStream,
            #searchStream: searchStream,
            #filter: filter,
            #groupBy: groupBy
          }),
          returnValue: _FakeListControllerBase_4<NewG, T>(
              this,
              Invocation.method(#copyWithNewG, [], {
                #objectsPaginatableStream: objectsPaginatableStream,
                #searchStream: searchStream,
                #filter: filter,
                #groupBy: groupBy
              }))) as _i2.ListControllerBase<NewG, T>);
  @override
  _i4.Future<void> dispose() => (super.noSuchMethod(
      Invocation.method(#dispose, []),
      returnValue: _i4.Future<void>.value(),
      returnValueForMissingStub: _i4.Future<void>.value()) as _i4.Future<void>);
}

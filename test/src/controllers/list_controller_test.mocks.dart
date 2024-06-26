// Mocks generated by Mockito 5.4.4 from annotations
// in churchdata_core/test/src/controllers/list_controller_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;

import 'package:churchdata_core/churchdata_core.dart' as _i3;
import 'package:cloud_firestore/cloud_firestore.dart' as _i4;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i5;
import 'package:rxdart/rxdart.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeSubject_0<T1> extends _i1.SmartFake implements _i2.Subject<T1> {
  _FakeSubject_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeValueStream_1<T1> extends _i1.SmartFake
    implements _i2.ValueStream<T1> {
  _FakeValueStream_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [PaginatableStream].
///
/// See the documentation for Mockito's code generation for more information.
class MockPaginatableStream<T extends _i3.ID> extends _i1.Mock
    implements _i3.PaginatableStream<T> {
  MockPaginatableStream() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.Subject<_i4.Query<Map<String, dynamic>>> get query => (super.noSuchMethod(
        Invocation.getter(#query),
        returnValue: _FakeSubject_0<_i4.Query<Map<String, dynamic>>>(
          this,
          Invocation.getter(#query),
        ),
      ) as _i2.Subject<_i4.Query<Map<String, dynamic>>>);

  @override
  T Function(_i4.QueryDocumentSnapshot<Map<String, dynamic>>) get mapper =>
      (super.noSuchMethod(
        Invocation.getter(#mapper),
        returnValue: (_i4.QueryDocumentSnapshot<Map<String, dynamic>> __p0) =>
            _i5.dummyValue<T>(
          this,
          Invocation.getter(#mapper),
        ),
      ) as T Function(_i4.QueryDocumentSnapshot<Map<String, dynamic>>));

  @override
  bool get canPaginate => (super.noSuchMethod(
        Invocation.getter(#canPaginate),
        returnValue: false,
      ) as bool);

  @override
  bool get isLoading => (super.noSuchMethod(
        Invocation.getter(#isLoading),
        returnValue: false,
      ) as bool);

  @override
  bool get canPaginateForward => (super.noSuchMethod(
        Invocation.getter(#canPaginateForward),
        returnValue: false,
      ) as bool);

  @override
  bool get canPaginateBackward => (super.noSuchMethod(
        Invocation.getter(#canPaginateBackward),
        returnValue: false,
      ) as bool);

  @override
  int get currentOffset => (super.noSuchMethod(
        Invocation.getter(#currentOffset),
        returnValue: 0,
      ) as int);

  @override
  _i2.ValueStream<bool> get onLoadingChanged => (super.noSuchMethod(
        Invocation.getter(#onLoadingChanged),
        returnValue: _FakeValueStream_1<bool>(
          this,
          Invocation.getter(#onLoadingChanged),
        ),
      ) as _i2.ValueStream<bool>);

  @override
  _i2.ValueStream<List<T>> get stream => (super.noSuchMethod(
        Invocation.getter(#stream),
        returnValue: _FakeValueStream_1<List<T>>(
          this,
          Invocation.getter(#stream),
        ),
      ) as _i2.ValueStream<List<T>>);

  @override
  List<T> get currentValue => (super.noSuchMethod(
        Invocation.getter(#currentValue),
        returnValue: <T>[],
      ) as List<T>);

  @override
  List<_i4.QueryDocumentSnapshot<Map<String, dynamic>>> get currentDocs =>
      (super.noSuchMethod(
        Invocation.getter(#currentDocs),
        returnValue: <_i4.QueryDocumentSnapshot<Map<String, dynamic>>>[],
      ) as List<_i4.QueryDocumentSnapshot<Map<String, dynamic>>>);

  @override
  int get limit => (super.noSuchMethod(
        Invocation.getter(#limit),
        returnValue: 0,
      ) as int);

  @override
  _i6.Future<void> loadPage(int? offset) => (super.noSuchMethod(
        Invocation.method(
          #loadPage,
          [offset],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<void> loadNextPage() => (super.noSuchMethod(
        Invocation.method(
          #loadNextPage,
          [],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<void> loadPreviousPage() => (super.noSuchMethod(
        Invocation.method(
          #loadPreviousPage,
          [],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<void> dispose() => (super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
}

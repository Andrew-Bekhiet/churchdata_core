import 'dart:async';
import 'dart:math';

import 'package:churchdata_core/churchdata_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

abstract class PaginatableStreamBase<T> {
  final int limit;

  bool get isLoading;

  bool get canPaginateForward;
  bool get canPaginateBackward;

  int get currentOffset;

  ValueStream<bool> get onLoadingChanged;

  ValueStream<List<T>> get stream;
  List<T> get currentValue;
  List<T>? get currentValueOrNull;

  PaginatableStreamBase({
    this.limit = 100,
  });

  @protected
  PaginatableStreamBase.private({
    required this.limit,
  });

  PaginatableStreamBase.loadAll({
    required Stream<List<T>> stream,
  }) : limit = 1;

  Future<void> loadPage(int offset);

  Future<void> loadNextPage();

  Future<void> loadPreviousPage();

  Future<void> dispose();
}

class PaginatableStream<T extends ID> extends PaginatableStreamBase<T> {
  final Subject<QueryOfJson> query;
  final T Function(JsonQueryDoc) mapper;

  final bool _canPaginate;

  @override
  bool get isLoading => _onLoadingChanged.value;

  @override
  bool get canPaginateForward => _canPaginate && _canPaginateForward;
  bool _canPaginateForward = false;

  @override
  bool get canPaginateBackward => _canPaginate && _canPaginateBackward;
  bool _canPaginateBackward = false;

  final BehaviorSubject<bool> _onLoadingChanged =
      BehaviorSubject<bool>.seeded(true);

  final BehaviorSubject<List<T>> _subject = BehaviorSubject<List<T>>();
  late final StreamSubscription<List<T>> _streamSubscription;

  final BehaviorSubject<int> _offset = BehaviorSubject.seeded(0);
  final BehaviorSubject<List<JsonQueryDoc>> _docs = BehaviorSubject.seeded([]);

  @override
  int get currentOffset => _offset.value;

  @override
  ValueStream<bool> get onLoadingChanged => _onLoadingChanged.stream;

  @override
  ValueStream<List<T>> get stream => _subject.stream;
  @override
  List<T> get currentValue => _subject.value;
  @override
  List<T>? get currentValueOrNull => _subject.valueOrNull;

  List<JsonQueryDoc> get currentDocs => _docs.value;

  PaginatableStream({
    required this.query,
    required this.mapper,
    super.limit,
  }) : _canPaginate = true {
    bool queryChanged = true;

    _streamSubscription =
        Rx.combineLatest2<QueryOfJson, int, Tuple2<QueryOfJson, int>>(
      query.map(
        (v) {
          queryChanged = true;
          return v;
        },
      ),
      _offset,
      Tuple2<QueryOfJson, int>.new,
    ).switchMap<List<JsonQueryDoc>>(
      (v) {
        final query = v.item1;
        final offset = v.item2;

        final start = offset * limit;

        if (queryChanged && offset != 0) {
          _offset.add(0);
          return Stream.value([]);
        }

        if (queryChanged || offset == 0) {
          queryChanged = false;

          return query.limit(limit + 1).snapshots().map(
            (snapshot) {
              _canPaginateBackward = false;
              _canPaginateForward = snapshot.size >= limit;

              final List<JsonQueryDoc> sublist = snapshot.docs
                  .toList()
                  .sublist(0, min(limit, snapshot.docs.length));
              final int end = start + min(limit, currentDocs.length);

              return start < currentDocs.length
                  ? (currentDocs..replaceRange(start, end, sublist))
                  : sublist;
            },
          );
        } else {
          return query
              .startAfterDocument(
                currentDocs[(offset - 1) * limit + limit - 1],
              )
              .limit(limit + 1)
              .snapshots()
              .map(
            (snapshot) {
              _canPaginateBackward = true;
              _canPaginateForward = snapshot.size >= limit;

              final List<JsonQueryDoc> sublist = snapshot.docs
                  .toList()
                  .sublist(0, min(limit, snapshot.docs.length));
              final int end = start + min(limit, currentDocs.length);

              return start < currentDocs.length
                  ? (currentDocs..replaceRange(start, end, sublist))
                  : (currentDocs..addAll(sublist));
            },
          );
        }
      },
    ).map(
      (event) {
        _onLoadingChanged.add(false);

        _docs.add(event);

        return event.map(mapper).toList();
      },
    ).listen(_subject.add, onError: _subject.addError);
  }

  PaginatableStream.query({
    required QueryOfJson query,
    required T Function(JsonQueryDoc) mapper,
    int limit = 100,
  }) : this(
          mapper: mapper,
          limit: limit,
          query: BehaviorSubject.seeded(query),
        );

  PaginatableStream.loadAll({
    required Stream<List<T>> stream,
  })  : _canPaginate = false,
        query = BehaviorSubject(),
        mapper = ((o) => throw UnsupportedError(
              '"mapper" is not supported when initialized from "loadAll"',
            )),
        super.loadAll(stream: stream) {
    _streamSubscription = stream.map(
      (event) {
        _onLoadingChanged.add(false);
        return event;
      },
    ).listen(_subject.add, onError: _subject.addError);
  }

  @override
  Future<void> loadPage(int offset) async {
    if (_canPaginate) {
      _canPaginateForward = false;
      _canPaginateBackward = false;
      _onLoadingChanged.add(true);

      _offset.add(offset);
    } else {
      throw StateError('Cannot paginate');
    }
  }

  @override
  Future<void> loadNextPage() async {
    if (canPaginateForward) {
      _canPaginateForward = false;
      _onLoadingChanged.add(true);
      _offset.add((currentValue.length / limit).ceil());
    } else {
      throw StateError('Cannot paginate forward');
    }
  }

  @override
  Future<void> loadPreviousPage() async {
    if (canPaginateBackward) {
      _canPaginateBackward = false;
      _onLoadingChanged.add(true);
      _offset.add(_offset.value - 1);
    } else {
      throw StateError('Cannot paginate backward');
    }
  }

  @override
  Future<void> dispose() async {
    await _offset.close();
    await _subject.close();
    await _streamSubscription.cancel();
  }
}

enum UpdateQueryEvent { forward, backward, newQuery }

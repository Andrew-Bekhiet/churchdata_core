import 'dart:async';

import 'package:churchdata_core/churchdata_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

abstract class PaginatableStreamBase<T> {
  final int limit;

  bool get isLoading;

  bool get canPaginateForward;
  bool get canPaginateBackward;

  ValueStream<List<T>> get stream;
  List<T> get currentValue;
  List<T>? get currentValueOrNull;

  PaginatableStreamBase({
    int pageLimit = 100,
  }) : limit = pageLimit * 2;

  @protected
  PaginatableStreamBase.private({
    required this.limit,
  });

  PaginatableStreamBase.loadAll({
    required Stream<List<T>> stream,
  }) : limit = 0;

  Future<void> loadNextPage();

  Future<void> loadPreviousPage();

  Future<void> dispose();
}

class PaginatableStream<T extends ID> extends PaginatableStreamBase<T> {
  final Subject<QueryOfJson> query;
  final T Function(JsonQueryDoc) mapper;

  JsonDoc? _middlePointer;

  @override
  bool get isLoading => _isLoading;
  bool _isLoading = true;

  @override
  bool get canPaginateForward => _canPaginateForward;
  bool _canPaginateForward = false;

  @override
  bool get canPaginateBackward => _canPaginateBackward;
  bool _canPaginateBackward = false;

  final BehaviorSubject<UpdateQueryEvent> _controller =
      BehaviorSubject.seeded(UpdateQueryEvent.newQuery);
  final BehaviorSubject<List<T>> _subject = BehaviorSubject<List<T>>();
  late final StreamSubscription<List<T>> _streamSubscription;

  @override
  ValueStream<List<T>> get stream => _subject.stream;
  @override
  List<T> get currentValue => _subject.value;
  @override
  List<T>? get currentValueOrNull => _subject.valueOrNull;

  PaginatableStream({
    required this.query,
    required this.mapper,
    super.pageLimit,
  }) {
    bool queryChanged = true;

    _streamSubscription = Rx.combineLatest2<QueryOfJson, UpdateQueryEvent,
        Tuple2<QueryOfJson, UpdateQueryEvent>>(
      query.map(
        (v) {
          queryChanged = true;
          return v;
        },
      ),
      _controller,
      Tuple2<QueryOfJson, UpdateQueryEvent>.new,
    ).switchMap<List<T>>(
      (v) {
        final query = v.item1;
        final event = v.item2;

        if (queryChanged || event == UpdateQueryEvent.newQuery) {
          queryChanged = false;

          return query.limit(limit).snapshots().map(
            (snapshot) {
              if (snapshot.docs.isEmpty) return [];

              _canPaginateBackward =
                  _canPaginateForward = snapshot.size >= limit;
              _middlePointer = snapshot.docs[(snapshot.size / 2).floor()];
              return snapshot.docs.map(mapper).toList();
            },
          );
        } else if (event == UpdateQueryEvent.forward) {
          return query
              .startAtDocument(_middlePointer!)
              .limit(limit)
              .snapshots()
              .map(
            (snapshot) {
              _canPaginateForward = snapshot.size >= limit;
              if (_canPaginateForward)
                _middlePointer = snapshot.docs[(snapshot.size / 2).floor()];

              return snapshot.docs.map(mapper).toList();
            },
          );
        } else if (event == UpdateQueryEvent.backward) {
          return query
              .endBeforeDocument(_middlePointer!)
              .limitToLast(limit)
              .snapshots()
              .map((snapshot) {
            _canPaginateBackward = snapshot.size >= limit;

            if (_canPaginateBackward)
              _middlePointer = snapshot.docs[(snapshot.size / 2).floor()];

            return snapshot.docs.map(mapper).toList();
          });
        }

        return query.limit(limit).snapshots().map(
          (snapshot) {
            _canPaginateBackward = _canPaginateForward = snapshot.size >= limit;
            _middlePointer = snapshot.docs[(snapshot.size / 2).floor()];
            return snapshot.docs.map(mapper).toList();
          },
        );
      },
    ).map(
      (event) {
        _isLoading = false;
        return event;
      },
    ).listen(_subject.add, onError: _subject.addError);
  }

  PaginatableStream.query({
    required QueryOfJson query,
    required T Function(JsonQueryDoc) mapper,
    int pageLimit = 100,
  }) : this(
          mapper: mapper,
          pageLimit: pageLimit,
          query: BehaviorSubject.seeded(query),
        );

  PaginatableStream.loadAll({
    required Stream<List<T>> stream,
  })  : query = BehaviorSubject(),
        mapper = ((o) => throw UnsupportedError(
              '"mapper" is not supported when initialized from "loadAll"',
            )),
        super.loadAll(stream: stream) {
    _streamSubscription =
        stream.listen(_subject.add, onError: _subject.addError);
  }

  @override
  Future<void> loadNextPage() async {
    if (canPaginateForward) {
      _canPaginateForward = false;
      _isLoading = true;
      _controller.add(UpdateQueryEvent.forward);
    } else {
      throw StateError('Cannot paginate forward');
    }
  }

  @override
  Future<void> loadPreviousPage() async {
    if (canPaginateBackward) {
      _canPaginateBackward = false;
      _isLoading = true;
      _controller.add(UpdateQueryEvent.backward);
    } else {
      throw StateError('Cannot paginate backward');
    }
  }

  @override
  Future<void> dispose() async {
    await _subject.close();
    await _streamSubscription.cancel();
    await _controller.close();
  }
}

enum UpdateQueryEvent { forward, backward, newQuery }

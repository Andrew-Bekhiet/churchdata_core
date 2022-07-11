import 'dart:async';

import 'package:churchdata_core/churchdata_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

abstract class PaginatableStreamBase<T extends ID, S> {
  final int limit;
  final T Function(S) mapper;

  bool get canPaginateForward;

  bool get canPaginateBackward;

  ValueStream<List<T>> get stream;
  List<T> get currentValue;
  List<T>? get currentValueOrNull;

  PaginatableStreamBase({
    required this.mapper,
    int pageLimit = 100,
  }) : limit = pageLimit * 2;

  @protected
  PaginatableStreamBase.private({
    required this.mapper,
    required this.limit,
  });

  PaginatableStreamBase.loadAll({
    required Stream<List<T>> stream,
  })  : limit = 0,
        mapper = ((o) => throw UnsupportedError(
              '"mapper" is not supported when initialized from "loadAll"',
            ));

  Future<void> loadNextPage();

  Future<void> loadPreviousPage();

  Future<void> dispose();
}

class PaginatableStream<T extends ID>
    extends PaginatableStreamBase<T, JsonQueryDoc> {
  final Subject<QueryOfJson> query;

  JsonDoc? _middlePointer;

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
    required super.mapper,
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
        super.loadAll(stream: stream) {
    _streamSubscription =
        stream.listen(_subject.add, onError: _subject.addError);
  }

  @override
  Future<void> loadNextPage() async {
    if (canPaginateForward) {
      _controller.add(UpdateQueryEvent.forward);
      _canPaginateForward = false;
    } else {
      throw StateError('Cannot paginate forward');
    }
  }

  @override
  Future<void> loadPreviousPage() async {
    if (canPaginateBackward) {
      _controller.add(UpdateQueryEvent.backward);
      _canPaginateBackward = false;
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

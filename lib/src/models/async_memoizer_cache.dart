import 'dart:async';

import 'package:async/async.dart';

class AsyncMemoizerCache<T> implements AsyncMemoizer<T> {
  @override
  Future<T> get future => _completer.future;
  Completer<T> _completer = Completer<T>();

  @override
  bool get hasRun => _completer.isCompleted;

  @override
  Future<T> runOnce(FutureOr<T> Function() computation) {
    if (!hasRun) _completer.complete(Future.sync(computation));
    return future;
  }

  void invalidate() {
    _completer = Completer<T>();
  }
}

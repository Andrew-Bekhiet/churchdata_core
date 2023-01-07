// coverage:ignore-file
import 'dart:async';

import 'package:async/async.dart';

class AsyncMemoizerCache<T> implements AsyncMemoizer<T> {
  @override
  Future<T> get future => _completer.future;
  Completer<T> _completer = Completer<T>();

  T? get cachedResult => _cachedResult;
  T? _cachedResult;

  @override
  bool get hasRun => _completer.isCompleted;

  @override
  Future<T> runOnce(FutureOr<T> Function() computation) {
    if (!hasRun)
      _completer.complete(
        Future(computation).then((value) => _cachedResult = value),
      );
    return future;
  }

  void invalidate() {
    _completer = Completer<T>();
  }
}

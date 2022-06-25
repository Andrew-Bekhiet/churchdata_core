import 'dart:async';
import 'dart:developer';

import 'package:churchdata_core/churchdata_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class LoggingService {
  // coverage:ignore-start
  @visibleForTesting
  static T Function<T>(T object, {String? label, bool? $break})? dumpOverride;

  static T dump<T>(T object, {String? label, bool $break = false}) {
    if (dumpOverride != null)
      return dumpOverride!<T>(object, label: label, $break: $break);

    if (kDebugMode) {
      if (label != null)
        print(label + object.toString());
      else
        print(object);

      if ($break) debugger(message: object.toString());
    }

    return object;
  }

  LoggingService(String sentryDSN) {
    _init(sentryDSN);
  }

  Future<void> _init(String sentryDSN) async {
    await SentryFlutter.init(
      (options) => options
        ..dsn = sentryDSN
        ..diagnosticLevel = SentryLevel.warning
        ..environment = kReleaseMode ? 'Production' : 'Debug',
    );

    FlutterError.onError = (flutterError) {
      Sentry.captureException(flutterError.exception,
          stackTrace: flutterError.stack, hint: flutterError);
    };

    ErrorWidget.builder = (error) {
      if (kReleaseMode) {
        Sentry.captureException(error.exception,
            stackTrace: error.stack, hint: error);
      }
      return Material(
        child: Container(
          color: Colors.white,
          child: Text(
            'حدث خطأ:\n' + error.summary.toString(),
          ),
        ),
      );
    };

    GetIt.I.signalReady(this);

    if (GetIt.I.isRegistered<AuthRepository>())
      unawaited(
        GetIt.I.allReady().then(
          (_) async {
            if (!GetIt.I.isRegistered<AuthRepository>()) return;

            final currentUser = await GetIt.I<AuthRepository>().userStream.next;
            Sentry.configureScope(
              (scope) => scope.setUser(currentUser != null
                  ? SentryUser(
                      id: currentUser.uid,
                      email: currentUser is UserBase ? currentUser.email : null,
                      extras:
                          currentUser is UserBase ? currentUser.toJson() : null,
                    )
                  : null),
            );
          },
        ),
      );
  }

  Future<void> log(String msg) async {
    await Sentry.captureMessage(msg);
  }

  Future<void> reportError(
    Exception error, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? extras,
    StackTrace? stackTrace,
  }) async {
    await Sentry.captureException(
      error,
      stackTrace: stackTrace,
      withScope: (scope) {
        final currentUser = GetIt.I.isRegistered<AuthRepository>()
            ? GetIt.I<AuthRepository>().currentUser
            : null;
        scope
          ..setUser(SentryUser(
            extras: currentUser is UserBase? ? currentUser?.toJson() : null,
            email: currentUser is UserBase? ? currentUser?.email : null,
            id: currentUser?.uid,
          ))
          ..setContexts('Data', data);

        if (extras != null)
          for (final entry in extras.entries) {
            scope.setExtra(entry.key, entry.value);
          }
      },
    );
  }

  Future<void> reportFlutterError(FlutterErrorDetails flutterError,
      {Map<String, dynamic>? data, Map<String, dynamic>? extras}) async {
    await Sentry.captureException(
      flutterError,
      stackTrace: flutterError.stack,
      hint: flutterError.toString(),
      withScope: (scope) {
        final currentUser = GetIt.I.isRegistered<AuthRepository>()
            ? GetIt.I<AuthRepository>().currentUser
            : null;
        scope
          ..setUser(SentryUser(
            extras: currentUser is UserBase? ? currentUser?.toJson() : null,
            email: currentUser is UserBase? ? currentUser?.email : null,
            id: currentUser?.uid,
          ))
          ..setContexts('Data', data);

        if (extras != null)
          for (final entry in extras.entries) {
            scope.setExtra(entry.key, entry.value);
          }
      },
    );
  }
  // coverage:ignore-end
}

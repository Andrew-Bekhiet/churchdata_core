import 'package:churchdata_core/churchdata_core.dart';
import 'package:mockito/mockito.dart';

class FakeNotificationsService extends NotificationsService {
  @override
  Future<void> initPlugins() async {}

  @override
  Future<void> listenToFirebaseMessaging() async {}
}

class MockNotificationsService extends Mock implements NotificationsService {
  @override
  Future<bool> schedulePeriodic(
    Duration? duration,
    int? id,
    Function? callback, {
    DateTime? startAt,
    bool allowWhileIdle = false,
    bool exact = false,
    bool wakeup = false,
    bool rescheduleOnReboot = false,
  }) =>
      super.noSuchMethod(
          Invocation.method(#schedulePeriodic, [
            duration,
            id,
            callback
          ], {
            #startAt: startAt,
            #allowWhileIdle: allowWhileIdle,
            #exact: exact,
            #wakeup: wakeup,
            #rescheduleOnReboot: rescheduleOnReboot,
          }),
          returnValue: Future<bool>.value(true)) as Future<bool>;
}

import 'dart:async';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:churchdata_core/churchdata_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb, protected;
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    hide Person;
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class NotificationsService {
  late final StreamSubscription<RemoteMessage>? onForegroundMessageSubscription;
  StreamSubscription<String?>? onFCMTokenRefresh;

  NotificationsService() {
    listenToFirebaseMessaging();
    initPlugins();
    listenToUserStream();
  }

  @protected
  void listenToUserStream() {
    unawaited(
      GetIt.I<AuthRepository>()
          .userStream
          .firstWhere((user) => user != null)
          .then(
        (user) {
          if (user == null) return;

          maybeSetupUserNotifications(user);
        },
      ),
    );
  }

  @protected
  void listenToFirebaseMessaging() {
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessageReceived);
    onForegroundMessageSubscription =
        FirebaseMessaging.onMessage.listen(onForegroundMessage);
  }

  @mustCallSuper
  Future<void> dispose() async {
    await onForegroundMessageSubscription?.cancel();
    await onFCMTokenRefresh?.cancel();
  }

  @protected
  Future<void> initPlugins() async {
    if (!kIsWeb) await AndroidAlarmManager.initialize();

    await GetIt.I<FlutterLocalNotificationsPlugin>().initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('warning'),
      ),
      onDidReceiveBackgroundNotificationResponse: onNotificationClick,
    );

    GetIt.I.signalReady(this);
  }

  Future<bool> schedulePeriodic(
    Duration duration,
    int id,
    Function callback, {
    DateTime? startAt,
    bool allowWhileIdle = false,
    bool exact = false,
    bool wakeup = false,
    bool rescheduleOnReboot = false,
  }) async {
    return AndroidAlarmManager.periodic(
      duration,
      id,
      callback,
      startAt: startAt,
      allowWhileIdle: allowWhileIdle,
      exact: exact,
      wakeup: wakeup,
      rescheduleOnReboot: rescheduleOnReboot,
    );
  }

  Future<void> showNotificationContents(
    BuildContext context,
    Notification notification, {
    List<Widget>? actions,
  }) async {
    final Viewable? attachment = notification.attachmentLink != null
        ? await GetIt.I<DatabaseRepository>().getObjectFromLink(
            Uri.parse(notification.attachmentLink!),
          )
        : null;

    final PersonBase? userData = notification.senderUID != null
        ? await GetIt.I<DatabaseRepository>()
            .getUserData(notification.senderUID!)
        : null;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: actions,
        title: Text(notification.title),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 85 / 100,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  notification.body,
                  style: const TextStyle(fontSize: 18),
                ),
                if (attachment != null)
                  ViewableObjectWidget(attachment)
                else if (notification.attachmentLink != null)
                  CachedNetworkImage(
                    useOldImageOnUrlChange: true,
                    imageUrl: notification.attachmentLink!,
                  ),
                if (userData != null)
                  Text(
                    'من: ' + userData.name,
                  ),
                Text(
                  DateFormat('yyyy/M/d h:m a', 'ar-EG').format(
                    notification.sentTime,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Notification?> getInitialNotification() async {
    final message = await GetIt.I<FirebaseMessaging>().getInitialMessage();
    if (message != null)
      return Notification.fromRemoteMessage(message);
    else {
      final payload = (await GetIt.I<FlutterLocalNotificationsPlugin>()
              .getNotificationAppLaunchDetails())
          ?.notificationResponse
          ?.payload;

      if (payload != null) {
        if (int.tryParse(payload) != null)
          return GetIt.I<CacheRepository>()
              .box<Notification>('Notifications')
              .getAt(int.parse(payload));
        else
          return GetIt.I<CacheRepository>()
              .box<Notification>('Notifications')
              .get(payload);
      }
    }
    return null;
  }

  Future<void> showInitialNotification(BuildContext context) async {
    final pendingNotification = await getInitialNotification();

    if (pendingNotification != null) {
      await showNotificationContents(context, pendingNotification);
    }
  }

  Future<bool> registerFCMToken({String? cachedToken}) async {
    if (GetIt.I<AuthRepository>().currentUser != null &&
        await GetIt.I<FirebaseMessaging>().isSupported()) {
      final permission = await GetIt.I<FirebaseMessaging>().requestPermission();

      if (permission.authorizationStatus == AuthorizationStatus.authorized ||
          permission.authorizationStatus == AuthorizationStatus.provisional) {
        final token =
            cachedToken ?? await GetIt.I<FirebaseMessaging>().getToken();

        if (token != null &&
            GetIt.I<CacheRepository>()
                    .box('Settings')
                    .get('Registered_FCM_Token') !=
                token) {
          await GetIt.I<FunctionsService>().registerFCMToken(token);

          await GetIt.I<CacheRepository>().box('Settings').put(
                'Registered_FCM_Token',
                token,
              );

          onFCMTokenRefresh ??=
              GetIt.I<FirebaseMessaging>().onTokenRefresh.listen(
                    (t) => registerFCMToken(cachedToken: t),
                  );

          return true;
        }
      }
    }
    return false;
  }

  @protected
  Future<void> maybeSetupUserNotifications(UID uid) async {
    await registerFCMToken();
  }

  //
  //Static callbacks
  //

  static Future<void> onNotificationClick(
      NotificationResponse? response) async {
    throw UnimplementedError('onNotificationClick is not implemented');
  }

  static Future<void> storeNotification(RemoteMessage message) async {
    final bool registered = GetIt.I.isRegistered<CacheRepository>();

    if (!registered) {
      GetIt.I.registerSingleton<CacheRepository>(
        CacheRepository(),
        signalsReady: true,
        dispose: (r) => r.dispose(),
      );

      await GetIt.I.isReady<CacheRepository>();
    }

    final bool isBoxOpen =
        GetIt.I<CacheRepository>().isBoxOpen('Notifications');
    if (!isBoxOpen)
      await GetIt.I<CacheRepository>().openBox<Notification>('Notifications');

    await GetIt.I<CacheRepository>().box<Notification>('Notifications').add(
          Notification.fromRemoteMessage(message),
        );

    if (!isBoxOpen)
      await GetIt.I<CacheRepository>()
          .box<Notification>('Notifications')
          .close();
    if (!registered) GetIt.I.unregister<CacheRepository>();
  }

  ///Make sure to add ```@pragma('vm:entry-point')```
  @pragma('vm:entry-point')
  static Future<void> onBackgroundMessageReceived(RemoteMessage message) async {
    await storeNotification(message);
  }

  ///Must be overriden in another class when UI is available to
  ///make something with the notification
  ///
  static Future<void> onForegroundMessage(RemoteMessage message) async {
    await storeNotification(message);

    //Show some alert or notification content
  }
}

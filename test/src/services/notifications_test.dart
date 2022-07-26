import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:churchdata_core/churchdata_core.dart';
import 'package:churchdata_core_mocks/churchdata_core.dart';
import 'package:churchdata_core_mocks/churchdata_core.mocks.dart';
import 'package:churchdata_core_mocks/fakes/fake_cache_repo.dart';
import 'package:churchdata_core_mocks/fakes/fake_functions_repo.dart';
import 'package:churchdata_core_mocks/fakes/fake_notifications_repo.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart' hide Notification;

void main() {
  group(
    'Notifications Service tests ->',
    () {
      setUp(
        () async {
          GetIt.I.pushNewScope(scopeName: 'NotificationsTestsScope');
          registerFirebaseMocks();

          GetIt.I.registerSingleton<CacheRepository>(FakeCacheRepo());
          GetIt.I.registerSingleton<NotificationsService>(
            FakeNotificationsService(),
            signalsReady: true,
            dispose: (n) => n.dispose(),
          );
        },
      );

      tearDown(
        () async {
          await GetIt.I.reset();
        },
      );

      test(
        'On Background Message Received',
        () async {
          final time = DateTime.now();
          final remoteMessage = RemoteMessage(
            category: 'category',
            messageId: 'id',
            notification:
                const RemoteNotification(body: 'body', title: 'title'),
            sentTime: time,
            data: {
              'senderUID': 'senderUID',
              'attachment': 'attachment',
              'additional': {'ddd': 'cccc'},
            },
          );

          await NotificationsService.onBackgroundMessageReceived(
            remoteMessage,
          );

          expect(GetIt.I<CacheRepository>().box('Notifications').get(0),
              Notification.fromRemoteMessage(remoteMessage));
        },
      );

      test(
        'On Foreground Message Received',
        () async {
          final time = DateTime.now();
          final remoteMessage = RemoteMessage(
            category: 'category',
            messageId: 'id',
            notification:
                const RemoteNotification(body: 'body', title: 'title'),
            data: {
              'senderUID': 'senderUID',
              'attachment': 'attachment',
              'additional': {'ddd': 'cccc'},
            },
            sentTime: time,
          );

          await NotificationsService.onForegroundMessage(
            remoteMessage,
          );

          expect(GetIt.I<CacheRepository>().box('Notifications').get(0),
              Notification.fromRemoteMessage(remoteMessage));
          expect(GetIt.I<CacheRepository>().isBoxOpen('Notifications'), isTrue);
        },
      );

      group(
        'Show Notification Contents ->',
        () {
          setUp(
            () async {
              GetIt.I
                  .registerSingleton<DatabaseRepository>(DatabaseRepository());
              await initializeDateFormatting('ar-EG');
            },
          );

          testWidgets(
            'Without attachment or senderUID',
            (tester) async {
              final key = GlobalKey<NavigatorState>();

              await tester.pumpWidget(
                MaterialApp(
                  navigatorKey: key,
                  routes: {
                    '/': (context) => const Scaffold(
                          body: Text('Root'),
                        ),
                  },
                ),
              );

              final time = DateTime.now();
              final remoteNotification = Notification.fromRemoteMessage(
                RemoteMessage(
                  category: 'category',
                  messageId: 'id',
                  notification:
                      const RemoteNotification(body: 'body', title: 'title'),
                  sentTime: time,
                ),
              );

              unawaited(GetIt.I<NotificationsService>()
                  .showNotificationContents(
                      key.currentContext!, remoteNotification));

              await tester.pumpAndSettle();

              expect(find.text(remoteNotification.title), findsOneWidget);
              expect(find.text(remoteNotification.body), findsOneWidget);
              expect(
                find.text(DateFormat('yyyy/M/d h:m a', 'ar-EG').format(time)),
                findsOneWidget,
              );
            },
            tags: ['uses_widgets_tester'],
          );

          testWidgets(
            'With data attachment',
            (tester) async {
              final person = PersonBase(
                  ref: GetIt.I<DatabaseRepository>()
                      .collection('Persons')
                      .doc('id'),
                  name: 'Person');
              await person.set();

              final key = GlobalKey<NavigatorState>();

              await tester.pumpWidget(
                MaterialApp(
                  navigatorKey: key,
                  routes: {
                    '/': (context) => const Scaffold(
                          body: Text('Root'),
                        ),
                  },
                ),
              );

              final time = DateTime.now();
              final remoteNotification = Notification.fromRemoteMessage(
                RemoteMessage(
                  category: 'category',
                  messageId: 'id',
                  notification:
                      const RemoteNotification(body: 'body', title: 'title'),
                  sentTime: time,
                  data: {
                    'attachment':
                        'https://churchdata.page.link/PersonInfo?Id=id'
                  },
                ),
              );

              unawaited(GetIt.I<NotificationsService>()
                  .showNotificationContents(
                      key.currentContext!, remoteNotification));

              await tester.pumpAndSettle();

              expect(find.text(remoteNotification.title), findsOneWidget);
              expect(find.text(person.name), findsOneWidget);
              expect(
                  find.byType(ViewableObjectWidget<Viewable>), findsOneWidget);
              expect(find.text(remoteNotification.body), findsOneWidget);
              expect(
                find.text(DateFormat('yyyy/M/d h:m a', 'ar-EG').format(time)),
                findsOneWidget,
              );
            },
            tags: ['uses_widgets_tester'],
          );

          testWidgets(
            'With image attachment',
            (tester) async {
              const imageLink =
                  'https://raw.githubusercontent.com/Andrew-Bekhiet'
                  '/ChurchData/master/android/app/src'
                  '/main/res/mipmap-xhdpi/ic_launcher.png';

              final key = GlobalKey<NavigatorState>();

              await tester.pumpWidget(
                MaterialApp(
                  navigatorKey: key,
                  routes: {
                    '/': (context) => const Scaffold(
                          body: Text('Root'),
                        ),
                  },
                ),
              );

              final time = DateTime.now();
              final remoteNotification = Notification.fromRemoteMessage(
                RemoteMessage(
                  category: 'category',
                  messageId: 'id',
                  notification:
                      const RemoteNotification(body: 'body', title: 'title'),
                  sentTime: time,
                  data: {'attachment': imageLink},
                ),
              );

              unawaited(GetIt.I<NotificationsService>()
                  .showNotificationContents(
                      key.currentContext!, remoteNotification));

              await tester.pumpAndSettle();

              expect(find.text(remoteNotification.title), findsOneWidget);
              expect(find.byType(CachedNetworkImage), findsOneWidget);
              expect(find.text(remoteNotification.body), findsOneWidget);
              expect(
                find.text(DateFormat('yyyy/M/d h:m a', 'ar-EG').format(time)),
                findsOneWidget,
              );
            },
            tags: ['uses_widgets_tester'],
          );

          testWidgets(
            'With senderUID',
            (tester) async {
              const uid = 'uid';
              final person = PersonBase(
                  ref: GetIt.I<DatabaseRepository>()
                      .collection('Persons')
                      .doc('id'),
                  name: 'Person');
              await person.ref.set({...person.toJson(), 'UID': uid});

              final key = GlobalKey<NavigatorState>();

              await tester.pumpWidget(
                MaterialApp(
                  navigatorKey: key,
                  routes: {
                    '/': (context) => const Scaffold(
                          body: Text('Root'),
                        ),
                  },
                ),
              );

              final time = DateTime.now();
              final remoteNotification = Notification.fromRemoteMessage(
                RemoteMessage(
                  category: 'category',
                  messageId: 'id',
                  notification:
                      const RemoteNotification(body: 'body', title: 'title'),
                  sentTime: time,
                  data: {'senderUID': uid},
                ),
              );

              unawaited(GetIt.I<NotificationsService>()
                  .showNotificationContents(
                      key.currentContext!, remoteNotification));

              await tester.pumpAndSettle();

              expect(find.text(remoteNotification.title), findsOneWidget);
              expect(find.text('من: ' + person.name), findsOneWidget);
              expect(find.text(remoteNotification.body), findsOneWidget);
              expect(
                find.text(DateFormat('yyyy/M/d h:m a', 'ar-EG').format(time)),
                findsOneWidget,
              );
            },
            tags: ['uses_widgets_tester'],
          );
        },
      );

      group(
        'Initial notification',
        () {
          test(
            'Firebase messaging',
            () async {
              final time = DateTime.now();
              final message = RemoteMessage(
                category: 'category',
                messageId: 'id',
                notification:
                    const RemoteNotification(body: 'body', title: 'title'),
                sentTime: time,
                data: {'senderUID': 'uid'},
              );

              when((GetIt.I<FirebaseMessaging>() as MockFirebaseMessaging)
                      .getInitialMessage())
                  .thenAnswer(
                (_) async => message,
              );

              expect(
                  await GetIt.I<NotificationsService>()
                      .getInitialNotification(),
                  Notification.fromRemoteMessage(message));
            },
          );

          test(
            'Local notification',
            () async {
              final time = DateTime.now();
              final notification = Notification.fromRemoteMessage(
                RemoteMessage(
                  category: 'category',
                  messageId: 'NotificationId',
                  notification:
                      const RemoteNotification(body: 'body', title: 'title'),
                  sentTime: time,
                  data: {'senderUID': 'uid'},
                ),
              );

              await GetIt.I<CacheRepository>()
                  .openBox<Notification>('Notifications');
              await GetIt.I<CacheRepository>()
                  .box<Notification>('Notifications')
                  .put(
                    'NotificationId',
                    notification,
                  );
              when((GetIt.I<FirebaseMessaging>() as MockFirebaseMessaging)
                      .getInitialMessage())
                  .thenAnswer(
                (_) async => null,
              );

              expect(
                await GetIt.I<NotificationsService>().getInitialNotification(),
                notification,
              );
            },
          );

          group(
            'Registering FCM Token',
            () {
              setUp(
                () async {
                  await GetIt.I<CacheRepository>().openBox('User');
                  await GetIt.I<CacheRepository>().openBox('Settings');

                  GetIt.I.pushNewScope(
                    scopeName: 'RegisteringFCMTokenScope',
                    init: (i) => i
                      ..registerSingleton<FunctionsService>(FunctionsService())
                      ..registerSingleton<FirebaseFunctions>(
                          MockFirebaseFunctions())
                      ..registerSingleton<NotificationsService>(
                        NotificationsService(),
                        signalsReady: true,
                        dispose: (n) => n.dispose(),
                      )
                      ..registerSingleton<AuthRepository>(
                        FakeAuthRepo(),
                        signalsReady: true,
                        dispose: (a) => a.dispose(),
                      ),
                  );

                  final fakeHttpsCallable = FakeHttpsCallable();
                  when(fakeHttpsCallable(any))
                      .thenAnswer((_) async => FakeHttpsCallableResult());
                  when((GetIt.I<FirebaseFunctions>() as MockFirebaseFunctions)
                          .httpsCallable('registerFCMToken'))
                      .thenReturn(fakeHttpsCallable);

                  when(fakeHttpsCallable(any))
                      .thenAnswer((_) async => FakeHttpsCallableResult());

                  when((GetIt.I<FirebaseMessaging>() as MockFirebaseMessaging)
                          .isSupported())
                      .thenAnswer((_) async => true);
                  when((GetIt.I<FirebaseMessaging>() as MockFirebaseMessaging)
                          .requestPermission())
                      .thenAnswer(
                    (_) async => const NotificationSettings(
                      criticalAlert: AppleNotificationSetting.enabled,
                      alert: AppleNotificationSetting.enabled,
                      announcement: AppleNotificationSetting.enabled,
                      badge: AppleNotificationSetting.enabled,
                      carPlay: AppleNotificationSetting.enabled,
                      lockScreen: AppleNotificationSetting.enabled,
                      notificationCenter: AppleNotificationSetting.enabled,
                      showPreviews: AppleShowPreviewSetting.whenAuthenticated,
                      sound: AppleNotificationSetting.enabled,
                      authorizationStatus: AuthorizationStatus.authorized,
                      timeSensitive: AppleNotificationSetting.disabled,
                    ),
                  );
                  when((GetIt.I<FirebaseMessaging>() as MockFirebaseMessaging)
                          .getToken())
                      .thenAnswer((_) async => 'FCM-Token');
                  when((GetIt.I<FirebaseMessaging>() as MockFirebaseMessaging)
                          .onTokenRefresh)
                      .thenAnswer((_) => Stream.value('FCM-Token'));
                },
              );

              tearDown(() async {
                await GetIt.I.reset();
              });

              test(
                'Normal',
                () async {
                  expect(
                    GetIt.I<NotificationsService>().onFCMTokenRefresh,
                    isNull,
                  );

                  expect(
                    await GetIt.I<NotificationsService>().registerFCMToken(),
                    isTrue,
                  );

                  //Don't inline
                  final rslt =
                      (GetIt.I<FirebaseFunctions>() as MockFirebaseFunctions)
                          .httpsCallable('registerFCMToken');
                  verify(
                    rslt(
                      argThat(
                        predicate<Map>((a) => a['token'] == 'FCM-Token'),
                      ),
                    ),
                  );
                  expect(
                      GetIt.I<CacheRepository>()
                          .box('Settings')
                          .get('Registered_FCM_Token'),
                      'FCM-Token');
                  expect(
                    GetIt.I<NotificationsService>().onFCMTokenRefresh,
                    isNotNull,
                  );
                },
              );
              test(
                'onFCMTokenRefresh',
                () async {
                  final stream = BehaviorSubject<String>();

                  addTearDown(stream.close);

                  when((GetIt.I<FirebaseMessaging>() as MockFirebaseMessaging)
                          .onTokenRefresh)
                      .thenAnswer((_) => stream.stream);

                  expect(
                    GetIt.I<NotificationsService>().onFCMTokenRefresh,
                    isNull,
                  );

                  expect(
                    await GetIt.I<NotificationsService>().registerFCMToken(),
                    isTrue,
                  );
                  expect(
                    GetIt.I<NotificationsService>().onFCMTokenRefresh,
                    isNotNull,
                  );

                  stream.add('FCM-Token-Changed!');
                  await stream.next;
                  await stream.next;

                  expect(
                      GetIt.I<CacheRepository>()
                          .box('Settings')
                          .get('Registered_FCM_Token'),
                      'FCM-Token-Changed!');

                  final rslt =
                      (GetIt.I<FirebaseFunctions>() as MockFirebaseFunctions)
                          .httpsCallable('registerFCMToken');
                  verify(
                    rslt(
                      argThat(
                        predicate<Map>(
                            (a) => a['token'] == 'FCM-Token-Changed!'),
                      ),
                    ),
                  );
                },
              );
              test(
                'Permission denied',
                () async {
                  when((GetIt.I<FirebaseMessaging>() as MockFirebaseMessaging)
                          .requestPermission())
                      .thenAnswer(
                    (_) async => const NotificationSettings(
                      criticalAlert: AppleNotificationSetting.enabled,
                      alert: AppleNotificationSetting.enabled,
                      announcement: AppleNotificationSetting.enabled,
                      badge: AppleNotificationSetting.enabled,
                      carPlay: AppleNotificationSetting.enabled,
                      lockScreen: AppleNotificationSetting.enabled,
                      notificationCenter: AppleNotificationSetting.enabled,
                      showPreviews: AppleShowPreviewSetting.whenAuthenticated,
                      sound: AppleNotificationSetting.enabled,
                      authorizationStatus: AuthorizationStatus.denied,
                      timeSensitive: AppleNotificationSetting.disabled,
                    ),
                  );

                  expect(
                    await GetIt.I<NotificationsService>().registerFCMToken(),
                    isFalse,
                  );
                },
              );
              test(
                'Unsupported device',
                () async {
                  when((GetIt.I<FirebaseMessaging>() as MockFirebaseMessaging)
                          .isSupported())
                      .thenAnswer((_) async => false);

                  expect(
                    await GetIt.I<NotificationsService>().registerFCMToken(),
                    isFalse,
                  );
                },
              );
            },
          );
        },
      );
    },
  );
}

class FakeAuthRepo extends AuthRepository {
  @override
  UserBase? get currentUser => UserBase(uid: 'uid', name: 'name');
}

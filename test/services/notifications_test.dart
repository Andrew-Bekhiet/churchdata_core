import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:churchdata_core/churchdata_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';

import '../churchdata_core.dart';
import '../churchdata_core.mocks.dart';
import '../fakes/fake_cache_repo.dart';
import '../fakes/fake_notifications_repo.dart';

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
              FakeNotificationsService());
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
                        'https://churchdata.page.link/viewPerson?PersonId=id'
                  },
                ),
              );

              unawaited(GetIt.I<NotificationsService>()
                  .showNotificationContents(
                      key.currentContext!, remoteNotification));

              await tester.pumpAndSettle();

              expect(find.text(remoteNotification.title), findsOneWidget);
              expect(find.text(person.name), findsOneWidget);
              expect(find.byType(DataObjectWidget<DataObject>), findsOneWidget);
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

      test(
        'Initial message',
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

          expect(await GetIt.I<NotificationsService>().getInitialNotification(),
              Notification.fromRemoteMessage(message));
        },
      );
    },
  );
}

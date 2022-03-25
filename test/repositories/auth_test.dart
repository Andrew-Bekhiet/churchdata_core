import 'package:churchdata_core/churchdata_core.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import '../churchdata_core.dart';
import '../fakes/fake_cache_repo.dart';
import '../fakes/fake_firebase_auth.dart';
import '../fakes/fake_notifications_repo.dart';
import '../fakes/mock_user.dart';

void main() async {
  group(
    'Auth repository tests ->',
    () {
      setUp(() async {
        GetIt.I.pushNewScope(scopeName: 'AuthTestsScope');
        GetIt.I.registerSingleton<CacheRepository>(
          FakeCacheRepo(),
          dispose: (r) => r.dispose(),
        );

        GetIt.I.registerSingleton<NotificationsService>(
          MockNotificationsService(),
          signalsReady: true,
        );

        // when(
        //   (GetIt.I<NotificationsService>() as MockNotificationsService)
        //       .registerFCMToken(
        //     cachedToken: anyNamed('cachedToken'),
        //   ),
        // ).thenAnswer((_) async => true);

        await GetIt.I<CacheRepository>().openBox('User');

        registerFirebaseMocks();

        GetIt.I.registerSingleton(DatabaseRepository());

        GetIt.I.registerSingleton<AuthRepository>(
          AuthRepository(),
          dispose: (r) => r.dispose(),
          signalsReady: true,
        );
      });

      tearDown(() async {
        await GetIt.I<FirebaseDatabase>().ref().set(<String, dynamic>{});
        await GetIt.I.reset();
      });

      group(
        'Initialization ->',
        () {
          test(
            'No signed in user',
            () async {
              expect(GetIt.I.isReadySync<AuthRepository>(), isFalse);

              (GetIt.I<FirebaseAuth>() as MockFirebaseAuth)
                  .userChangedStreamController
                  .add(null);

              await GetIt.I<AuthRepository>().userStream.next;

              expect(GetIt.I.isReadySync<AuthRepository>(), isTrue);
            },
          );
          test(
            'Signed in user',
            () async {
              final mockUser = MyMockUser(
                  uid: 'uid',
                  displayName: 'User Name',
                  email: 'email@email.com',
                  phoneNumber: '+201234567890');

              when(mockUser.getIdTokenResult()).thenAnswer(
                (_) async => IdTokenResult(
                  {
                    'claims': {'personId': null},
                  },
                ),
              );

              GetIt.I.pushNewScope(
                init: (i) {
                  i
                    ..registerSingleton<FirebaseAuth>(
                      MockFirebaseAuth(mockUser: mockUser),
                    )
                    ..registerSingleton<AuthRepository>(
                      AuthRepository(),
                      dispose: (r) => r.dispose(),
                      signalsReady: true,
                    );
                },
              );

              await GetIt.I<AuthRepository>().userStream.next;

              expect(GetIt.I.isReadySync<AuthRepository>(), isTrue);
            },
          );
          test(
            'Loads user from cache first',
            () async {
              MyMockUser mockUser = MyMockUser(
                  uid: 'uid',
                  displayName: 'User Name',
                  email: 'email@email.com',
                  phoneNumber: '+201234567890');

              when(mockUser.getIdTokenResult()).thenAnswer(
                (_) async => IdTokenResult(
                  {
                    'claims': {'personId': null},
                  },
                ),
              );

              await GetIt.I<CacheRepository>().box('User').putAll({
                'name': 'stale name',
                'email': 'stale email',
                'phone': 'stale phone',
                'sub': 'uid',
                'claims': {'personId': null},
              });

              GetIt.I.pushNewScope(
                init: (i) {
                  i
                    ..registerSingleton<FirebaseAuth>(
                      MockFirebaseAuth(mockUser: mockUser),
                    )
                    ..registerSingleton<AuthRepository>(
                      AuthRepository(),
                      dispose: (r) => r.dispose(),
                      signalsReady: true,
                    );
                },
              );

              expect(
                GetIt.I<AuthRepository>().userStream,
                emitsInOrder(
                  [
                    allOf(
                      isNotNull,
                      predicate<UserBase>((u) => u.email == 'stale email'),
                      predicate<UserBase>((u) => u.name == 'stale name'),
                      predicate<UserBase>((u) => u.phone == 'stale phone'),
                      predicate<UserBase>((u) => u.uid == 'uid'),
                    ),
                    allOf(
                      predicate<UserBase>(
                          (u) => u.name == mockUser.displayName),
                      predicate<UserBase>((u) => u.email == mockUser.email),
                      predicate<UserBase>(
                          (u) => u.phone == mockUser.phoneNumber),
                      predicate<UserBase>((u) => u.uid == mockUser.uid),
                    ),
                  ],
                ),
              );

              mockUser = MyMockUser(
                  displayName: mockUser.displayName,
                  email: mockUser.email,
                  phoneNumber: mockUser.phoneNumber,
                  uid: mockUser.uid,
                  refreshToken: 'rrr');
              when(mockUser.getIdTokenResult()).thenAnswer(
                (_) async => IdTokenResult(
                  {
                    'claims': {'personId': null},
                  },
                ),
              );

              (GetIt.I<FirebaseAuth>() as MockFirebaseAuth)
                  .userChangedStreamController
                  .add(mockUser);
            },
          );
        },
      );

      test(
        'Sign in user data',
        () async {
          final personRef = GetIt.I<DatabaseRepository>()
              .collection('Persons')
              .doc('this_is_person_id');

          await PersonBase(ref: personRef, name: 'Person').set();

          addTearDown(() async {
            await GetIt.I.resetScope();
            await personRef.delete();
          });

          const uid = 'this_is_user_uid';
          final mockUser = MyMockUser(
              uid: uid,
              displayName: 'User Name',
              email: 'email@email.com',
              phoneNumber: '+201234567890');

          when(mockUser.getIdTokenResult()).thenAnswer(
            (_) async => IdTokenResult(
              {
                'claims': {'personId': personRef.id},
              },
            ),
          );

          GetIt.I.pushNewScope(
            init: (i) {
              i
                ..registerSingleton<FirebaseAuth>(
                  MockFirebaseAuth(mockUser: mockUser),
                )
                ..registerSingleton<AuthRepository>(
                  AuthRepository(),
                  dispose: (r) => r.dispose(),
                  signalsReady: true,
                );
            },
          );

          await GetIt.I.isReady<AuthRepository>();

          expect(
            GetIt.I<CacheRepository>().box('User').toMap(),
            {
              'personId': personRef.id,
            },
          );

          expect(GetIt.I<AuthRepository>().currentUserData?.ref, personRef);
          expect(GetIt.I<AuthRepository>().currentUserData?.name, 'Person');

          expect(GetIt.I<AuthRepository>().currentUser?.uid, mockUser.uid);

          expect(
            (await GetIt.I<FirebaseDatabase>()
                    .ref()
                    .child('Users/$uid/forceRefresh')
                    .once())
                .snapshot
                .value,
            isFalse,
          );

          expect(
            GetIt.I<AuthRepository>().currentUser,
            allOf(
              isNotNull,
              predicate<UserBase>((u) => u.name == mockUser.displayName),
              predicate<UserBase>((u) => u.email == mockUser.email),
              predicate<UserBase>((u) => u.phone == mockUser.phoneNumber),
            ),
          );
        },
      );

      test(
        'Sign out',
        () async {
          const uid = 'this_is_user_uid';
          final mockUser = MyMockUser(
              uid: uid,
              displayName: 'User Name',
              email: 'email@email.com',
              phoneNumber: '+201234567890');

          when(mockUser.getIdTokenResult()).thenAnswer(
            (_) async => IdTokenResult(
              {
                'claims': {'personId': null},
              },
            ),
          );

          GetIt.I.pushNewScope(
            init: (i) {
              i
                ..registerSingleton<FirebaseAuth>(
                  MockFirebaseAuth(mockUser: mockUser),
                )
                ..registerSingleton<AuthRepository>(
                  AuthRepository(),
                  dispose: (r) => r.dispose(),
                  signalsReady: true,
                );
            },
          );

          await GetIt.I.isReady<AuthRepository>();

          await GetIt.I<AuthRepository>().signOut();

          expect(
            GetIt.I<CacheRepository>().box('User').toMap(),
            {},
          );

          expect(GetIt.I<AuthRepository>().currentUserData, isNull);
          expect(GetIt.I<AuthRepository>().currentUser, isNull);

          final lastSeen = (await GetIt.I<FirebaseDatabase>()
                  .ref()
                  .child('Users/$uid/lastSeen')
                  .once())
              .snapshot
              .value;

          expect(lastSeen, isNotNull);
          expect(lastSeen, const TypeMatcher<int>());
          expect(
            lastSeen! as int < DateTime.now().millisecondsSinceEpoch &&
                lastSeen as int >=
                    DateTime.now().millisecondsSinceEpoch - 10000,
            isTrue,
          );
        },
      );

      group(
        'Activity status ->',
        () {
          test(
            'Active',
            () async {
              const uid = 'this_is_user_uid';
              final mockUser = MyMockUser(
                uid: uid,
                displayName: 'User Name',
                email: 'email@email.com',
                phoneNumber: '+201234567890',
              );

              when(mockUser.getIdTokenResult()).thenAnswer(
                (_) async => IdTokenResult(
                  {
                    'claims': {'personId': null},
                  },
                ),
              );

              GetIt.I.pushNewScope(
                init: (i) {
                  i
                    ..registerSingleton<FirebaseAuth>(
                      MockFirebaseAuth(mockUser: mockUser),
                    )
                    ..registerSingleton<AuthRepository>(
                      AuthRepository(),
                      dispose: (r) => r.dispose(),
                      signalsReady: true,
                    );
                },
              );

              await GetIt.I.isReady<AuthRepository>();

              await GetIt.I<AuthRepository>().recordActive();

              final lastSeen = (await GetIt.I<FirebaseDatabase>()
                      .ref()
                      .child('Users/$uid/lastSeen')
                      .once())
                  .snapshot
                  .value;

              expect(lastSeen, 'Active');
            },
          );

          test(
            'Inactive',
            () async {
              const uid = 'this_is_user_uid';
              final mockUser = MyMockUser(
                uid: uid,
                displayName: 'User Name',
                email: 'email@email.com',
                phoneNumber: '+201234567890',
              );

              when(mockUser.getIdTokenResult()).thenAnswer(
                (_) async => IdTokenResult(
                  {
                    'claims': {'personId': null},
                  },
                ),
              );

              GetIt.I.pushNewScope(
                init: (i) {
                  i
                    ..registerSingleton<FirebaseAuth>(
                      MockFirebaseAuth(mockUser: mockUser),
                    )
                    ..registerSingleton<AuthRepository>(
                      AuthRepository(),
                      dispose: (r) => r.dispose(),
                      signalsReady: true,
                    );
                },
              );

              await GetIt.I.isReady<AuthRepository>();

              await GetIt.I<AuthRepository>().recordLastSeen();

              final lastSeen = (await GetIt.I<FirebaseDatabase>()
                      .ref()
                      .child('Users/$uid/lastSeen')
                      .once())
                  .snapshot
                  .value;

              expect(lastSeen, isNotNull);
              expect(lastSeen, const TypeMatcher<int>());
              expect(
                lastSeen! as int <= DateTime.now().millisecondsSinceEpoch &&
                    lastSeen as int >=
                        DateTime.now().millisecondsSinceEpoch - 10000,
                isTrue,
              );
            },
          );
        },
      );
    },
  );
}

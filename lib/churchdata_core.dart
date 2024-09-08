library churchdata_core;

import 'dart:convert';

import 'package:churchdata_core/churchdata_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

export 'src/controllers.dart';
export 'src/models.dart';
export 'src/repositories.dart';
export 'src/services.dart';
export 'src/typedefs.dart';
export 'src/utils.dart';
export 'src/widgets.dart';

// coverage:ignore-file

///Registers `GetIt` singleton instances for the repositories
///
///Don't forget to register `DefaultViewableObjectTapHandler` as
///soon as the app builds the navigator
///
///Use [overrides] to override repository and/or services to
///your implementations as follows:
///
///```dart
/// await init(
///    sentryDSN: sentryDSN,
///    overrides: {
///      LoggingService: () => LoggingService(additionalArgs),
///      AuthRepository: AuthRepositoryImpl.new,
///    },
///  );
///
/// await init(
///    sentryDSN: sentryDSN,
///    overrides: {
///      AuthRepository: () {
///        final instance = AuthRepositoryImpl();
///
///        GetIt.I.registerSingleton<AuthRepositoryImpl>(instance);
///
///        return instance;
///      },
///    },
///  );
/// ```
Future<void> initCore({
  required String sentryDSN,
  HiveCipher? userBoxCipher,
  Map<Type, dynamic Function()> overrides = const {},
}) async {
  final loggingService =
      overrides[LoggingService]?.call() ?? LoggingService(sentryDSN);

  GetIt.I.registerSingleton<LoggingService>(
    loggingService,
    signalsReady: loggingService.runtimeType == LoggingService,
  );

  final cacheRepository =
      overrides[CacheRepository]?.call() ?? CacheRepository();
  GetIt.I.registerSingleton<CacheRepository>(
    cacheRepository,
    signalsReady: cacheRepository.runtimeType == CacheRepository,
    dispose: (r) => r.dispose(),
  );

  await GetIt.I.isReady(instance: cacheRepository);

  if (userBoxCipher == null) {
    const secureStorage = FlutterSecureStorage();
    final containsEncryptionKey = await secureStorage.containsKey(key: 'key');
    if (!containsEncryptionKey)
      await secureStorage.write(
        key: 'key',
        value: base64Url.encode(
          GetIt.I<CacheRepository>().generateSecureKey(),
        ),
      );
    final encryptionKey = base64Url.decode(
      (await secureStorage.read(key: 'key'))!,
    );
    userBoxCipher = HiveAesCipher(encryptionKey);
  }

  await GetIt.I<CacheRepository>().openBox(
    'User',
    encryptionCipher: userBoxCipher,
  );

  final localNotificationsPlugin =
      overrides[FlutterLocalNotificationsPlugin]?.call() ??
          FlutterLocalNotificationsPlugin();
  GetIt.I.registerSingleton<FlutterLocalNotificationsPlugin>(
    localNotificationsPlugin,
  );

  await Future.wait(
    [
      GetIt.I<CacheRepository>().openBox('Settings'),
      GetIt.I<CacheRepository>().openBox<bool>('FeatureDiscovery'),
      GetIt.I<CacheRepository>()
          .openBox<NotificationSetting>('NotificationsSettings'),
      GetIt.I<CacheRepository>().openBox<String?>('PhotosURLsCache'),
      GetIt.I<CacheRepository>().openBox<Notification>('Notifications'),
    ],
  );

  final databaseRepository =
      overrides[DatabaseRepository]?.call() ?? DatabaseRepository();
  GetIt.I.registerSingleton<DatabaseRepository>(
    databaseRepository,
  );

  final storageRepository =
      overrides[StorageRepository]?.call() ?? StorageRepository();
  GetIt.I.registerSingleton<StorageRepository>(storageRepository);

  final authRepository = overrides[AuthRepository]?.call() ?? AuthRepository();
  GetIt.I.registerSingleton<AuthRepository>(
    authRepository,
    dispose: (r) => r.dispose(),
    signalsReady: authRepository.runtimeType == AuthRepository,
  );

  final notificationsService =
      overrides[NotificationsService]?.call() ?? NotificationsService();
  GetIt.I.registerSingleton<NotificationsService>(
    notificationsService,
    signalsReady: notificationsService.runtimeType == NotificationsService,
    dispose: (n) => n.dispose(),
  );

  final functionsService =
      overrides[FunctionsService]?.call() ?? FunctionsService();
  GetIt.I.registerSingleton<FunctionsService>(
    functionsService,
  );

  final launcherService =
      overrides[LauncherService]?.call() ?? LauncherService();
  GetIt.I.registerSingleton<LauncherService>(
    launcherService,
  );

  //Optional Services:

  final shareService = overrides[ShareService]?.call();
  if (shareService != null)
    GetIt.I.registerSingleton<ShareService>(
      shareService,
    );

  final themingService = overrides[ThemingService]?.call();
  if (themingService != null)
    GetIt.I.registerSingleton<ThemingService>(
      themingService,
    );

  final updatesService = overrides[UpdatesService]?.call();
  if (updatesService != null)
    GetIt.I.registerSingleton<UpdatesService>(
      updatesService,
      dispose: (u) => u.dispose(),
      signalsReady: true,
    );

  await Future.wait([
    GetIt.I.isReady(instance: loggingService),
    GetIt.I.isReady(instance: authRepository),
    GetIt.I.isReady(instance: notificationsService),
  ]);

  if ((authRepository as AuthRepository).isSignedIn) {
    final currentUser = authRepository.currentUser;
    (loggingService as LoggingService).configureScope(
      (scope) => scope.setUser(
        currentUser != null
            ? SentryUser(
                id: currentUser.uid,
                email: currentUser is UserBase ? currentUser.email : null,
                data: currentUser is UserBase
                    ? currentUser.toJson().map(
                          (key, value) => MapEntry(
                            key,
                            value is Set ? value.toList() : value,
                          ),
                        )
                    : null,
              )
            : null,
      ),
    );
  }
}

void registerFirebaseDependencies({
  GoogleSignIn? googleSignInOverride,
  FirebaseFirestore? firebaseFirestoreOverride,
  FirebaseStorage? firebaseStorageOverride,
  FirebaseAuth? firebaseAuthOverride,
  FirebaseDatabase? firebaseDatabaseOverride,
  FirebaseDynamicLinks? firebaseDynamicLinksOverride,
  FirebaseFunctions? firebaseFunctionsOverride,
  FirebaseMessaging? firebaseMessagingOverride,
  FirebaseRemoteConfig? firebaseRemoteConfigOverride,
}) {
  GetIt.I.registerSingleton<GoogleSignIn>(
    googleSignInOverride ?? GoogleSignIn(),
  );
  GetIt.I.registerSingleton<FirebaseAuth>(
    firebaseAuthOverride ?? FirebaseAuth.instance,
  );
  GetIt.I.registerSingleton<FirebaseDatabase>(
    firebaseDatabaseOverride ?? FirebaseDatabase.instance,
  );
  GetIt.I.registerSingleton<FirebaseFirestore>(
    firebaseFirestoreOverride ?? FirebaseFirestore.instance,
  );
  GetIt.I.registerSingleton<FirebaseStorage>(
    firebaseStorageOverride ?? FirebaseStorage.instance,
  );
  GetIt.I.registerSingleton<FirebaseFunctions>(
    firebaseFunctionsOverride ?? FirebaseFunctions.instance,
  );
  GetIt.I.registerSingleton<FirebaseMessaging>(
    firebaseMessagingOverride ?? FirebaseMessaging.instance,
  );
  GetIt.I.registerSingleton<FirebaseDynamicLinks>(
    firebaseDynamicLinksOverride ?? FirebaseDynamicLinks.instance,
  );
  GetIt.I.registerSingleton<FirebaseRemoteConfig>(
    firebaseRemoteConfigOverride ?? FirebaseRemoteConfig.instance,
  );
}

library churchdata_core;

import 'dart:convert';

import 'package:churchdata_core/churchdata_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

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
///Don't forget to register `DefaultDataObjectTapHandler` as
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
Future<void> init({
  required String sentryDSN,
  Map<Type, dynamic Function()> overrides = const {},
}) async {
  final loggingService =
      overrides[LoggingService]?.call() ?? LoggingService(sentryDSN);

  GetIt.I.registerSingleton<LoggingService>(
    loggingService,
    signalsReady: true,
  );

  final cacheRepository =
      overrides[CacheRepository]?.call() ?? CacheRepository();
  GetIt.I.registerSingleton<CacheRepository>(
    cacheRepository,
    signalsReady: true,
    dispose: (r) => r.dispose(),
  );

  await GetIt.I.isReady<CacheRepository>(instance: cacheRepository);

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

  await GetIt.I<CacheRepository>().openBox(
    'User',
    encryptionCipher: HiveAesCipher(encryptionKey),
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
    signalsReady: true,
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

  final notificationsService =
      overrides[NotificationsService]?.call() ?? NotificationsService();
  GetIt.I.registerSingleton<NotificationsService>(
    notificationsService,
    signalsReady: true,
  );

  await Future.wait([
    GetIt.I.isReady<LoggingService>(instance: loggingService),
    GetIt.I.isReady<AuthRepository>(instance: authRepository),
    GetIt.I.isReady<NotificationsService>(instance: notificationsService),
  ]);
}

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
Future<void> init({required String sentryDSN}) async {
  GetIt.I.registerSingleton(LoggingService(sentryDSN));

  GetIt.I.registerSingleton<CacheRepository>(
    CacheRepository(),
    signalsReady: true,
    dispose: (r) => r.dispose(),
  );

  await GetIt.I.isReady<CacheRepository>();

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

  GetIt.I.registerSingleton(DatabaseRepository());
  GetIt.I.registerSingleton(StorageRepository());

  GetIt.I.registerSingleton<AuthRepository>(
    AuthRepository(),
    dispose: (r) => r.dispose(),
    signalsReady: true,
  );

  GetIt.I.registerSingleton(FunctionsService());
  GetIt.I.registerSingleton(LauncherService());
  GetIt.I.registerSingleton(
    NotificationsService(),
    signalsReady: true,
  );

  await Future.wait([
    GetIt.I.isReady<LoggingService>(),
    GetIt.I.isReady<AuthRepository>(),
    GetIt.I.isReady<NotificationsService>(),
  ]);
}

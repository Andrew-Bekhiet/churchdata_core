import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/annotations.dart';

import 'churchdata_core_test.mocks.dart';
import 'fakes/fake_firestore.dart';
import 'fakes/mock_google_sign_in.dart';
import 'fakes/mock_storage_reference.dart';

void main() {}

/* Future<void> initAll() async {
  GetIt.I.registerSingleton<CacheRepo>(
    FakeCacheRepo(),
    dispose: (r) => r.dispose(),
  );

  registerFirebaseMocks();

  GetIt.I.registerSingleton(DatabaseRepo());
  GetIt.I.registerSingleton(StorageRepo());

  await GetIt.I.isReady<DatabaseRepo>();
  GetIt.I.registerSingleton<AuthRepository>(
    AuthRepository(),
    dispose: (r) => r.dispose(),
    signalsReady: true,
  );

  await GetIt.I.isReady<AuthRepository>();
  GetIt.I.registerSingleton(const LoggingRepo());
  GetIt.I.registerSingleton(
    NotificationsRepo(),
    signalsReady: true,
  );
} */

@GenerateMocks([FirebaseFunctions, FirebaseMessaging, FirebaseDynamicLinks])
void registerFirebaseMocks() {
  GetIt.I.registerSingleton<GoogleSignIn>(MockGoogleSignIn());
  GetIt.I.registerSingleton<FirebaseFirestore>(FakeFirebaseFirestore());
  GetIt.I.registerSingleton<FirebaseStorage>(MockFirebaseStorage());
  GetIt.I.registerSingleton<FirebaseAuth>(MockFirebaseAuth());
  GetIt.I.registerSingleton<FirebaseDatabase>(MockFirebaseDatabase());
  GetIt.I.registerSingleton<FirebaseFunctions>(MockFirebaseFunctions());
  GetIt.I.registerSingleton<FirebaseMessaging>(MockFirebaseMessaging());
  GetIt.I.registerSingleton<FirebaseDynamicLinks>(MockFirebaseDynamicLinks());
}

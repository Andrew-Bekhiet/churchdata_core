import 'package:churchdata_core/churchdata_core.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mockito/annotations.dart';

import 'churchdata_core_test.mocks.dart';
import 'fakes/fake_firestore.dart';
import 'fakes/mock_google_sign_in.dart';
import 'fakes/mock_storage_reference.dart';

@GenerateMocks([FirebaseFunctions, FirebaseMessaging, FirebaseDynamicLinks])
void registerFirebaseMocks() {
  registerFirebaseDependencies(
    googleSignInOverride: MockGoogleSignIn(),
    firebaseFirestoreOverride: FakeFirebaseFirestore(),
    firebaseStorageOverride: MockFirebaseStorage(),
    firebaseAuthOverride: MockFirebaseAuth(),
    firebaseDatabaseOverride: MockFirebaseDatabase(),
    firebaseFunctionsOverride: MockFirebaseFunctions(),
    firebaseMessagingOverride: MockFirebaseMessaging(),
    firebaseDynamicLinksOverride: MockFirebaseDynamicLinks(),
  );
}

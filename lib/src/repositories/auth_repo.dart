import 'dart:async';

import 'package:churchdata_core/churchdata_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';

class AuthRepository<U extends UserBase, P extends PersonBase> {
  AuthRepository() {
    initListeners();
  }

  @protected
  final BehaviorSubject<U?> userSubject = BehaviorSubject<U?>();
  ValueStream<U?> get userStream => userSubject.shareValue();

  U? get currentUser => userSubject.valueOrNull;

  bool get isSignedIn => currentUser != null;

  @protected
  final BehaviorSubject<P?> userDataSubject = BehaviorSubject<P?>();
  ValueStream<P?> get userDataStream => userDataSubject.shareValue();

  P? get currentUserData => userDataSubject.valueOrNull;

  StreamSubscription<DatabaseEvent>? userTokenListener;
  StreamSubscription<DatabaseEvent>? connectionListener;
  StreamSubscription<P>? personListener;
  StreamSubscription<auth.User?>? authListener;

  bool _disposed = false;

  @protected
  @mustCallSuper
  void initListeners() async {
    unawaited(
      userSubject.next.then(signalReady),
    );

    if (GetIt.I<CacheRepository>().box('User').toMap().isNotEmpty) {
      refreshFromIdToken(
        GetIt.I<CacheRepository>().box('User').toMap().cast(),
        name: GetIt.I<CacheRepository>().box('User').get('name'),
        email: GetIt.I<CacheRepository>().box('User').get('email'),
        phone: GetIt.I<CacheRepository>().box('User').get('phone'),
        uid: GetIt.I<CacheRepository>().box('User').get('sub'),
      );
    }

    authListener = GetIt.I<auth.FirebaseAuth>().userChanges().distinct((o, n) {
      return o?.refreshToken == n?.refreshToken &&
          o?.uid == n?.uid &&
          o?.email == n?.email &&
          o?.phoneNumber == n?.phoneNumber &&
          o?.emailVerified == n?.emailVerified &&
          o?.displayName == n?.displayName &&
          o?.isAnonymous == n?.isAnonymous &&
          o?.metadata.creationTime == n?.metadata.creationTime &&
          o?.metadata.lastSignInTime == n?.metadata.lastSignInTime &&
          o?.photoURL == n?.photoURL &&
          o?.tenantId == n?.tenantId;
    }).listen(onUserChanged);
  }

  @protected
  void onUserChanged(auth.User? user) async {
    if (user != null) {
      await userTokenListener?.cancel();
      userTokenListener = GetIt.I<FirebaseDatabase>()
          .ref()
          .child('Users/${user.uid}/forceRefresh')
          .onValue
          .distinct(
        (o, n) {
          return o.snapshot.value == n.snapshot.value &&
              o.snapshot.key == n.snapshot.key &&
              o.snapshot.exists == n.snapshot.exists;
        },
      ).listen((e) async {
        if (e.snapshot.value != true) return;

        await refreshIdToken(user, true);
      });

      await refreshIdToken(user);

      await GetIt.I<NotificationsService>().registerFCMToken();
    } else if (currentUser != null) {
      await userTokenListener?.cancel();
    } else if (!_disposed && !GetIt.I.isReadySync(instance: this))
      userSubject.add(null);
  }

  @protected
  FutureOr<void> signalReady([U? user]) {
    if (!_disposed && !GetIt.I.isReadySync(instance: this))
      GetIt.I.signalReady(this);
  }

  @protected
  Future<void> refreshIdToken(auth.User firebaseUser,
      [bool force = false]) async {
    Json idTokenClaims;

    try {
      final auth.IdTokenResult idToken =
          await firebaseUser.getIdTokenResult(force);

      await GetIt.I<CacheRepository>().box('User').putAll(idToken.claims ?? {});

      await GetIt.I<FirebaseDatabase>()
          .ref()
          .child('Users/${firebaseUser.uid}/forceRefresh')
          .set(false);

      idTokenClaims = idToken.claims ?? {};
    } catch (e) {
      idTokenClaims = GetIt.I<CacheRepository>().box('User').toMap().cast();
      if (idTokenClaims.isEmpty) rethrow;
    }

    refreshFromIdToken(idTokenClaims, firebaseUser: firebaseUser);
  }

  @protected
  PermissionsSet permissionsFromIdToken(Json idTokenClaims) =>
      PermissionsSet.empty;

  @protected
  void refreshFromDoc(P userData) {
    userDataSubject.add(userData);
  }

  @protected

  ///Must be ovrerriden if using any type other than [UserBase] or [PersonBase]
  U refreshFromIdToken(
    Json idTokenClaims, {
    auth.User? firebaseUser,
    String? uid,
    String? name,
    String? email,
    String? phone,
  }) {
    final U user = UserBase(
      uid: firebaseUser?.uid ?? uid!,
      name: firebaseUser?.displayName ?? name ?? '',
      email: firebaseUser?.email ?? email,
      phone: firebaseUser?.phoneNumber ?? phone,
      permissions: permissionsFromIdToken(idTokenClaims),
    ) as U;

    if (idTokenClaims['personId'] != currentUserData?.ref.id) {
      personListener?.cancel();
      personListener = GetIt.I<DatabaseRepository>()
          .collection('Persons')
          .doc(idTokenClaims['personId'])
          .snapshots()
          .map(PersonBase.fromDoc as P Function(JsonDoc))
          .listen(refreshFromDoc);
    }

    connectionListener ??= GetIt.I<FirebaseDatabase>()
        .ref()
        .child('.info/connected')
        .onValue
        .distinct((o, n) {
      return o.snapshot.value == n.snapshot.value &&
          o.snapshot.key == n.snapshot.key &&
          o.snapshot.exists == n.snapshot.exists;
    }).listen(connectionChanged);

    userSubject.add(user);
    return user;
  }

  @protected
  @mustCallSuper
  bool connectionChanged(DatabaseEvent snapshot) {
    if (snapshot.snapshot.value == true) {
      scheduleOnDisconnect();

      GetIt.I<DatabaseRepository>().enableNetwork();

      recordActive();
    } else {
      GetIt.I<DatabaseRepository>().disableNetwork();
    }
    return snapshot.snapshot.value == true;
  }

  @protected
  void scheduleOnDisconnect() {
    try {
      if (currentUser != null)
        GetIt.I<FirebaseDatabase>()
            .ref()
            .child('Users/${currentUser!.uid}/lastSeen')
            .onDisconnect()
            .set(ServerValue.timestamp);
      // ignore: empty_catches
    } on Exception {}
  }

  Future<void> recordActive() async {
    if (_disposed || currentUser == null) return;

    await GetIt.I<FirebaseDatabase>()
        .ref()
        .child('Users/${currentUser!.uid}/lastSeen')
        .set('Active');
  }

  Future<void> recordLastSeen() async {
    if (_disposed || currentUser == null) return;

    await GetIt.I<FirebaseDatabase>()
        .ref()
        .child('Users/${currentUser!.uid}/lastSeen')
        .set(DateTime.now().millisecondsSinceEpoch);
  }

  @mustCallSuper
  Future<void> signOut() async {
    await recordLastSeen();
    await userTokenListener?.cancel();
    await personListener?.cancel();

    await GetIt.I<CacheRepository>().box('User').clear();
    await GetIt.I<CacheRepository>().openBox('User');

    userSubject.add(null);
    userDataSubject.add(null);
    await GetIt.I<GoogleSignIn>().signOut();
    await GetIt.I<auth.FirebaseAuth>().signOut();
    await connectionListener?.cancel();
  }

  @mustCallSuper
  Future<void> dispose() async {
    _disposed = true;
    await recordLastSeen();
    await userTokenListener?.cancel();
    await personListener?.cancel();
    await connectionListener?.cancel();
    await authListener?.cancel();
    await userDataSubject.close();
    await userSubject.close();
  }
}

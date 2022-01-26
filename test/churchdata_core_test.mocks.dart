// Mocks generated by Mockito 5.0.17 from annotations
// in churchdata_core/test/churchdata_core_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i8;

import 'package:cloud_functions/cloud_functions.dart' as _i4;
import 'package:cloud_functions_platform_interface/cloud_functions_platform_interface.dart'
    as _i3;
import 'package:firebase_core/firebase_core.dart' as _i2;
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart' as _i9;
import 'package:firebase_dynamic_links_platform_interface/firebase_dynamic_links_platform_interface.dart'
    as _i6;
import 'package:firebase_messaging/firebase_messaging.dart' as _i7;
import 'package:firebase_messaging_platform_interface/firebase_messaging_platform_interface.dart'
    as _i5;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeFirebaseApp_0 extends _i1.Fake implements _i2.FirebaseApp {}

class _FakeFirebaseFunctionsPlatform_1 extends _i1.Fake
    implements _i3.FirebaseFunctionsPlatform {}

class _FakeHttpsCallable_2 extends _i1.Fake implements _i4.HttpsCallable {}

class _FakeNotificationSettings_3 extends _i1.Fake
    implements _i5.NotificationSettings {}

class _FakeUri_4 extends _i1.Fake implements Uri {}

class _FakeShortDynamicLink_5 extends _i1.Fake implements _i6.ShortDynamicLink {
}

/// A class which mocks [FirebaseFunctions].
///
/// See the documentation for Mockito's code generation for more information.
class MockFirebaseFunctions extends _i1.Mock implements _i4.FirebaseFunctions {
  MockFirebaseFunctions() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.FirebaseApp get app => (super.noSuchMethod(Invocation.getter(#app),
      returnValue: _FakeFirebaseApp_0()) as _i2.FirebaseApp);
  @override
  _i3.FirebaseFunctionsPlatform get delegate =>
      (super.noSuchMethod(Invocation.getter(#delegate),
              returnValue: _FakeFirebaseFunctionsPlatform_1())
          as _i3.FirebaseFunctionsPlatform);
  @override
  Map<dynamic, dynamic> get pluginConstants =>
      (super.noSuchMethod(Invocation.getter(#pluginConstants),
          returnValue: <dynamic, dynamic>{}) as Map<dynamic, dynamic>);
  @override
  _i4.HttpsCallable httpsCallable(String? name,
          {_i3.HttpsCallableOptions? options}) =>
      (super.noSuchMethod(
          Invocation.method(#httpsCallable, [name], {#options: options}),
          returnValue: _FakeHttpsCallable_2()) as _i4.HttpsCallable);
  @override
  void useFunctionsEmulator(String? host, int? port) =>
      super.noSuchMethod(Invocation.method(#useFunctionsEmulator, [host, port]),
          returnValueForMissingStub: null);
}

/// A class which mocks [FirebaseMessaging].
///
/// See the documentation for Mockito's code generation for more information.
class MockFirebaseMessaging extends _i1.Mock implements _i7.FirebaseMessaging {
  MockFirebaseMessaging() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.FirebaseApp get app => (super.noSuchMethod(Invocation.getter(#app),
      returnValue: _FakeFirebaseApp_0()) as _i2.FirebaseApp);
  @override
  set app(_i2.FirebaseApp? _app) =>
      super.noSuchMethod(Invocation.setter(#app, _app),
          returnValueForMissingStub: null);
  @override
  bool get isAutoInitEnabled =>
      (super.noSuchMethod(Invocation.getter(#isAutoInitEnabled),
          returnValue: false) as bool);
  @override
  _i8.Stream<String> get onTokenRefresh =>
      (super.noSuchMethod(Invocation.getter(#onTokenRefresh),
          returnValue: Stream<String>.empty()) as _i8.Stream<String>);
  @override
  Map<dynamic, dynamic> get pluginConstants =>
      (super.noSuchMethod(Invocation.getter(#pluginConstants),
          returnValue: <dynamic, dynamic>{}) as Map<dynamic, dynamic>);
  @override
  _i8.Future<_i5.RemoteMessage?> getInitialMessage() =>
      (super.noSuchMethod(Invocation.method(#getInitialMessage, []),
              returnValue: Future<_i5.RemoteMessage?>.value())
          as _i8.Future<_i5.RemoteMessage?>);
  @override
  _i8.Future<void> deleteToken() =>
      (super.noSuchMethod(Invocation.method(#deleteToken, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<String?> getAPNSToken() =>
      (super.noSuchMethod(Invocation.method(#getAPNSToken, []),
          returnValue: Future<String?>.value()) as _i8.Future<String?>);
  @override
  _i8.Future<String?> getToken({String? vapidKey}) => (super.noSuchMethod(
      Invocation.method(#getToken, [], {#vapidKey: vapidKey}),
      returnValue: Future<String?>.value()) as _i8.Future<String?>);
  @override
  bool isSupported() => (super.noSuchMethod(Invocation.method(#isSupported, []),
      returnValue: false) as bool);
  @override
  _i8.Future<_i5.NotificationSettings> getNotificationSettings() =>
      (super.noSuchMethod(Invocation.method(#getNotificationSettings, []),
              returnValue: Future<_i5.NotificationSettings>.value(
                  _FakeNotificationSettings_3()))
          as _i8.Future<_i5.NotificationSettings>);
  @override
  _i8.Future<_i5.NotificationSettings> requestPermission(
          {bool? alert = true,
          bool? announcement = false,
          bool? badge = true,
          bool? carPlay = false,
          bool? criticalAlert = false,
          bool? provisional = false,
          bool? sound = true}) =>
      (super.noSuchMethod(
              Invocation.method(#requestPermission, [], {
                #alert: alert,
                #announcement: announcement,
                #badge: badge,
                #carPlay: carPlay,
                #criticalAlert: criticalAlert,
                #provisional: provisional,
                #sound: sound
              }),
              returnValue: Future<_i5.NotificationSettings>.value(
                  _FakeNotificationSettings_3()))
          as _i8.Future<_i5.NotificationSettings>);
  @override
  _i8.Future<void> sendMessage(
          {String? to,
          Map<String, String>? data,
          String? collapseKey,
          String? messageId,
          String? messageType,
          int? ttl}) =>
      (super.noSuchMethod(
          Invocation.method(#sendMessage, [], {
            #to: to,
            #data: data,
            #collapseKey: collapseKey,
            #messageId: messageId,
            #messageType: messageType,
            #ttl: ttl
          }),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> setAutoInitEnabled(bool? enabled) =>
      (super.noSuchMethod(Invocation.method(#setAutoInitEnabled, [enabled]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> setForegroundNotificationPresentationOptions(
          {bool? alert = false, bool? badge = false, bool? sound = false}) =>
      (super.noSuchMethod(
          Invocation.method(#setForegroundNotificationPresentationOptions, [],
              {#alert: alert, #badge: badge, #sound: sound}),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> subscribeToTopic(String? topic) =>
      (super.noSuchMethod(Invocation.method(#subscribeToTopic, [topic]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> unsubscribeFromTopic(String? topic) =>
      (super.noSuchMethod(Invocation.method(#unsubscribeFromTopic, [topic]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
}

/// A class which mocks [FirebaseDynamicLinks].
///
/// See the documentation for Mockito's code generation for more information.
class MockFirebaseDynamicLinks extends _i1.Mock
    implements _i9.FirebaseDynamicLinks {
  MockFirebaseDynamicLinks() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.FirebaseApp get app => (super.noSuchMethod(Invocation.getter(#app),
      returnValue: _FakeFirebaseApp_0()) as _i2.FirebaseApp);
  @override
  set app(_i2.FirebaseApp? _app) =>
      super.noSuchMethod(Invocation.setter(#app, _app),
          returnValueForMissingStub: null);
  @override
  _i8.Stream<_i6.PendingDynamicLinkData> get onLink =>
      (super.noSuchMethod(Invocation.getter(#onLink),
              returnValue: Stream<_i6.PendingDynamicLinkData>.empty())
          as _i8.Stream<_i6.PendingDynamicLinkData>);
  @override
  Map<dynamic, dynamic> get pluginConstants =>
      (super.noSuchMethod(Invocation.getter(#pluginConstants),
          returnValue: <dynamic, dynamic>{}) as Map<dynamic, dynamic>);
  @override
  _i8.Future<_i6.PendingDynamicLinkData?> getInitialLink() =>
      (super.noSuchMethod(Invocation.method(#getInitialLink, []),
              returnValue: Future<_i6.PendingDynamicLinkData?>.value())
          as _i8.Future<_i6.PendingDynamicLinkData?>);
  @override
  _i8.Future<_i6.PendingDynamicLinkData?> getDynamicLink(Uri? url) =>
      (super.noSuchMethod(Invocation.method(#getDynamicLink, [url]),
              returnValue: Future<_i6.PendingDynamicLinkData?>.value())
          as _i8.Future<_i6.PendingDynamicLinkData?>);
  @override
  _i8.Future<Uri> buildLink(_i6.DynamicLinkParameters? parameters) =>
      (super.noSuchMethod(Invocation.method(#buildLink, [parameters]),
          returnValue: Future<Uri>.value(_FakeUri_4())) as _i8.Future<Uri>);
  @override
  _i8.Future<_i6.ShortDynamicLink> buildShortLink(
          _i6.DynamicLinkParameters? parameters,
          {_i6.ShortDynamicLinkType? shortLinkType =
              _i6.ShortDynamicLinkType.short}) =>
      (super.noSuchMethod(
          Invocation.method(
              #buildShortLink, [parameters], {#shortLinkType: shortLinkType}),
          returnValue: Future<_i6.ShortDynamicLink>.value(
              _FakeShortDynamicLink_5())) as _i8.Future<_i6.ShortDynamicLink>);
}

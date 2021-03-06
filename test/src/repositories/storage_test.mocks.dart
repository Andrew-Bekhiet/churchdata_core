// Mocks generated by Mockito 5.2.0 from annotations
// in churchdata_core/test/src/repositories/storage_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;
import 'dart:io' as _i6;
import 'dart:typed_data' as _i5;

import 'package:churchdata_core/churchdata_core.dart' as _i3;
import 'package:firebase_storage/firebase_storage.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeReference_0 extends _i1.Fake implements _i2.Reference {}

class _FakeFirebaseStorage_1 extends _i1.Fake implements _i2.FirebaseStorage {}

class _FakeStorageReference_2 extends _i1.Fake implements _i3.StorageReference {
}

class _FakeFullMetadata_3 extends _i1.Fake implements _i2.FullMetadata {}

class _FakeListResult_4 extends _i1.Fake implements _i2.ListResult {}

class _FakeUploadTask_5 extends _i1.Fake implements _i2.UploadTask {}

class _FakeDownloadTask_6 extends _i1.Fake implements _i2.DownloadTask {}

/// A class which mocks [StorageReference].
///
/// See the documentation for Mockito's code generation for more information.
class MockStorageReference extends _i1.Mock implements _i3.StorageReference {
  MockStorageReference() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get fullPath =>
      (super.noSuchMethod(Invocation.getter(#fullPath), returnValue: '')
          as String);
  @override
  String get name =>
      (super.noSuchMethod(Invocation.getter(#name), returnValue: '') as String);
  @override
  String get bucket =>
      (super.noSuchMethod(Invocation.getter(#bucket), returnValue: '')
          as String);
  @override
  _i2.Reference get root => (super.noSuchMethod(Invocation.getter(#root),
      returnValue: _FakeReference_0()) as _i2.Reference);
  @override
  _i2.FirebaseStorage get storage =>
      (super.noSuchMethod(Invocation.getter(#storage),
          returnValue: _FakeFirebaseStorage_1()) as _i2.FirebaseStorage);
  @override
  _i4.FutureOr<String> getDownloadURL() =>
      (super.noSuchMethod(Invocation.method(#getDownloadURL, []),
          returnValue: Future<String>.value('')) as _i4.FutureOr<String>);
  @override
  _i4.FutureOr<String> getCachedDownloadUrl(
          {void Function(String, String?)? onCacheChanged,
          void Function(Exception, String?)? onError}) =>
      (super.noSuchMethod(
          Invocation.method(#getCachedDownloadUrl, [],
              {#onCacheChanged: onCacheChanged, #onError: onError}),
          returnValue: Future<String>.value('')) as _i4.FutureOr<String>);
  @override
  _i3.StorageReference child(String? child) =>
      (super.noSuchMethod(Invocation.method(#child, [child]),
          returnValue: _FakeStorageReference_2()) as _i3.StorageReference);
  @override
  _i4.Future<void> delete() =>
      (super.noSuchMethod(Invocation.method(#delete, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  _i4.Future<_i5.Uint8List?> getData([int? maxSize = 10485760]) =>
      (super.noSuchMethod(Invocation.method(#getData, [maxSize]),
              returnValue: Future<_i5.Uint8List?>.value())
          as _i4.Future<_i5.Uint8List?>);
  @override
  _i4.Future<_i2.FullMetadata> getMetadata() => (super.noSuchMethod(
          Invocation.method(#getMetadata, []),
          returnValue: Future<_i2.FullMetadata>.value(_FakeFullMetadata_3()))
      as _i4.Future<_i2.FullMetadata>);
  @override
  _i4.Future<_i2.ListResult> list([_i2.ListOptions? options]) =>
      (super.noSuchMethod(Invocation.method(#list, [options]),
              returnValue: Future<_i2.ListResult>.value(_FakeListResult_4()))
          as _i4.Future<_i2.ListResult>);
  @override
  _i4.Future<_i2.ListResult> listAll() =>
      (super.noSuchMethod(Invocation.method(#listAll, []),
              returnValue: Future<_i2.ListResult>.value(_FakeListResult_4()))
          as _i4.Future<_i2.ListResult>);
  @override
  _i2.UploadTask putBlob(dynamic blob, [_i2.SettableMetadata? metadata]) =>
      (super.noSuchMethod(Invocation.method(#putBlob, [blob, metadata]),
          returnValue: _FakeUploadTask_5()) as _i2.UploadTask);
  @override
  _i2.UploadTask putData(_i5.Uint8List? data,
          [_i2.SettableMetadata? metadata]) =>
      (super.noSuchMethod(Invocation.method(#putData, [data, metadata]),
          returnValue: _FakeUploadTask_5()) as _i2.UploadTask);
  @override
  _i2.UploadTask putFile(_i6.File? file, [_i2.SettableMetadata? metadata]) =>
      (super.noSuchMethod(Invocation.method(#putFile, [file, metadata]),
          returnValue: _FakeUploadTask_5()) as _i2.UploadTask);
  @override
  _i2.UploadTask putString(String? data,
          {_i2.PutStringFormat? format = _i2.PutStringFormat.raw,
          _i2.SettableMetadata? metadata}) =>
      (super.noSuchMethod(
          Invocation.method(
              #putString, [data], {#format: format, #metadata: metadata}),
          returnValue: _FakeUploadTask_5()) as _i2.UploadTask);
  @override
  _i4.Future<_i2.FullMetadata> updateMetadata(_i2.SettableMetadata? metadata) =>
      (super.noSuchMethod(Invocation.method(#updateMetadata, [metadata]),
              returnValue:
                  Future<_i2.FullMetadata>.value(_FakeFullMetadata_3()))
          as _i4.Future<_i2.FullMetadata>);
  @override
  _i2.DownloadTask writeToFile(_i6.File? file) =>
      (super.noSuchMethod(Invocation.method(#writeToFile, [file]),
          returnValue: _FakeDownloadTask_6()) as _i2.DownloadTask);
}

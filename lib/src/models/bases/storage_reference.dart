import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:churchdata_core/churchdata_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as f_storage;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as path;

class StorageReference {
  StorageReference({
    required String fullPath,
    required FutureOr<String> Function() downloadUrl,
  })  : _downloadUrl = downloadUrl,
        _fullPath = fullPath,
        _ref = null;

  StorageReference.fromFirebaseRef(f_storage.Reference ref)
      : _fullPath = ref.fullPath,
        _downloadUrl = ref.getDownloadURL,
        _ref = ref;

  final f_storage.Reference? _ref;
  final String _fullPath;
  final FutureOr<String> Function() _downloadUrl;

  String get fullPath => _fullPath;

  String get name => path.basename(_fullPath);

  FutureOr<String> getDownloadURL() => _downloadUrl();

  FutureOr<String> getCachedDownloadUrl({
    void Function(String oldUrl, String? newUrl)? onCacheChanged,
    void Function(Exception e, String? cache)? onError,
  }) async {
    final String? cache = GetIt.I<CacheRepository>()
        .box<String?>('PhotosURLsCache')
        .get(fullPath);

    try {
      if (cache == null) {
        final downloadUrl = getDownloadURL();

        if (downloadUrl is String) return downloadUrl;

        final String url = await downloadUrl;

        await GetIt.I<CacheRepository>()
            .box<String?>('PhotosURLsCache')
            .put(fullPath, url);

        return url;
      }

      _updateCache(cache, onCacheChanged);

      return cache;
    } on Exception catch (e) {
      if (onError == null)
        rethrow;
      else
        onError(e, cache);
      return cache ?? '';
    }
  }

  Future<void> deleteCache() async {
    final String? cache = GetIt.I<CacheRepository>()
        .box<String?>('PhotosURLsCache')
        .get(fullPath);

    if (cache == null) return;

    await (GetIt.I.isRegistered<BaseCacheManager>()
            ? GetIt.I<BaseCacheManager>()
            : DefaultCacheManager())
        .removeFile(cache);

    await GetIt.I<CacheRepository>()
        .box<String?>('PhotosURLsCache')
        .delete(fullPath);
  }

  void _updateCache(
      String cache, void Function(String, String?)? onCacheChanged) async {
    String? url;
    try {
      url = await getDownloadURL();
    } catch (e) {
      url = null;
    }
    if (cache != url) {
      await GetIt.I<CacheRepository>()
          .box<String?>('PhotosURLsCache')
          .put(fullPath, url);

      onCacheChanged?.call(cache, url);
    }
  }

  f_storage.Reference _checkRef(f_storage.Reference? ref) {
    if (ref == null)
      throw UnsupportedError('not initialized with fromFirebaseRef');
    return ref;
  }

  StorageReference child(String child) =>
      StorageReference.fromFirebaseRef(_checkRef(_ref).child(child));

  String get bucket => _checkRef(_ref).bucket;

  Future<void> delete() {
    return _checkRef(_ref).delete();
  }

  Future<Uint8List?> getData([int maxSize = 10485760]) {
    return _checkRef(_ref).getData(maxSize);
  }

  Future<f_storage.FullMetadata> getMetadata() {
    return _checkRef(_ref).getMetadata();
  }

  Future<f_storage.ListResult> list([f_storage.ListOptions? options]) {
    return _checkRef(_ref).list(options);
  }

  Future<f_storage.ListResult> listAll() {
    return _checkRef(_ref).listAll();
  }

  f_storage.Reference? get parent => _checkRef(_ref).parent;

  f_storage.UploadTask putBlob(blob, [f_storage.SettableMetadata? metadata]) {
    return _checkRef(_ref).putBlob(blob, metadata);
  }

  f_storage.UploadTask putData(Uint8List data,
      [f_storage.SettableMetadata? metadata]) {
    return _checkRef(_ref).putData(data, metadata);
  }

  f_storage.UploadTask putFile(File file,
      [f_storage.SettableMetadata? metadata]) {
    return _checkRef(_ref).putFile(file, metadata);
  }

  f_storage.UploadTask putString(
    String data, {
    f_storage.PutStringFormat format = f_storage.PutStringFormat.raw,
    f_storage.SettableMetadata? metadata,
  }) {
    return _checkRef(_ref).putString(data, format: format, metadata: metadata);
  }

  f_storage.Reference get root => _checkRef(_ref).root;

  f_storage.FirebaseStorage get storage => _checkRef(_ref).storage;

  Future<f_storage.FullMetadata> updateMetadata(
      f_storage.SettableMetadata metadata) {
    return _checkRef(_ref).updateMetadata(metadata);
  }

  f_storage.DownloadTask writeToFile(File file) {
    return _checkRef(_ref).writeToFile(file);
  }
}

import 'package:churchdata_core/src/typedefs.dart' show Reference;
import 'package:firebase_storage/firebase_storage.dart' hide Reference;
import 'package:get_it/get_it.dart';

import 'cache_repo.dart';

class StorageRepository {
  StorageRepository();

  Reference ref([String? path]) => GetIt.I<FirebaseStorage>().ref(path);
}

extension ReferenceX on Reference {
  Future<String> getCachedDownloadUrl(
      [void Function(String oldUrl, String? newUrl)? onCacheChanged]) async {
    final String? cache = GetIt.I<CacheRepository>()
        .box<String?>('PhotosURLsCache')
        .get(fullPath);

    if (cache == null) {
      final String url = await getDownloadURL();

      await GetIt.I<CacheRepository>()
          .box<String?>('PhotosURLsCache')
          .put(fullPath, url);

      return url;
    }

    _updateCache(cache, onCacheChanged);

    return cache;
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
}

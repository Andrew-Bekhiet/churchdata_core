import 'package:churchdata_core/churchdata_core.dart';
import 'package:churchdata_core_mocks/churchdata_core.dart';
import 'package:churchdata_core_mocks/fakes/fake_cache_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([StorageReference])
void main() {
  group(
    'Storage extension tests ->',
    () {
      setUp(
        () async {
          GetIt.I.pushNewScope(scopeName: 'StorageTestsScope');
          registerFirebaseMocks();

          GetIt.I.registerSingleton<CacheRepository>(FakeCacheRepo());
          GetIt.I.registerSingleton<StorageRepository>(StorageRepository());
        },
      );

      tearDown(
        () async {
          await GetIt.I.reset();
        },
      );

      test(
        'Cached Download Url: async',
        () async {
          await GetIt.I<CacheRepository>().openBox<String?>('PhotosURLsCache');

          const firstUrl = 'https://google.com/image.jpg';
          const changedUrl = 'https://google.com/changed.jpg';

          String currentUrl = firstUrl;

          final ref = StorageReference(
            fullPath: 'fullPath',
            downloadUrl: () async => currentUrl,
          );

          currentUrl = firstUrl;

          expect(
            await ref.getCachedDownloadUrl(
              onCacheChanged: (_, __) =>
                  fail('onCacheChanged was called on first time'),
            ),
            firstUrl,
          );
          expect(
            GetIt.I<CacheRepository>()
                .box<String?>('PhotosURLsCache')
                .get(ref.fullPath),
            firstUrl,
          );

          currentUrl = changedUrl;

          expect(
            await ref.getCachedDownloadUrl(
              onCacheChanged: (c, u) {
                expect(c, firstUrl);
                expect(u, changedUrl);
              },
            ),
            firstUrl,
          );

          expect(
            GetIt.I<CacheRepository>()
                .box<String?>('PhotosURLsCache')
                .get(ref.fullPath),
            changedUrl,
          );
        },
      );

      test(
        'Cached Download Url: sync',
        () async {
          await GetIt.I<CacheRepository>().openBox<String?>('PhotosURLsCache');

          const firstUrl = 'https://google.com/image.jpg';
          const changedUrl = 'https://google.com/changed.jpg';

          String currentUrl = firstUrl;

          final ref = StorageReference(
            fullPath: 'fullPath',
            downloadUrl: () => currentUrl,
          );

          currentUrl = firstUrl;

          expect(
            await ref.getCachedDownloadUrl(
                onCacheChanged: (_, __) =>
                    fail('onCacheChanged was called on first time')),
            firstUrl,
          );
          expect(
            GetIt.I<CacheRepository>()
                .box<String?>('PhotosURLsCache')
                .get(ref.fullPath),
            isNull,
          );

          currentUrl = changedUrl;

          expect(
            await ref.getCachedDownloadUrl(
              onCacheChanged: (c, u) {
                expect(c, firstUrl);
                expect(u, changedUrl);
              },
            ),
            changedUrl,
          );

          expect(
            GetIt.I<CacheRepository>()
                .box<String?>('PhotosURLsCache')
                .get(ref.fullPath),
            isNull,
          );
        },
      );
    },
  );
}

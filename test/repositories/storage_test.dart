import 'package:churchdata_core/churchdata_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import '../churchdata_core.dart';
import '../fakes/fake_cache_repo.dart';

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
        'Cached Download Url',
        () async {
          await GetIt.I<CacheRepository>().openBox<String?>('PhotosURLsCache');

          final ref = GetIt.I<StorageRepository>().ref('folder/file');

          const firstUrl = 'https://google.com/image.jpg';
          const changedUrl = 'https://google.com/changed.jpg';

          when(ref.getDownloadURL()).thenAnswer((_) async => firstUrl);

          expect(
            await ref.getCachedDownloadUrl(
                (_, __) => fail('onCacheChanged was called on first time')),
            firstUrl,
          );
          expect(
            GetIt.I<CacheRepository>()
                .box<String?>('PhotosURLsCache')
                .get(ref.fullPath),
            firstUrl,
          );

          when(ref.getDownloadURL()).thenAnswer((_) async => changedUrl);

          expect(
            await ref.getCachedDownloadUrl(
              (c, u) {
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
    },
  );
}

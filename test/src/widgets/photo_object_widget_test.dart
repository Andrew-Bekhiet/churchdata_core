import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:churchdata_core/churchdata_core.dart';
import 'package:churchdata_core_mocks/churchdata_core.dart';
import 'package:churchdata_core_mocks/fakes/fake_cache_repo.dart';
import 'package:churchdata_core_mocks/utils.dart';
import 'package:file/file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(
    'PhotoObjectWidget tests ->',
    () {
      setUp(
        () async {
          GetIt.I.pushNewScope(scopeName: 'PhotoObjectWidgetTestsScope');

          registerFirebaseMocks();

          GetIt.I.registerSingleton(DatabaseRepository());
          GetIt.I.registerSingleton<CacheRepository>(FakeCacheRepo());
          GetIt.I.registerSingleton(StorageRepository());
          GetIt.I.registerSingleton<BaseCacheManager>(MockCacheManager());
        },
      );

      tearDown(
        () async {
          await GetIt.I.reset();
        },
      );

      testWidgets(
        'DataObjectPhoto',
        (tester) async {
          await GetIt.I<CacheRepository>().openBox<String?>('PhotosURLsCache');

          final person = PersonBase(
            ref: GetIt.I<DatabaseRepository>().collection('Persons').doc('id'),
            name: 'person',
            hasPhoto: true,
          );

          final fakeRef = person.photoRef;
          when(fakeRef!.getDownloadURL())
              .thenAnswer((_) async => 'https://example.com/image.png');

          final fakePerson = FakePerson.fromPerson(person, fakeRef);

          await tester.pumpWidget(
            wrapWithMaterialApp(
              Scaffold(
                body: PhotoObjectWidget(fakePerson),
              ),
            ),
          );

          await tester.pumpAndSettle();

          expect(find.byType(CachedNetworkImage), findsOneWidget);

          fakePerson.photoUrlCache.invalidate();
        },
      );

      testWidgets(
        'DataObjectPhoto tap',
        (tester) async {
          await GetIt.I<CacheRepository>().openBox<String?>('PhotosURLsCache');

          final navigator = GlobalKey<NavigatorState>();

          final person = PersonBase(
            ref: GetIt.I<DatabaseRepository>().collection('Persons').doc('id'),
            name: 'person',
            hasPhoto: true,
          );

          final fakeRef = person.photoRef;
          when(fakeRef!.getDownloadURL())
              .thenAnswer((_) async => 'https://example.com/image.png');

          final fakePerson = FakePerson.fromPerson(person, fakeRef);

          await tester.pumpWidget(
            wrapWithMaterialApp(
              Scaffold(
                body: PhotoObjectWidget(fakePerson),
              ),
              navigatorKey: navigator,
            ),
          );

          await tester.pumpAndSettle();

          await tester.tap(find.byType(CachedNetworkImage));
          await tester.pumpAndSettle();

          expect(
            find.descendant(
              of: find.byType(Dialog),
              matching: find.descendant(
                of: find.byType(InteractiveViewer),
                matching: find.byType(CachedNetworkImage),
              ),
            ),
            findsOneWidget,
          );

          fakePerson.photoUrlCache.invalidate();
        },
      );
    },
  );
}

class FakePerson extends PersonBase {
  final Reference? mockPhotoRef;

  FakePerson.fromPerson(PersonBase person, this.mockPhotoRef)
      : super(
          ref: person.ref,
          name: person.name,
          color: person.color,
          address: person.address,
          location: person.location,
          mainPhone: person.mainPhone,
          otherPhones: person.otherPhones,
          birthDate: person.birthDate,
          school: person.school,
          college: person.college,
          church: person.church,
          cFather: person.cFather,
          lastKodas: person.lastKodas,
          lastTanawol: person.lastTanawol,
          lastConfession: person.lastConfession,
          lastCall: person.lastCall,
          lastVisit: person.lastVisit,
          lastEdit: person.lastEdit,
          notes: person.notes,
          isShammas: person.isShammas,
          gender: person.gender,
          shammasLevel: person.shammasLevel,
          studyYear: person.studyYear,
          hasPhoto: person.hasPhoto,
        );

  @override
  Reference? get photoRef => mockPhotoRef;
}

class MockCacheManager extends CacheManager with ImageCacheManager {
  MockCacheManager() : super(Config(DefaultCacheManager.key));

  Future<String?> getFilePath() async {
    return 'somewhere/file.png';
  }

  @override
  Stream<FileResponse> getFileStream(String url,
      {String? key,
      Map<String, String>? headers,
      bool withProgress = false}) async* {
    final length = transparentImage.length;

    yield DownloadProgress(url, length, length);

    yield FileInfo(
      MockFile(),
      FileSource.Cache,
      DateTime(2050),
      url,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

class MockFile extends Fake implements File {
  @override
  Uint8List readAsBytesSync() {
    return transparentImage;
  }

  @override
  Future<Uint8List> readAsBytes() async {
    return readAsBytesSync();
  }
}

final transparentImage = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAY'
  'AAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEh'
  'QGAhKmMIQAAAABJRU5ErkJggg==',
);

import 'package:cached_network_image/cached_network_image.dart';
import 'package:churchdata_core/churchdata_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../churchdata_core_test.dart';
import '../fakes/fake_cache_repo.dart';
import '../utils.dart';
import 'photo_object_widget_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(
    'UserPhotoWidget tests ->',
    () {
      setUp(
        () async {
          GetIt.I.pushNewScope(scopeName: 'UserPhotoWidgetTestsScope');

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

          final fakePerson = FakeUserPerson(fakeRef);

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
        'DataObjectPhoto2',
        (tester) async {
          await GetIt.I<CacheRepository>().openBox<String?>('PhotosURLsCache');

          final person = PersonBase(
            ref: GetIt.I<DatabaseRepository>().collection('Persons').doc('id'),
            name: 'person',
            hasPhoto: true,
          );

          final fakeRef = person.photoRef;
          //final fakeRef = GetIt.I<StorageRepository>().ref('UsersPhotos/uid');//failing
          //final fakeRef = GetIt.I<StorageRepository>().ref('PersonsPhotos/id');//succeeds
          when(fakeRef!.getDownloadURL())
              .thenAnswer((_) async => 'https://example.com/image.png');

          final fakePerson = FakeUserPerson(fakeRef);

          await tester.pumpWidget(
            wrapWithMaterialApp(
              Scaffold(
                body: UserPhotoWidget(fakePerson),
              ),
            ),
          );

          await tester.pumpAndSettle();

          expect(find.byType(CachedNetworkImage), findsOneWidget);

          fakePerson.photoUrlCache.invalidate();
        },
      );

      testWidgets(
        'UserPhoto Activity tests',
        (tester) async {
          await GetIt.I<CacheRepository>().openBox<String?>('PhotosURLsCache');

          final user = UserBase(
            uid: 'uid',
            name: 'user',
          );

          final fakeRef = user.photoRef;
          when(fakeRef!.getDownloadURL())
              .thenAnswer((_) async => 'https://example.com/image.png');

          final fakeUser = FakeUserPerson(fakeRef);
          await mockNetworkImagesFor(
            () async => tester.pumpWidget(
              wrapWithMaterialApp(
                Scaffold(
                  body: UserPhotoWidget(
                    fakeUser,
                    constraints: const BoxConstraints(
                      maxHeight: 200,
                      maxWidth: 200,
                    ),
                  ),
                ),
              ),
            ),
          );

          await tester.pumpAndSettle();

          expect(
            find.descendant(
              of: find.byType(Stack),
              matching: find.byWidgetPredicate(
                (p) => p is PhotoObjectWidget && p.object == fakeUser,
              ),
            ),
            findsOneWidget,
          );
          expect(
            find.descendant(
              of: find.byType(Stack),
              matching: find.byWidgetPredicate(
                (widget) =>
                    widget is Container &&
                    (widget.decoration! as BoxDecoration).color ==
                        Colors.greenAccent,
              ),
            ),
            findsNothing,
          );

          await GetIt.I<FirebaseDatabase>()
              .ref()
              .child('Users/${fakeUser.uid}/lastSeen')
              .set('Active');
          await tester.pumpAndSettle();

          expect(
            find.descendant(
              of: find.byType(Stack),
              matching: find.byWidgetPredicate(
                (p) => p is PhotoObjectWidget && p.object == fakeUser,
              ),
            ),
            findsOneWidget,
          );
          expect(
            find.descendant(
              of: find.byType(Stack),
              matching: find.byWidgetPredicate(
                (widget) =>
                    widget is Container &&
                    (widget.decoration! as BoxDecoration).color ==
                        Colors.greenAccent,
              ),
            ),
            findsOneWidget,
          );

          fakeUser.photoUrlCache.invalidate();
        },
      );
    },
  );
}

class FakeUser extends UserBase {
  final Reference? mockPhotoRef;

  FakeUser.fromUser(UserBase user, this.mockPhotoRef)
      : super(
          name: user.name,
          uid: user.uid,
          email: user.email,
          permissions: user.permissions,
          phone: user.phone,
        );

  @override
  Reference? get photoRef => mockPhotoRef;
}

class FakeUserPerson extends UserBase {
  final Reference? mockPhotoRef;

  FakeUserPerson(this.mockPhotoRef)
      : super(
          uid: 'uid',
          name: 'name',
        );

  @override
  Reference? get photoRef => mockPhotoRef;

  @override
  String? get email => throw UnimplementedError();

  @override
  PermissionsSet get permissions => throw UnimplementedError();

  @override
  String? get phone => throw UnimplementedError();

  @override
  String get uid => 'uid';

  @override
  bool get hasPhoto => true;

  @override
  // TODO: implement address
  String? get address => throw UnimplementedError();

  @override
  // TODO: implement birthDate
  DateTime? get birthDate => throw UnimplementedError();

  @override
  // TODO: implement cFather
  JsonRef? get cFather => throw UnimplementedError();

  @override
  // TODO: implement church
  JsonRef? get church => throw UnimplementedError();

  @override
  // TODO: implement college
  JsonRef? get college => throw UnimplementedError();

  @override
  // TODO: implement color
  Color? get color => throw UnimplementedError();

  @override
  // TODO: implement gender
  bool get gender => throw UnimplementedError();

  @override
  Future<String?> getSecondLine() {
    // TODO: implement getSecondLine
    throw UnimplementedError();
  }

  @override
  String get id => uid;

  @override
  // TODO: implement isShammas
  bool get isShammas => throw UnimplementedError();

  @override
  // TODO: implement lastCall
  DateTime? get lastCall => throw UnimplementedError();

  @override
  // TODO: implement lastConfession
  DateTime? get lastConfession => throw UnimplementedError();

  @override
  // TODO: implement lastEdit
  LastEdit? get lastEdit => throw UnimplementedError();

  @override
  // TODO: implement lastKodas
  DateTime? get lastKodas => throw UnimplementedError();

  @override
  // TODO: implement lastTanawol
  DateTime? get lastTanawol => throw UnimplementedError();

  @override
  // TODO: implement lastVisit
  DateTime? get lastVisit => throw UnimplementedError();

  @override
  // TODO: implement location
  Never get location => throw UnimplementedError();

  @override
  // TODO: implement mainPhone
  String? get mainPhone => throw UnimplementedError();

  @override
  // TODO: implement notes
  String? get notes => throw UnimplementedError();

  @override
  // TODO: implement otherPhones
  Json get otherPhones => throw UnimplementedError();

  @override
  // TODO: implement ref
  JsonRef get ref => throw UnimplementedError();

  @override
  // TODO: implement school
  JsonRef? get school => throw UnimplementedError();

  @override
  Future<void> set({Json? merge}) {
    // TODO: implement set
    throw UnimplementedError();
  }

  @override
  // TODO: implement shammasLevel
  String? get shammasLevel => throw UnimplementedError();

  @override
  // TODO: implement studyYear
  JsonRef? get studyYear => throw UnimplementedError();

  @override
  Future<void> update({Json old = const {}}) {
    // TODO: implement update
    throw UnimplementedError();
  }
}

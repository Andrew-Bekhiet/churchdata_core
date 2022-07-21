import 'package:churchdata_core/churchdata_core.dart';
import 'package:churchdata_core_mocks/churchdata_core.dart';
import 'package:churchdata_core_mocks/fakes/fake_cache_repo.dart';
import 'package:churchdata_core_mocks/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

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
        'UserPhoto Activity: Inactive',
        (tester) async {
          await GetIt.I<CacheRepository>().openBox<String?>('PhotosURLsCache');

          final user = UserBase(
            uid: 'uid',
            name: 'user',
          );

          await tester.pumpWidget(
            wrapWithMaterialApp(
              Scaffold(
                body: UserPhotoWidget(
                  user,
                  constraints: const BoxConstraints(
                    maxHeight: 200,
                    maxWidth: 200,
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
                (p) => p is PhotoObjectWidget && p.object == user,
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
                    widget.decoration != null &&
                    (widget.decoration! as BoxDecoration).color ==
                        Colors.greenAccent,
              ),
            ),
            findsNothing,
          );

          user.photoUrlCache.invalidate();
        },
      );
      testWidgets(
        'UserPhoto Activity: Active',
        (tester) async {
          await GetIt.I<CacheRepository>().openBox<String?>('PhotosURLsCache');

          final fakeUser = UserBase(
            uid: 'uid',
            name: 'user',
          );

          await GetIt.I<FirebaseDatabase>()
              .ref()
              .child('Users/${fakeUser.uid}/lastSeen')
              .set('Active');

          //Pushing new widget because firebase database mock
          //doesn't emit continous stream
          await tester.pumpWidget(
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
                    widget.decoration != null &&
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

import 'package:churchdata_core/churchdata_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:share_plus_platform_interface/share_plus_platform_interface.dart';

import '../churchdata_core.dart';
import '../churchdata_core.mocks.dart';
import 'share_service_test.mocks.dart';

@GenerateMocks([SharePlatform])
void main() {
  group(
    'Share Service tests ->',
    () {
      setUp(
        () async {
          SharePlatform.instance = MockSharePlatform();
          when((SharePlatform.instance as MockSharePlatform).share(any))
              .thenAnswer((_) async => Never);

          registerFirebaseMocks();

          GetIt.I.registerSingleton(DatabaseRepository());
        },
      );

      tearDown(GetIt.I.reset);

      test(
        'Sharing text',
        () async {
          final unit = ShareService(
            projectId: 'projectId',
            uriPrefix: 'uriPrefix',
            packageName: 'packageName',
            fallbackUrl: Uri.https('authority', 'unencodedPath'),
          );

          await unit.shareText('text');
          verify(unit.shareText('text'));
        },
      );

      test(
        'Sharing query',
        () async {
          final unit = ShareService(
            projectId: 'projectId',
            uriPrefix: 'uriPrefix',
            packageName: 'packageName',
            fallbackUrl: Uri.https('authority', 'unencodedPath'),
          );

          const query = {
            'collection': 'collection',
            'fieldPath': 'fieldPath',
            'operator': '=',
            'queryValue': null,
            'order': 'true',
            'orderBy': 'fieldOrder',
            'descending': 'true',
          };

          final shortDynamicLink = ShortDynamicLink(
            type: ShortDynamicLinkType.unguessable,
            shortUrl: Uri.https('shortUrl', 'wefyygud'),
          );

          when((GetIt.I<FirebaseDynamicLinks>() as MockFirebaseDynamicLinks)
              .buildShortLink(
            any,
            shortLinkType: ShortDynamicLinkType.unguessable,
          )).thenAnswer(
            (_) async => shortDynamicLink,
          );

          expect(
            await unit.shareQuery(
              QueryInfo.fromJson(
                query,
              ),
            ),
            shortDynamicLink.shortUrl,
          );

          verify(
            (GetIt.I<FirebaseDynamicLinks>() as MockFirebaseDynamicLinks)
                .buildShortLink(
              argThat(
                predicate<DynamicLinkParameters>((p) =>
                    p.uriPrefix == unit.uriPrefix &&
                    p.link ==
                        Uri.https(
                            unit.projectId + '.com', 'viewQuery', query) &&
                    p.androidParameters == unit.androidParameters &&
                    p.iosParameters == unit.iosParameters),
              ),
              shortLinkType: ShortDynamicLinkType.unguessable,
            ),
          );
        },
      );

      test(
        'Sharing person',
        () async {
          final unit = ShareService(
            projectId: 'projectId',
            uriPrefix: 'uriPrefix',
            packageName: 'packageName',
            fallbackUrl: Uri.https('authority', 'unencodedPath'),
          );

          final shortDynamicLink = ShortDynamicLink(
            type: ShortDynamicLinkType.unguessable,
            shortUrl: Uri.https('shortUrl', 'wefyygud'),
          );

          when((GetIt.I<FirebaseDynamicLinks>() as MockFirebaseDynamicLinks)
              .buildShortLink(
            any,
            shortLinkType: ShortDynamicLinkType.unguessable,
          )).thenAnswer(
            (_) async => shortDynamicLink,
          );

          expect(
            await unit.sharePerson(
              PersonBase(
                ref: GetIt.I<DatabaseRepository>().doc('Persons/p'),
                name: 'p',
              ),
            ),
            shortDynamicLink.shortUrl,
          );

          verify(
            (GetIt.I<FirebaseDynamicLinks>() as MockFirebaseDynamicLinks)
                .buildShortLink(
              argThat(
                predicate<DynamicLinkParameters>(
                  (p) =>
                      p.uriPrefix == unit.uriPrefix &&
                      p.link ==
                          Uri.https(
                            unit.projectId + '.com',
                            'PersonInfo',
                            {'Id': 'p'},
                          ) &&
                      p.androidParameters == unit.androidParameters &&
                      p.iosParameters == unit.iosParameters,
                ),
              ),
              shortLinkType: ShortDynamicLinkType.unguessable,
            ),
          );
        },
      );

      test(
        'Sharing User',
        () async {
          final unit = ShareService(
            projectId: 'projectId',
            uriPrefix: 'uriPrefix',
            packageName: 'packageName',
            fallbackUrl: Uri.https('authority', 'unencodedPath'),
          );

          final shortDynamicLink = ShortDynamicLink(
            type: ShortDynamicLinkType.unguessable,
            shortUrl: Uri.https('shortUrl', 'wefyygud'),
          );

          when((GetIt.I<FirebaseDynamicLinks>() as MockFirebaseDynamicLinks)
              .buildShortLink(
            any,
            shortLinkType: ShortDynamicLinkType.unguessable,
          )).thenAnswer(
            (_) async => shortDynamicLink,
          );

          expect(
            await unit.shareUser(
              UserBase(
                uid: 'uid',
                name: 'u',
              ),
            ),
            shortDynamicLink.shortUrl,
          );

          verify(
            (GetIt.I<FirebaseDynamicLinks>() as MockFirebaseDynamicLinks)
                .buildShortLink(
              argThat(
                predicate<DynamicLinkParameters>(
                  (p) =>
                      p.uriPrefix == unit.uriPrefix &&
                      p.link ==
                          Uri.https(
                            unit.projectId + '.com',
                            'UserInfo',
                            {'UID': 'uid'},
                          ) &&
                      p.androidParameters == unit.androidParameters &&
                      p.iosParameters == unit.iosParameters,
                ),
              ),
              shortLinkType: ShortDynamicLinkType.unguessable,
            ),
          );
        },
      );

      test(
        'Sharing Object',
        () async {
          final unit = ShareService(
            projectId: 'projectId',
            uriPrefix: 'uriPrefix',
          );

          final shortDynamicLink = ShortDynamicLink(
            type: ShortDynamicLinkType.unguessable,
            shortUrl: Uri.https('shortUrl', 'wefyygud'),
          );

          when((GetIt.I<FirebaseDynamicLinks>() as MockFirebaseDynamicLinks)
              .buildShortLink(
            any,
            shortLinkType: ShortDynamicLinkType.unguessable,
          )).thenAnswer(
            (_) async => shortDynamicLink,
          );

          expect(
            await unit.shareObject(
              UserBase(
                uid: 'uid',
                name: 'u',
              ),
            ),
            await unit.shareUser(
              UserBase(
                uid: 'uid',
                name: 'u',
              ),
            ),
          );

          expect(
            await unit.shareObject(
              PersonBase(
                ref: GetIt.I<DatabaseRepository>().doc('Persons/p'),
                name: 'p',
              ),
            ),
            await unit.sharePerson(
              PersonBase(
                ref: GetIt.I<DatabaseRepository>().doc('Persons/p'),
                name: 'p',
              ),
            ),
          );
          expect(
            await unit.shareObject(
              QueryInfo.fromJson(
                const {
                  'collection': 'collection',
                  'fieldPath': 'fieldPath',
                  'operator': '=',
                  'queryValue': null,
                  'order': 'true',
                  'orderBy': 'fieldOrder',
                  'descending': 'true',
                },
              ),
            ),
            await unit.shareQuery(
              QueryInfo.fromJson(
                const {
                  'collection': 'collection',
                  'fieldPath': 'fieldPath',
                  'operator': '=',
                  'queryValue': null,
                  'order': 'true',
                  'orderBy': 'fieldOrder',
                  'descending': 'true',
                },
              ),
            ),
          );

          expect(unit.shareObject(Object()), throwsUnimplementedError);
        },
      );
    },
  );
}

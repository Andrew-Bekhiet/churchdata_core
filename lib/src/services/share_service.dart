import 'package:churchdata_core/churchdata_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get_it/get_it.dart';
import 'package:share_plus/share_plus.dart';

class ShareService {
  ShareService({
    required this.projectId,
    required this.uriPrefix,
    String? packageName,
    Uri? fallbackUrl,
  })  : packageName =
            packageName ?? 'com.AndroidQuartz.' + projectId.toLowerCase(),
        androidParameters = AndroidParameters(
          packageName:
              packageName ?? 'com.AndroidQuartz.' + projectId.toLowerCase(),
          fallbackUrl: fallbackUrl ??
              Uri.parse(
                'https://github.com/Andrew-Bekhiet/' +
                    projectId +
                    '/releases/latest',
              ),
        ),
        iosParameters = IOSParameters(
          bundleId:
              packageName ?? 'com.AndroidQuartz.' + projectId.toLowerCase(),
        );

  final String projectId;
  final String uriPrefix;
  final IOSParameters iosParameters;
  final String packageName;
  final AndroidParameters androidParameters;

  Future<Uri> sharePerson(PersonBase person) async {
    return (await GetIt.I<FirebaseDynamicLinks>().buildShortLink(
      DynamicLinkParameters(
        uriPrefix: uriPrefix,
        link: Uri.https(
          projectId.toLowerCase() + '.com',
          'PersonInfo',
          {'Id': person.id},
        ),
        androidParameters: androidParameters,
        iosParameters: iosParameters,
      ),
      shortLinkType: ShortDynamicLinkType.unguessable,
    ))
        .shortUrl;
  }

  Future<Uri> shareQuery(QueryInfo query) async {
    return (await GetIt.I<FirebaseDynamicLinks>().buildShortLink(
      DynamicLinkParameters(
        uriPrefix: uriPrefix,
        link: Uri.https(projectId + '.com', 'viewQuery', query.toJson()),
        androidParameters: androidParameters,
        iosParameters: iosParameters,
      ),
      shortLinkType: ShortDynamicLinkType.unguessable,
    ))
        .shortUrl;
  }

  Future<Uri> shareUser(UserBase user) async {
    return (await GetIt.I<FirebaseDynamicLinks>().buildShortLink(
      DynamicLinkParameters(
        uriPrefix: uriPrefix,
        link: Uri.https(
          projectId + '.com',
          'UserInfo',
          {'UID': user.uid},
        ),
        androidParameters: androidParameters,
        iosParameters: iosParameters,
      ),
      shortLinkType: ShortDynamicLinkType.unguessable,
    ))
        .shortUrl;
  }

  Future<Uri> shareObject<T>(T object) async {
    if (object is PersonBase)
      return sharePerson(object);
    else if (object is UserBase)
      return shareUser(object);
    else if (object is QueryInfo) return shareQuery(object);

    throw UnimplementedError(
      'Expected an object of type PersonBase, UserBase or QuerInfo, but instead got type' +
          object.runtimeType.toString(),
    );
  }

  Future<void> shareText(String text) async {
    await Share.share(text);
  }
}

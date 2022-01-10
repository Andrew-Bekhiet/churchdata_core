import 'package:churchdata_core/churchdata_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

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
    return (await FirebaseDynamicLinks.instance.buildShortLink(
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
    return (await FirebaseDynamicLinks.instance.buildShortLink(
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
    return (await FirebaseDynamicLinks.instance.buildShortLink(
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
}

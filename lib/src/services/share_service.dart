import 'package:churchdata_core/churchdata_core.dart';
import 'package:share_plus/share_plus.dart';

class ShareService {
  final String baseDomain;

  ShareService({required this.baseDomain});

  Future<Uri> sharePerson(PersonBase person) async {
    return Uri.https(baseDomain, 'PersonInfo', {'Id': person.id});
  }

  Future<Uri> shareQuery(QueryInfo query) async {
    return Uri.https(baseDomain, 'viewQuery', query.toJson());
  }

  Future<Uri> shareUser(UserBase user) async {
    return Uri.https(baseDomain, 'UserInfo', {'UID': user.uid});
  }

  Future<Uri> shareObject<T>(T object) async {
    switch (T) {
      case PersonBase:
        return sharePerson(object as PersonBase);
      case UserBase:
        return shareUser(object as UserBase);
      case QueryInfo:
        return shareQuery(object as QueryInfo);
      default:
        throw UnimplementedError(
          'Expected an object of type PersonBase, UserBase or QuerInfo, but instead got type' +
              object.runtimeType.toString(),
        );
    }
  }

  Future<void> shareText(String text) async {
    await SharePlus.instance.share(ShareParams(text: text));
  }
}

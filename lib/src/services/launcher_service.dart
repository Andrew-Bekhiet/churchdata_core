// coverage:ignore-file
import 'package:url_launcher/url_launcher.dart' as l;

class LauncherService {
  Future<bool> launch(String url) async {
    return l.launchUrl(Uri.parse(url));
  }

  Future<bool> launchSMSChat(String fomattedPhone) async {
    return launch('sms:' + fomattedPhone);
  }

  Future<bool> launchWhatsappChat(String fomattedPhone) async {
    return launch('whatsapp://send?phone=+' + fomattedPhone);
  }
}

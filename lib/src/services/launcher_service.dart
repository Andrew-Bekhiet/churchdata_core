// coverage:ignore-file
import 'package:url_launcher/url_launcher.dart' as l;

class LauncherService {
  static LauncherService get I => LauncherService();

  Future<bool> launch(String url) async {
    return launchUrl(Uri.parse(url));
  }

  Future<bool> launchUrl(Uri url) async {
    return l.launchUrl(url, mode: l.LaunchMode.externalApplication);
  }

  Future<bool> launchSMSChat(String fomattedPhone) async {
    return launch('sms:' + fomattedPhone);
  }

  Future<bool> launchWhatsappChat(String fomattedPhone) async {
    return launch('whatsapp://send?phone=+' + fomattedPhone);
  }
}

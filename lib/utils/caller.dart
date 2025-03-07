import 'package:url_launcher/url_launcher.dart';

import 'log_service.dart';

class Caller {
  static Future<void> launchTelegram(String url) async {
    final Uri telegramUrl = Uri.parse("https://t.me/$url");
    if (await canLaunchUrl(telegramUrl)) {
      await launchUrl(telegramUrl, mode: LaunchMode.externalApplication);
    } else {
      Log.e("Could not launch $url");
    }
  }

  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }
}

// platform_service_mobile.dart

import 'package:url_launcher/url_launcher.dart';
import 'platform_service.dart';

class PlatformServiceMobile implements PlatformService {
  @override
  void openExternalUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

PlatformService createPlatformService() => PlatformServiceMobile();


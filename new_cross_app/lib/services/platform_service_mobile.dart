import 'package:url_launcher/url_launcher.dart';
import 'platform_service.dart';

class PlatformServiceMobile implements PlatformService {
  @override
  Future<void> openExternalUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

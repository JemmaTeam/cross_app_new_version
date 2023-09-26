// platform_service_web.dart

import 'dart:js' as js;
import 'platform_service.dart';

class PlatformServiceWeb implements PlatformService {
  @override
  void openExternalUrl(String url) {
    js.context.callMethod('open', [url]);
  }
}

PlatformService createPlatformService() => PlatformServiceWeb();

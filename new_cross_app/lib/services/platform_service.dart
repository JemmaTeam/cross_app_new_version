// platform_service.dart

import 'platform_service_stub.dart'
if (dart.library.js) 'platform_service_web.dart'
if (dart.library.io) 'platform_service_mobile.dart';

abstract class PlatformService {
  void openExternalUrl(String url);

  factory PlatformService() => createPlatformService();
}


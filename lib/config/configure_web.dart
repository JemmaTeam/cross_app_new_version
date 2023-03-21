/// Based on the instructions given in
/// https://flutter.dev/docs/development/ui/navigation/url-strategies#configuring-the-url-strategy

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void configureApp() {
  setUrlStrategy(PathUrlStrategy());
}
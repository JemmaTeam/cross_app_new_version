import 'package:adaptive_breakpoints/adaptive_breakpoints.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/foundation.dart';


/// Modified from https://github.com/flutter/gallery/blob/master/lib/layout/adaptive.dart
/// Returns boolean value on whether the device is most probably a mobile screen or not.
bool isDisplayMobile(BuildContext context) =>
   getWindowType(context) < AdaptiveWindowType.medium;


/// Returns whether app's platform is a web platform or not.
bool isWeb() => kIsWeb;

/// Returns a boolean value whether the window is considered medium or large size.
///
/// TODO: Consider type of the platform; If browser minimises then, and if screen width is less than a certain threshold, display is considered as mobile.
///
bool isDisplayDesktop(BuildContext context) =>
    getWindowType(context) >= AdaptiveWindowType.medium;

DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

/// Returns whether app is running on a mobile native.
bool isMobileNative() => (defaultTargetPlatform == TargetPlatform.iOS) || (defaultTargetPlatform == TargetPlatform.android);

/// Returns a future which detects if the web app's user agent is based on a mobile device.
/// TODO: Some optimisation; Better to compute this once per app lifecycle.
Future<bool> _isWebAppMobile() async {
  WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
  //logger.d(webBrowserInfo.userAgent);
  return webBrowserInfo.userAgent?.toLowerCase().contains("mobile") ?? false;
}





/// An adaptive widget for showing image.
///
/// Assumes that asset has  both a svg and a png/jpg version.
/// [assetName] must be well formed, i.e, it should be of (identifier).(extension) format.
/// Idea of using user agent is from this SO post: https://stackoverflow.com/a/67260733/11200630.
class AdaptiveImage extends StatelessWidget {
  final String assetName;

  const AdaptiveImage({Key? key, required this.assetName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(kIsWeb) {
      var splitAssetName = assetName.split('.');
      assert(splitAssetName.length == 2,"Asset name invalid.");
      return FutureBuilder(
          future:_isWebAppMobile(),
          builder: (BuildContext context, AsyncSnapshot<bool> result){
        switch(result.connectionState){
          case ConnectionState.waiting: return const SizedBox();
          default:
            if( result.data ?? false) {

              return Image.asset(assetName,fit: BoxFit.contain);
            }
            else {

              return  SvgPicture.asset(splitAssetName[0]+".svg",fit: BoxFit.contain);
            }
        }
      });

    }
    return Image.asset(assetName,fit: BoxFit.contain);
  }
}





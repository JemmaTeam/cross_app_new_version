import 'package:flutter/material.dart';
// import 'package:flutter_slider_drawer_v/flutter_slider_drawer_v.dart';
import 'package:new_cross_app/Profile/utils/adaptive.dart';
import 'package:new_cross_app/Profile/widgets/jemma_logo.dart';
// import 'package:new_cross_app/Profile/widgets/nav_bar.dart';

class AdaptiveDrawer extends StatelessWidget {
  const AdaptiveDrawer({Key? key, required this.child}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    // if (isMobileNative()) {
    //   return SliderMenuContainer(
    //       appBarColor: Colors.white,
    //       sliderMenuOpenSize: 200,
    //       title: const JemmaLogo(width: 100, height: 100),
    //       sliderMenu: NavBar(),
    //       sliderMain: child);
    // }
    return child;
  }
}

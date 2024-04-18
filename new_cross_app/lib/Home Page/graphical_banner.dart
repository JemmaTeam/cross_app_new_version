import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_cross_app/Home Page/home.dart';
import 'package:new_cross_app/Home Page/decorations.dart';

/// Reusable widget which is primarily used for aesthetics.
class GraphicalBanner extends StatelessWidget {
  //static bannerHeight = MediaQuery.of(context).size.height*0.5;
  const GraphicalBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height; // 获取屏幕高度用于字体大小计算

    return Container(
        height: screenHeight * 0.2,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: const DecorationImage(
                image: AssetImage("assets/images/banner_background.png"),
                fit: BoxFit.cover),
            boxShadow: defaultShadows,
            borderRadius: BorderRadius.circular(HomeState.borderRadius)),

        // AnimatedText container
        child:Container(
          margin: const EdgeInsets.all(20.0),
          child: FittedBox(
            child: Align(
              alignment: const Alignment(0, -.55),
              child: DefaultTextStyle(
                  style: GoogleFonts.parisienne(
                      fontSize: screenHeight * 0.02, // 使用 screenHeight 的百分比来调整字体大小
                      color: Colors.black),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText("Jemma",
                          speed: const Duration(milliseconds: 500)),
                      TypewriterAnimatedText("Life made easier.",
                          speed: const Duration(milliseconds: 150)),
                      TypewriterAnimatedText("Get things fixed quicker.",
                          speed: const Duration(milliseconds: 150))
                    ],
                    pause: const Duration(seconds: 5),
                    repeatForever: true,
                  )),
            ),
          ),
        ));
  }
}

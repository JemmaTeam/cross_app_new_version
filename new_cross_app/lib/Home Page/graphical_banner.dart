import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_cross_app/Home Page/home.dart';
import 'package:new_cross_app/Home Page/decorations.dart';
import 'package:sizer/sizer.dart';

/// Reusable widget which is primarily used for aesthetics.
class GraphicalBanner extends StatelessWidget {
  //static bannerHeight = MediaQuery.of(context).size.height*0.5;
  const GraphicalBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return /*Container(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: const DecorationImage(
                image: AssetImage("assets/images/banner_background.png"),
                fit: BoxFit.fill),
            boxShadow: defaultShadows,
            borderRadius: BorderRadius.circular(HomeState.borderRadius)),*/

        // AnimatedText container
        Container(
          margin: EdgeInsets.all(10.0),
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: const DecorationImage(
                  image: AssetImage("assets/images/banner_background.png"),
                  fit: BoxFit.fill),
              boxShadow: defaultShadows,
              borderRadius: BorderRadius.circular(HomeState.borderRadius)),
          child: FittedBox(
            child: Align(
              alignment: const Alignment(0, -.55),
              child: DefaultTextStyle(
                  style: GoogleFonts.parisienne(
                      fontSize: 20.sp, color: Colors.black),
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
        );
  }
}

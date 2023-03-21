import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jemma/screens/home.dart';
import 'package:jemma/utils/decorations.dart';
import 'package:sizer/sizer.dart';

/// Reusable widget which is primarily used for aesthetics.
class GraphicalBanner extends StatelessWidget {

  static const bannerHeight = 175.0;
  const GraphicalBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: bannerHeight,
        decoration: BoxDecoration(
            image: const DecorationImage(
                image: AssetImage("assets/images/banner_background.png"),
                fit: BoxFit.fill
            ),
            boxShadow: defaultShadows,
            borderRadius: BorderRadius.circular(Home.borderRadius)),

        // AnimatedText container
        child: Container(
          child: Align(
            alignment: const Alignment(0,-.55),
            child:
            DefaultTextStyle(
                style: GoogleFonts.parisienne(fontSize: 20.sp,color: Colors.black),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText("Jemma",speed: const Duration(milliseconds: 500)),
                    TypewriterAnimatedText("Life made easier.",speed: const Duration(milliseconds: 150)),
                    TypewriterAnimatedText("Get things fixed quicker.",speed: const Duration(milliseconds: 150))
                  ],
                  pause: const Duration(seconds: 10),
                  repeatForever: true,
                )
            ),
          ),
        ),
      );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_cross_app/Home Page/adaptive.dart';
import 'package:new_cross_app/Home Page/decorations.dart';
import 'package:new_cross_app/Home Page/responsive.dart';
import 'package:new_cross_app/Home Page/jemma_logo.dart';

/// Widget which describes what Jemma is and how it started,
class AboutJemma extends StatelessWidget {
  const AboutJemma({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        padding:
            EdgeInsets.symmetric(horizontal: 5.pw(size), vertical: 1.pw(size)),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: defaultShadows,
            borderRadius: BorderRadius.circular(40)),
        width: double.infinity,
        height: size.height,
        child: ListView(
          children: [
            SizedBox(
              height: 1.5.ph(size),
            ),
            Center(
                child: Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    children: [
                      const Text(
                          'About  ',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                      Text(
                          'Jemma ',
                          style: GoogleFonts.parisienne(fontSize: 20, fontWeight: FontWeight.w600)),
                      const Text(
                          'and how it started?',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600))
            ])),
            SizedBox(
              height: 1.5.ph(size),
            ),
            _buildAboutJemmaOverflowBar(size),
            SizedBox(
              height: 1.5.ph(size),
            ),
            _buildHowItStartedOverflowBar(size),
          ],
        ));
  }

  Container _buildHowItStartedOverflowBar(Size size) {
    return Container(
      child: OverflowBar(
        overflowDirection: VerticalDirection.up,
        overflowAlignment: OverflowBarAlignment.center,
        children: [
          ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 250, maxHeight: 200),
              child: const AdaptiveImage(
                assetName: "assets/images/electrician_idea.png",
              )),
          Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 5.pw(size), vertical: 1.pw(size)),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: defaultShadows,
                  borderRadius: BorderRadius.circular(10)),
              constraints: const BoxConstraints(maxWidth: 450),
              child: Column(
                children: [
                  Container(
                    child: Center(
                      child: SelectableText(
                          "\"We’ve heard the problems from both sides and it’s about time someone fixed them. We’re here to help make everyone’s lives easier.\"",
                          style:
                              GoogleFonts.roboto(fontStyle: FontStyle.italic)),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const CircleAvatar(
                        // TODO: Possibly change to Jay's image
                        backgroundImage:
                            AssetImage("assets/images/jay_profile_picture.png"),
                        minRadius: 25,
                      ),
                      SizedBox(width: 1.pw(size)),
                      const Flexible(
                          child: Text(
                        "Jay Cooper,\nFounder of Jemma. ",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ))
                    ]),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  Container _buildAboutJemmaOverflowBar(Size size) {
    return Container(
      child: OverflowBar(
        overflowAlignment: OverflowBarAlignment.center,
        spacing: 1.5.pw(size),
        alignment: MainAxisAlignment.center,
        children: [
          Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 5.pw(size), vertical: 1.pw(size)),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: defaultShadows,
                  borderRadius: BorderRadius.circular(10)),
              child: OverflowBar(
                overflowSpacing: 1.ph(size),
                overflowAlignment: OverflowBarAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    constraints: BoxConstraints(maxWidth: size.height * 0.2),
                    child: Center(
                        child: JemmaLogo(
                            height: size.height * 0.15,
                            width: size.height * 0.15)),
                  ),
                  SizedBox(
                    width: size.width * 0.3,
                    child: Center(
                      child: SelectableText(
                        "Jemma is one of a kind online service that connects customers and tradies while also offering financial protection, better work-life balance, automated scheduling and much more.",
                        style: GoogleFonts.roboto(),
                      ),
                    ),
                  ),
                ],
              )),
          Container(
            width: 250,
            height: 200,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/unisex_tradie_decor.png"),
                fit: BoxFit.cover,
              ),
              // Other decoration properties like color, borderRadius, boxShadow, etc.
            ),
            // Other child widgets can be added here if needed
          )
        ],
      ),
    );
  }
}

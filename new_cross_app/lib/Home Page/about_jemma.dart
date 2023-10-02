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
        width: size.width,
        height: size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: 1.5.ph(size),),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                    child: Center(
                        child: Wrap(
                            alignment: WrapAlignment.spaceEvenly,
                            children: [
                              const Text('About  ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                              Text('Jemma ', style: GoogleFonts.parisienne(fontSize: 20,  fontWeight: FontWeight.w600)),
                              const Text('and how it started?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600))]))),
                SizedBox(height: 1.5.ph(size),),
                Flexible(
                    flex: 3,
                    fit: FlexFit.tight,
                    child: _buildAboutJemmaOverflowBar(size)),
                SizedBox(height: 1.5.ph(size),),
                Flexible(
                    flex: 3,
                    fit: FlexFit.tight,
                    child: _buildHowItStartedOverflowBar(size)),
              ],
            ),
    );
  }

  Row _buildHowItStartedOverflowBar(Size size) {
    return Row(
      //mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      //overflowDirection: VerticalDirection.up,
      //overflowAlignment: OverflowBarAlignment.center,
      children: [
        const Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: AdaptiveImage(
              assetName: "assets/images/electrician_idea.png",
            )),
        Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.pw(size), vertical: 1.pw(size)),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: defaultShadows,
                  borderRadius: BorderRadius.circular(10)),
              constraints: const BoxConstraints(maxWidth: 450),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      child: Center(
                        child: SelectableText(
                            "\"We’ve heard the problems from both sides and it’s about time someone fixed them. We’re here to help make everyone’s lives easier.\"",
                            style: GoogleFonts.roboto(fontStyle: FontStyle.italic),
                            textScaleFactor: 1.5,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const CircleAvatar(
                          // TODO: Possibly change to Jay's image
                          backgroundImage: AssetImage("assets/images/jay_profile_picture.png"),
                          maxRadius: 25,
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
                  ),
                ],
              ),
            ))
      ],
    );
  }

  Row _buildAboutJemmaOverflowBar(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      //overflowAlignment: OverflowBarAlignment.center,
      //spacing: 1.5.pw(size),
      //alignment: MainAxisAlignment.center,
      children: [
        Flexible(
          flex: 3,
          child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 5.pw(size), vertical: 1.pw(size)),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: defaultShadows,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                //overflowSpacing: 1.ph(size),
                //overflowAlignment: OverflowBarAlignment.center,
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      constraints: BoxConstraints(maxWidth: size.height * 0.2),
                      child: Center(
                          child: JemmaLogo(
                              height: size.height * 0.15,
                              width: size.height * 0.15)),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Container(
                      width: size.width*0.6,
                      child: SelectableText(
                        "Jemma is one of a kind online service that connects customers and tradies while also offering financial protection, better work-life balance, automated scheduling and much more.",
                        style: GoogleFonts.roboto(),
                      ),
                    ),
                  ),
                ],
              )),
        ),

        /*ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 250, maxHeight: 200),
            child: const AdaptiveImage(
              assetName: "assets/images/unisex_tradie_decor.png",
            )),*/
        const Flexible(
          flex: 1,
          child: AdaptiveImage(
            assetName: 'assets/images/unisex_tradie_decor.png',
          ),
        )
      ],
    );
  }
}

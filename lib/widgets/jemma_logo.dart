import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jemma/utils/constants.dart';
import 'package:jemma/utils/decorations.dart';

class JemmaLogo extends StatelessWidget {

  const JemmaLogo({Key? key,
    required this.height,
    required this.width
  }) : super(key: key);

  final height;
  final width;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: kLogoColor,
            boxShadow: defaultShadows,
            borderRadius: BorderRadius.circular(15)
        ),
        padding: const EdgeInsets.all(10),
        child:
        FittedBox(
          fit: BoxFit.contain,
          child:  Text( 'J', style: GoogleFonts.parisienne()),
        )

    );
  }
}

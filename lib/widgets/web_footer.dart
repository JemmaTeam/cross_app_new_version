import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jemma/screens/contact_us.dart';
import 'package:jemma/screens/help.dart';
import 'package:jemma/utils/constants.dart';
import 'package:sizer/sizer.dart';
import 'package:jemma/utils/responsive.dart';

import '../routes.dart';

class WebFooter extends StatelessWidget {
  const WebFooter({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: 4.h,
      color: kLogoColor,
      padding: EdgeInsets.symmetric(
        horizontal: 4.h,
      ),
      child: Row(
        children: [
          Text("J",style: GoogleFonts.parisienne(fontWeight: FontWeight.w700),),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 50
            ),
            child: Row(
              children: [
                _FooterTag(
                  text: 'Contact Us',
                  press: () => Navigator.pushNamed(
                    context,
                    Screen.contactUs.getURL(),
                  )
                  ),
                _FooterTag(
                  text: 'Help',
                  press: () => Navigator.pushNamed(
                    context,
                    Screen.help.getURL(),
                  )
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}

class _FooterTag extends StatelessWidget {
  final String text;
  final VoidCallback press;

  const _FooterTag({
    Key? key,
    required this.text,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        onPressed: press,
        child: Text(
          text,
          style: TextStyle(
            color: kTextColor,
            fontSize: 15,
          ),
        ),
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all<Color>(Color(0x00000000))
        ),
      ),
    );
  }
}

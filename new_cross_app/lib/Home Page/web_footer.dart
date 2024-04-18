import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:new_cross_app/contact_us.dart';
import 'package:new_cross_app/Home Page/help.dart';
import 'package:new_cross_app/Home Page/constants.dart';
//import 'package:sizer/sizer.dart';
import 'package:new_cross_app/Home Page/responsive.dart';

//import '../routes.dart';

class WebFooter extends StatelessWidget {
  const WebFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.04, // 使用 MediaQuery 替换 Sizer 的 .h 方法
      color: kLogoColor,
      padding: EdgeInsets.symmetric(
        horizontal: size.height * 0.04, // 使用 MediaQuery 替换 Sizer 的 .h 方法
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
                  text: 'Contact Us', press: () {  },
                  /*press: () => Navigator.pushNamed(
                    context,
                    Screen.contactUs.getURL(),*/
                ),
                _FooterTag(
                  text: 'Help', press: () {  },
                  /*press: () => Navigator.pushNamed(
                    context,
                    Screen.help.getURL(),*/
                )
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

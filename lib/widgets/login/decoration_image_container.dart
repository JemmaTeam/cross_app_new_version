import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jemma/screens/login.dart';
import 'package:jemma/utils/responsive.dart';

///  Decoration Image for the [Login] screen.
class DecorationImageContainer extends StatelessWidget {
  const DecorationImageContainer({
    Key? key,
    required this.size,
  }) : super(key: key);
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: min(17.5.pw(size),17.5.ph(size)),
        child:Image.asset("assets/images/female_builder.png")
    );
  }
}
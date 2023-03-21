import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:jemma/utils/responsive.dart';

class DecorationImageContainer extends StatelessWidget {
  final Size size;

  const DecorationImageContainer({
    Key? key,
    required this.size,
  }): super(key: key);

  @override
  Container build(BuildContext context) {
    return Container(
      width: min(17.5.pw(size), 17.5.ph(size)),
      child: Image.asset("assets/images/female_builder.png")
    );
  }
}
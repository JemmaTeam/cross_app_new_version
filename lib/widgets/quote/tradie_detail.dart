import 'package:flutter/material.dart';
import 'package:jemma/utils/adaptive.dart';
import 'package:jemma/utils/responsive.dart';

class TradieDetail extends StatelessWidget {
  const TradieDetail({
    Key? key,
    required this.tradieId,
    required this.size,
  }) : super(key: key);

  final String tradieId;
  final Size size;

  @override
  Widget build(BuildContext context) {
    final borderRadius = 40.0;

    return Container(
      padding: EdgeInsets.symmetric(
          // horizontal: 5.pw(size),
          vertical: 1.pw(size)
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius)
      ),

      child: Row(children: [
        // TODO: replace with actual tradie info
        Spacer(),
        Flexible(
          child: CircleAvatar(backgroundImage: AssetImage("assets/images/user_profile.png"),),
        ),
        Spacer(),

        Flexible(
          flex: 2,
          child: Column(children: [
            // TODO: replace with actual tradie's info
            Text(
              'James Smith',
              style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600),
            ),
            Text(
              'Acton ACT',
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
          ]),
        ),

        Spacer(),

        if (isDisplayDesktop(context)) ...[
          Flexible(
            child: Text(
              'Joined since 2020',
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
          ),
          Spacer(),
        ]
      ],)

    );
  }
}

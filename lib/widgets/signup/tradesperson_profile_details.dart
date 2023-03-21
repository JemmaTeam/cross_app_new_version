import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jemma/utils/responsive.dart';

import 'package:string_validator/string_validator.dart';

class TradespersonProfileDetails extends StatelessWidget {
  final TextEditingController travelDistance;

  const TradespersonProfileDetails({
    Key? key,
    required this.travelDistance
  }): super(key: key);

  @override
  Container build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      alignment: Alignment.centerLeft,
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        spacing: 10,
        children: <Container>[
          /* Travel Distance */
          Container(
            width: 50.ph(size),
            margin: EdgeInsets.only(bottom: max(1.5.ph(size), 10)),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.next,
              controller: this.travelDistance,
              maxLength: 4,
              validator: (String? value) {
                if ((value == null) || (value.length <= 0))
                  return null;
                else if (!isNumeric(value))
                  return "The value should only have numbers.";
                return null;
              },
              decoration: InputDecoration(
                labelText: "Travel Distance",
                hintText: "Enter your Travel Distance.",
                labelStyle: TextStyle(fontSize: 14),
                prefixIcon: Icon(Icons.pin_drop),
                border: OutlineInputBorder()
              )
            )
          )

        ]
      )
    );
  }
}
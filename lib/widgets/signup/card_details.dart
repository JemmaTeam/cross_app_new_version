import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jemma/utils/responsive.dart';

import 'package:string_validator/string_validator.dart';

class CardDetails extends StatelessWidget {
  final TextEditingController cardName, cardNumber, cardValidDate, cardCVV;

  const CardDetails({
    Key? key,
    required this.cardName,
    required this.cardNumber,
    required this.cardValidDate,
    required this.cardCVV,
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
          /* Card Holder Name */
          Container(
            width: 50.ph(size),
            margin: EdgeInsets.only(bottom: max(1.5.ph(size), 10)),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.next,
              controller: this.cardName,
              maxLength: 40,
              validator: (String? value) {
                if ((value == null) || (value.length <= 0))
                  return null;
                else if (!isAlpha(value))
                  return "The value should only have alphabets.";
                return null;
              },
              decoration: InputDecoration(
                labelText: "Card Holder Name",
                hintText: "Enter your Card Holder Name.",
                labelStyle: TextStyle(fontSize: 14),
                prefixIcon: Icon(Icons.account_circle),
                border: OutlineInputBorder()
              )
            )
          ),

          /* Card Number */
          Container(
            width: 50.ph(size),
            margin: EdgeInsets.only(bottom: max(1.5.ph(size), 10)),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.next,
              controller: this.cardNumber,
              maxLength: 16,
              validator: (String? value) {
                if ((value == null) || (value.length <= 0))
                  return null;
                else if (!isNumeric(value))
                  return "The value should only have numbers.";
                else if (value.length != 16)
                  return "The value should only contain 16 numbers.";
                return null;
              },
              decoration: InputDecoration(
                labelText: "Card Number",
                hintText: "Enter your Card Number.",
                labelStyle: TextStyle(fontSize: 14),
                prefixIcon: Icon(Icons.credit_card),
                border: OutlineInputBorder()
              )
            )
          ),

          /* Card Valid Date -> Use Drop Box */
          Container(
            width: 50.ph(size),
            margin: EdgeInsets.only(bottom: max(1.5.ph(size), 10)),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.next,
              controller: this.cardValidDate,
              maxLength: 4,
              validator: (String? value) {
                if ((value == null) || (value.length <= 0))
                  return null;
                else if (!isNumeric(value))
                  return "The value should only have numbers.";
                else if (value.length != 4)
                  return "The value should only contain 4 numbers.";
                return null;
              },
              decoration: InputDecoration(
                labelText: "Card Valid Date",
                hintText: "Enter your Card Valid Date.",
                labelStyle: TextStyle(fontSize: 14),
                prefixIcon: Icon(Icons.date_range),
                border: OutlineInputBorder()
              )
            )
          ),

          /* Card CVV */
          Container(
            width: 50.ph(size),
            margin: EdgeInsets.only(bottom: max(1.5.ph(size), 10)),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.next,
              controller: this.cardCVV,
              maxLength: 3,
              validator: (String? value) {
                if ((value == null) || (value.length <= 0))
                  return null;
                else if (!isNumeric(value))
                  return "The value should only have numbers.";
                else if (value.length != 3)
                  return "The value should only contain 3 numbers.";
                return null;
              },
              decoration: InputDecoration(
                labelText: "Card CVV",
                hintText: "Enter your Card CVV.",
                labelStyle: TextStyle(fontSize: 14),
                prefixIcon: Icon(Icons.fiber_pin),
                border: OutlineInputBorder()
              )
            )
          )

        ]
      )
    );
  }
}
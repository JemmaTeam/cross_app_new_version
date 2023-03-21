import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jemma/utils/responsive.dart';

import 'package:string_validator/string_validator.dart';

class BankDetails extends StatelessWidget {
  final TextEditingController bankName, bankNumber, bankBSB;

  const BankDetails({
    Key? key,
    required this.bankName,
    required this.bankNumber,
    required this.bankBSB
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
          /* Bank Account Name */
          Container(
            width: 50.ph(size),
            margin: EdgeInsets.only(bottom: max(1.5.ph(size), 10)),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.next,
              controller: this.bankName,
              maxLength: 50,
              validator: (String? value) {
                if ((value == null) || (value.length <= 0))
                  return null;
                return null;
              },
              decoration: InputDecoration(
                labelText: "Bank Account Name",
                hintText: "Enter your Bank Account Name.",
                labelStyle: TextStyle(fontSize: 14),
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder()
              )
            )
          ),

          /* Bank Account Number */
          Container(
            width: 50.ph(size),
            margin: EdgeInsets.only(bottom: max(1.5.ph(size), 10)),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.next,
              controller: this.bankNumber,
              maxLength: 11,
              validator: (String? value) {
                if ((value == null) || (value.length <= 0)) return null;
                else if (!isNumeric(value)) return "The value should only have numbers.";
                else if (value.length != 11) return "The value should only contain 11 numbers.";
                return null;
              },
              decoration: InputDecoration(
                labelText: "Bank Account Number",
                hintText: "Enter your Bank Account Number.",
                labelStyle: TextStyle(fontSize: 14),
                prefixIcon: Icon(Icons.credit_card),
                border: OutlineInputBorder()
              )
            )
          ),

          /* Bank Account BSB */
          Container(
            width: 50.ph(size),
            margin: EdgeInsets.only(bottom: max(1.5.ph(size), 10)),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.next,
              controller: this.bankBSB,
              maxLength: 6,
              validator: (String? value) {
                if ((value == null) || (value.length <= 0))
                  return null;
                else if (!isNumeric(value))
                  return "The value should only have numbers.";
                else if (value.length != 6)
                  return "The value should only contain 6 numbers.";
                return null;
              },
              decoration: InputDecoration(
                labelText: "Bank Account BSB",
                hintText: "Enter your Bank Account BSB.",
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
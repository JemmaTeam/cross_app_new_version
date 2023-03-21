import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jemma/utils/responsive.dart';

import 'package:string_validator/string_validator.dart';

class CompanyDetails extends StatelessWidget {
  final TextEditingController companyName, companyABN;

  const CompanyDetails({
    Key? key,
    required this.companyName,
    required this.companyABN
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
          /* Company Name */
          Container(
            width: 50.ph(size),
            margin: EdgeInsets.only(bottom: max(1.5.ph(size), 10)),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.next,
              controller: this.companyName,
              maxLength: 100,
              validator: (String? value) {
                if ((value == null) || (value.length <= 0))
                  return "This value is required";
                else if (!isAlpha(value))
                  return "The value should only have alphabets.";
                return null;
              },
              decoration: InputDecoration(
                labelText: "Company Name",
                hintText: "Enter your Company Name.",
                labelStyle: TextStyle(fontSize: 14),
                prefixIcon: Icon(Icons.business),
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
              controller: this.companyABN,
              maxLength: 11,
              validator: (String? value) {
                if ((value == null) || (value.length <= 0))
                  return "This value is required.";
                else if (!isNumeric(value))
                  return "The value should only have numbers.";
                else if (value.length != 11)
                  return "The value should only contain 11 characters.";
                return null;
              },
              decoration: InputDecoration(
                labelText: "Company ABN",
                hintText: "Enter your Company ABN.",
                labelStyle: TextStyle(fontSize: 14),
                prefixIcon: Icon(Icons.business),
                border: OutlineInputBorder()
              )
            )
          )

        ]
      )
    );
  }
}
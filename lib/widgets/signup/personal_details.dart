import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jemma/screens/signup.dart';
import 'package:jemma/utils/responsive.dart';

import 'package:string_validator/string_validator.dart';

class PersonalDetails extends StatelessWidget {
  final SignupOf signupOf;
  final TextEditingController firstName, lastName, phone;

  const PersonalDetails({
    Key? key,
    required this.signupOf,
    required this.firstName,
    required this.lastName,
    required this.phone,
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
          /* Firstname */
          Container(
            width: 50.ph(size),
            margin: EdgeInsets.only(bottom: max(1.5.ph(size), 10)),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.next,
              controller: this.firstName,
              maxLength: 50,
              validator: (String? value) {
                if (
                  (this.signupOf == SignupOf.tradesperson) &&
                  ((value == null) || (value.length <= 0))
                ) return "This value is required";
                else if ((value == null) || (value.length <= 0))
                  return null;
                else if (!isAlpha(value))
                  return "The value should only have alphabets.";
                return null;
              },
              decoration: InputDecoration(
                labelText: "First Name",
                hintText: "Enter your First Name.",
                labelStyle: TextStyle(fontSize: 14),
                prefixIcon: Icon(Icons.account_circle),
                border: OutlineInputBorder()
              )
            )
          ),

          /* Lastname */
          Container(
            width: 50.ph(size),
            margin: EdgeInsets.only(bottom: max(1.5.ph(size), 10)),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.next,
              controller: this.lastName,
              maxLength: 50,
              validator: (String? value) {
                if (
                  (this.signupOf == SignupOf.tradesperson) &&
                  ((value == null) || (value.length <= 0))
                ) return "This value is required";
                else if ((value == null) || (value.length <= 0))
                  return null;
                else if (!isAlpha(value))
                  return "The value should only have alphabets.";
                return null;
              },
              decoration: InputDecoration(
                labelText: "Last Name",
                hintText: "Enter your Last Name.",
                labelStyle: TextStyle(fontSize: 14),
                prefixIcon: Icon(Icons.account_circle),
                border: OutlineInputBorder()
              )
            )
          ),

          /* Phone number */
          Container(
            width: 50.ph(size),
            margin: EdgeInsets.only(bottom: max(1.5.ph(size), 10)),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.next,
              controller: this.phone,
              maxLength: 10,
              validator: (String? value) {
                if (
                  (this.signupOf == SignupOf.tradesperson) &&
                  ((value == null) || (value.length <= 0))
                ) return "This value is required";
                else if ((value == null) || (value.length <= 0))
                  return null;
                else if (!isNumeric(value))
                  return "The value should only have numbers.";
                else if (value.length != 10)
                  return "The value should only contain 10 numbers.";
                return null;
              },
              decoration: InputDecoration(
                labelText: "Phone number",
                hintText: "Enter your Phone number.",
                labelStyle: TextStyle(fontSize: 14),
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder()
              )
            )
          )

        ]
      )
    );
  }
}
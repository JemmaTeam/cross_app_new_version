import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jemma/utils/responsive.dart';

import 'package:string_validator/string_validator.dart';

/* Address Object */
class Address {
  final TextEditingController address_line_one = new TextEditingController(),
                              address_line_two = new TextEditingController(),
                              suburb = new TextEditingController(),
                              postcode = new TextEditingController();
  String? state = null;
}

class AddressDetails extends StatefulWidget {
  final Address address;

  AddressDetails({
    Key? key,
    required this.address
  }) : super(key: key);

  @override
  State<AddressDetails> createState() => AddressDetailsState();
}

class AddressDetailsState extends State<AddressDetails> {

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
          /* Address line one */
          Container(
              width: 50.ph(size),
              margin: EdgeInsets.only(bottom: max(1.5.ph(size), 10)),
              child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textInputAction: TextInputAction.next,
                  controller: this.widget.address.address_line_one,
                  validator: (String? value) {
                    if ((value == null) || (value.length <= 0))
                      return null;
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: "Address line one",
                      hintText: "Enter your address line one.",
                      labelStyle: TextStyle(fontSize: 14),
                      prefixIcon: Icon(Icons.edit_road),
                      border: OutlineInputBorder()
                  )
              )
          ),

          /* Address line two */
          Container(
            width: 50.ph(size),
            margin: EdgeInsets.only(bottom: max(1.5.ph(size), 10)),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.next,
              controller: this.widget.address.address_line_two,
              validator: (String? value) {
                if ((value == null) || (value.length <= 0))
                  return null;
                return null;
              },
              decoration: InputDecoration(
                labelText: "Address line two",
                hintText: "Enter your address line two.",
                labelStyle: TextStyle(fontSize: 14),
                prefixIcon: Icon(Icons.edit_road),
                border: OutlineInputBorder()
              )
            )
          ),

          /* Suburb name */
          Container(
            width: 50.ph(size),
            margin: EdgeInsets.only(bottom: max(1.5.ph(size), 10)),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.next,
              controller: this.widget.address.suburb,
              validator: (String? value) {
                if ((value == null) || (value.length <= 0))
                  return null;
                else if (!isAlpha(value))
                  return "The value should only have alphabets.";
                return null;
              },
              decoration: InputDecoration(
                labelText: "Suburb name",
                hintText: "Enter your Suburb name.",
                labelStyle: TextStyle(fontSize: 14),
                prefixIcon: Icon(Icons.location_city),
                border: OutlineInputBorder()
              )
            )
          ),

          /* State name */
          Container(
            width: 50.ph(size),
            margin: EdgeInsets.only(bottom: max(1.5.ph(size), 10)),
            child: DropdownButton(
              value: this.widget.address.state,
              isExpanded: true,
              onChanged: (value) => setState(() { this.widget.address.state = value.toString(); }),
              underline: SizedBox(),
              hint: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Row(
                  children: <Expanded>[
                    Expanded(child: Icon(Icons.location_on), flex: 2),
                    Expanded(child: Text("State", textAlign: TextAlign.left, style: TextStyle(fontSize: 14)), flex: 8)
                  ]
                )
              ),
              items: <String>["ACT", "NSW", "QLD", "VIC", "NT", "WA", "SA", "TAS"].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: <Expanded>[
                      Expanded(child: Icon(Icons.location_on), flex: 2),
                      Expanded(child: Text(value, textAlign: TextAlign.left, style: TextStyle(fontSize: 14)), flex: 8)
                    ]
                  )
                );
              }).toList(),
            )
          ),

          /* Postcode number */
          Container(
            width: 50.ph(size),
            margin: EdgeInsets.only(bottom: max(1.5.ph(size), 10)),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.next,
              controller: this.widget.address.postcode,
              maxLength: 4,
              validator: (String? value) {
                if ((value == null) || (value.length <= 0))
                  return null;
                else if (!isNumeric(value))
                  return "The value should only have numbers.";
                else if (value.length != 4)
                  return "The value should contain 4 numbers.";
                return null;
              },
              decoration: InputDecoration(
                labelText: "Postcode number",
                hintText: "Enter your Postcode number.",
                labelStyle: TextStyle(fontSize: 14),
                prefixIcon: Icon(Icons.local_post_office),
                border: OutlineInputBorder()
              )
            )
          )

        ]
      )
    );
  }
}
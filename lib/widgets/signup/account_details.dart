import 'dart:math';
import 'package:flutter/material.dart';
import 'package:jemma/utils/responsive.dart';
import 'package:string_validator/string_validator.dart';

class AccountDetails extends StatefulWidget {
  final TextEditingController email, password;

  AccountDetails({
    Key? key,
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  State<AccountDetails> createState() => AccountDetailsState();
}

class AccountDetailsState extends State<AccountDetails> {
  bool showPassword = false, showConfirmPassword = false;

  @override
  Container build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
        alignment: Alignment.centerLeft,
        child: Wrap(
            alignment: WrapAlignment.start,
            direction: Axis.horizontal,
            spacing: 10,
            children: <Container>[
              /* Email */
              Container(
                  width: 50.ph(size),
                  margin: EdgeInsets.only(bottom: max(1.5.ph(size), 10)),
                  child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.next,
                      controller: this.widget.email,
                      validator: (String? value) {
                        if ((value == null) || (value.length <= 0))
                          return "This value is required.";
                        else if (!isEmail(value))
                          return "Enter a valid email address.";
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "Enter your email address.",
                          labelStyle: TextStyle(fontSize: 14),
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder()))),

              /* Password */
              Container(
                  width: 50.ph(size),
                  margin: EdgeInsets.only(bottom: max(1.5.ph(size), 10)),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    controller: this.widget.password,
                    obscureText: !this.showPassword,
                    validator: (String? value) {
                      if ((value == null) || (value.length <= 0))
                        return "This value is required.";

                      List<String> o = [];
                      if (!new RegExp(r"(?=.*[a-z])(?=.*[A-Z])\w+")
                          .hasMatch(value))
                        o.add(
                            "- The value must have at least a Lower and Upper case.");
                      if (!new RegExp(r"(?=.*[0-9])\w+").hasMatch(value))
                        o.add(
                            "- The value must have at least a numeric value.");
                      if (!new RegExp(
                              r"(?=.*[#$%&()*+,-./:;<=>?@[\]^_`{|}~])\w+")
                          .hasMatch(value))
                        o.add(
                            "- The value must have at least a special character.");
                      if (value.length < 8)
                        o.add("- The value must be of at least 8 characters.");

                      if (o.length > 0) return o.join("\n");
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Enter your Password.",
                      labelStyle: TextStyle(fontSize: 14),
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                            (this.showPassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                            color: Theme.of(context).primaryColorDark),
                        onPressed: () {
                          this.setState(() {
                            this.showPassword = !this.showPassword;
                          });
                        },
                      ),
                    ),
                  )),

              /* Confirm Password */
              Container(
                  width: 50.ph(size),
                  margin: EdgeInsets.only(bottom: max(1.5.ph(size), 10)),
                  child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.next,
                      controller: new TextEditingController(text: ""),
                      obscureText: !this.showConfirmPassword,
                      validator: (String? value) {
                        if ((value == null) || (value.length <= 0))
                          return "This value is required";
                        else if (value != this.widget.password.text)
                          return "The value does not match the Password";
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        hintText: "Enter to confirm your Password.",
                        labelStyle: TextStyle(fontSize: 14),
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                              (this.showConfirmPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              color: Theme.of(context).primaryColorDark),
                          onPressed: () {
                            this.setState(() {
                              this.showConfirmPassword =
                                  !this.showConfirmPassword;
                            });
                          },
                        ),
                      )))
            ]));
  }
}

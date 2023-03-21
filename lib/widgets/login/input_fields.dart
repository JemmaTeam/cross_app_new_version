import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jemma/screens/login.dart';
import 'package:jemma/utils/responsive.dart';
import 'package:string_validator/string_validator.dart';


/// Email and password TextFormFields, that are part of [Login].
class InputFields extends StatelessWidget {
  
  /// [emailController] which will be used to fetch email input in [Login].
  /// [passwordController] which will be used to fetch the password input in [Login].
  /// [size] is the size of the [Login] screen.
  const InputFields({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.size,
  }) : super(key: key);

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          children: [
            
            // For Email
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.next,
          autofillHints: [AutofillHints.email],
              validator: (value) {
                if (value == null || isEmail(value)) {
                  return null;
                }
                return "Enter a valid email address.";
              },
              controller: emailController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  labelStyle: TextStyle(fontSize: 14),

                  prefixIcon: Icon(
                    Icons.email,
                  ),
                  hintText: 'Enter your email address.'),
            ),
            
            SizedBox(height: max(1.5.ph(size),10)),
            
            // For password
            TextFormField(
              controller: passwordController,
              obscureText: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              autofillHints: [AutofillHints.password],
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  return null;
                }
                return "Enter your password.";
              },
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(fontSize: 14),
                  labelText: 'Password',
                  prefixIcon: Icon(
                    Icons.lock,
                  ),
                  hintText: 'Enter your password.'),
            ),
          ]
      ),
    );
  }
}

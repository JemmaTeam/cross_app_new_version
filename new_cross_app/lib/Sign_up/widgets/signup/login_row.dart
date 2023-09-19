//import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:new_cross_app/Login/login.dart';
//import 'package:flutter/widgets.dart';
//import 'package:jemma/routes.dart';
import 'package:new_cross_app/Sign_up/signup_customer.dart';
//import 'package:new_cross_app/Sign_up/signup_tradeperson.dart';
import 'package:new_cross_app/Login/utils/responsive.dart';

/// Widget for the login row displayed on the Sign Up screen.
class LoginRow extends StatelessWidget {
  /// [size] is the size of the Sign Up screen.
  const LoginRow({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // For Sign up
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
            onPressed: () {
              // Navigate to the login page when the text is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: const Text(
              'Already have an account? Login now',
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
          ),
          SizedBox(
            width: 2.pw(size),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jemma/routes.dart';
import 'package:jemma/screens/login.dart';
import 'package:jemma/utils/responsive.dart';

///  Sign up and forgot TextButtons, that are part of the [Login] screen.
class SignupForgotRow extends StatelessWidget {

  /// [size] is the size of the [Login] screen.
  const SignupForgotRow({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return
      Center(
        child:Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            // For Sign up
            TextButton(
              style: TextButton.styleFrom(padding: EdgeInsets.zero,),
              onPressed: () {
                Navigator.pushNamed(
                    context, Screen.signup.getURL());
              },
              child: Text(
                'Sign up',
                style: TextStyle(color: Colors.blue,),
              ),
            ),
            SizedBox(width: 2.pw(size),),

            // For forgot password
            TextButton(
              style: TextButton.styleFrom(padding: EdgeInsets.zero,),
              onPressed: () {
                //TODO: Link forgot password dialog box/screen widget.
              },
              child: Text(
                'Forgot password',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      );
  }
}
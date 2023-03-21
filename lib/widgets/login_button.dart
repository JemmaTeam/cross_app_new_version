import 'package:flutter/material.dart';
import 'package:jemma/routes.dart';
import 'package:jemma/screens/home.dart';
import 'package:jemma/screens/login.dart';

/// Button in [Home] screen which will direct to the [Login] page.
class LoginButton extends StatelessWidget {
  const LoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(fontSize: 20),
          primary: Colors.white,
          elevation: 2),
      onPressed: () {
        Navigator.pushNamed(context, Screen.login.getURL());
      },
      child: const Text(
        "Login",
        style: TextStyle(
          fontSize: 13,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

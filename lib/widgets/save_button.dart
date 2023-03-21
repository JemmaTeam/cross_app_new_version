import 'package:flutter/material.dart';
import 'package:jemma/routes.dart';
import 'package:jemma/screens/profile.dart';

/// Button in [Profile] screen.
class SaveButton extends StatelessWidget {
  const SaveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20),primary:Colors.lightGreen,elevation: 2 ),
      onPressed: () {

      },
      child: Text(
        "Save",
        style: TextStyle(
          fontSize: 13,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),

    );
  }
}

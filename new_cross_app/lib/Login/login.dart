import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:new_cross_app/Login/providers/login.dart';
//import 'package:jemma/routes.dart';
//import 'package:new_cross_app/Login/utils/adaptive.dart';
import 'package:new_cross_app/Login/utils/constants.dart';
import 'package:new_cross_app/Login/utils/notification.dart';
import 'package:new_cross_app/Login/utils/responsive.dart';
import 'package:new_cross_app/Login/widgets/login/decoration_image_container.dart';
import 'package:new_cross_app/Login/widgets/login/input_fields.dart';
import 'package:new_cross_app/Login/widgets/login/signup_forgot_row.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../main.dart';

/// Screen through which users can login.
///
/// Idea of using SizedBox for spacing instead of padding is from this:
/// https://stackoverflow.com/a/52774984/11200630
class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final logger = Logger(
    printer: PrettyPrinter(),
  );

  final jemmaTitle = Center(
    child: FittedBox(
        fit: BoxFit.contain,
        child: Text("Jemma", style: GoogleFonts.parisienne(fontSize: 40.sp))),
  );

  /// Updates UI on receiving the result from LoginNotifier;
  ///
  /// [context] is the Context of the current screen.
  /// [isAuthenticated] is the boolean value in the [LoginNotifier].
  /// [resultMessage] is the String to be shown in the notification.
  void handleLoginResult(
      BuildContext context, bool isAuthenticated, String resultMessage) {
    if (isAuthenticated) {
      showNotification(context, resultMessage, NotificationType.success)
          .closed
          .then((_) => Navigator.pop(context));
    } else {
      showNotification(context, resultMessage, NotificationType.error);
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var rootContext = context;
    return Scaffold(
        body: SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 100.ph(size)),
            child: Stack(
              children: [
                SingleChildScrollView(
                  // Allow scrolling if screen size is too small
                  child: Consumer<LoginNotifier>(
                    builder: (context, loginNotifier, child) => Form(
                      key: _formKey,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        // Jemma title
                        ConstrainedBox(
                            constraints: BoxConstraints(minHeight: 30.ph(size)),
                            child: jemmaTitle),

                        // Input fields
                        ConstrainedBox(
                            constraints: BoxConstraints(
                                minHeight: 20.ph(size), maxWidth: 300),
                            child: InputFields(
                                emailController: emailController,
                                passwordController: passwordController,
                                size: size)),

                        SizedBox(height: max(1.25.ph(size), 7.5)),

                        // Login button
                        ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 100),
                            child: SizedBox(
                              width: 100,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    showNotification(context, "Validating",
                                        NotificationType.info);
                                    loginNotifier.authenticate(
                                        emailController.text,
                                        passwordController.text,
                                        http.Client(),
                                        (resultMessage) => handleLoginResult(
                                            rootContext,
                                            loginNotifier.isAuthenticated,
                                            resultMessage));
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: const StadiumBorder(),
                                    padding: const EdgeInsets.all(20),
                                    backgroundColor: kLogoColor),
                                child: const Text(
                                  "Login",
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            )),

                        SizedBox(height: max(1.75.ph(size), 10)),

                        SignupForgotRow(size: size)
                      ]),
                    ),
                  ),
                ),

                // Decoration Image
                Positioned.fill(
                  child: Align(
                    alignment: const Alignment(0.7, 1),
                    child: DecorationImageContainer(size: size),
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,

        /*floatingActionButton: isWeb()? null: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () { Navigator.pop(context);},
          child: const Icon(Icons.arrow_back, color: Colors.black87),
        )*/
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MyApp()));
          },
          child: const Icon(Icons.arrow_back, color: Colors.black87),
        ));
  }
}

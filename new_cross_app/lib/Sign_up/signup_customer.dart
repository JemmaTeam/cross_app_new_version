import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_cross_app/Login/login.dart';
import 'package:new_cross_app/Login/utils/constants.dart';
import 'package:new_cross_app/Login/utils/responsive.dart';
import 'package:new_cross_app/Home Page/home.dart';
import 'package:new_cross_app/Sign_up/widgets/signup/decoration_image_container.dart';
import 'package:new_cross_app/Sign_up/widgets/signup/input_fields.dart';
import 'package:new_cross_app/Sign_up/widgets/signup/show_snackbar.dart';
import 'package:new_cross_app/Sign_up/widgets/signup/login_row.dart';
import 'package:logger/logger.dart';
import 'package:sizer/sizer.dart';
import '../main.dart';
import '../services/auth_service.dart';

/// Screen through which Customer users can Sign up.
class SignupComstomer extends StatefulWidget {
  const SignupComstomer({Key? key}) : super(key: key);

  @override
  State<SignupComstomer> createState() => _SignupComstomerPageState();
}

class _SignupComstomerPageState extends State<SignupComstomer> {
  // Controllers for text fields
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Logger instance
  final logger = Logger(printer: PrettyPrinter());

  // Form key
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // Dynamic font size using screen height
    double dynamicFontSize = size.height * 0.2;
    // Modified Jemma title with dynamic font size
    final jemmaTitle = Center(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text("Jemma", style: GoogleFonts.parisienne(fontSize: dynamicFontSize)),
      ),
    );
    return Scaffold(
        body: SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 100.ph(size)),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Form(
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
                              fullnameController: fullnameController,
                              emailController: emailController,
                              passwordController: passwordController,
                              size: size)),

                      SizedBox(height: max(1.25.ph(size), 7.5)),

                      // Sign Up button
                      ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 100),
                          child: SizedBox(
                            width: 100,
                            child: ElevatedButton(
                              onPressed: () {
                                registerCusotmer();
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  padding: const EdgeInsets.all(20),
                                  backgroundColor: kLogoColor),
                              child: const Text(
                                "Sign Up",
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          )),

                      SizedBox(height: max(1.75.ph(size), 10)),

                      LoginRow(size: size)
                    ]),
                  ),
                ),

                // Decoration Image
                Positioned.fill(
                  child: Align(
                    alignment: const Alignment(0.7, 1),
                    child: CustomerImageContainer(size: size),
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () => {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const MyApp()))
          },
          child: const Icon(Icons.arrow_back, color: Colors.black87),
        ));
  }

  // Function to register customer
  registerCusotmer() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerCustomerWithEmailAndPassword(fullnameController.text,
              emailController.text, passwordController.text)
          .then((value) {
        if (value == true) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginPage()));
        } else {
          showSnackbar(context, kMenuColor, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}

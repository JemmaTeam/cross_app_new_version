import 'dart:math'; // For mathematical operations
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firebase Firestore
import 'package:firebase_auth/firebase_auth.dart'; // For Firebase Authentication
import 'package:flutter/material.dart'; // Flutter Material Design
import 'package:go_router/go_router.dart'; // For routing
import 'package:google_fonts/google_fonts.dart'; // For custom fonts
import 'package:new_cross_app/Login/utils/constants.dart'; // Constants
import 'package:new_cross_app/Login/utils/responsive.dart'; // Responsive UI
import 'package:new_cross_app/Login/widgets/login/input_fields.dart'; // Input fields widget
import 'package:new_cross_app/Login/widgets/login/signup_row.dart'; // Signup row widget
import 'package:new_cross_app/Sign_up/signup_customer.dart'; // Signup customer screen
import 'package:logger/logger.dart'; // For logging
import 'package:new_cross_app/Routes/route_const.dart'; // Route constants
import 'package:new_cross_app/Home%20Page/home.dart'; // Home screen
import 'package:new_cross_app/Sign_up/widgets/signup/show_snackbar.dart'; // Snackbar widget
import 'package:new_cross_app/chat/screens/chat_home_screen.dart'; // Chat home screen
import 'package:new_cross_app/helper/helper_function.dart'; // Helper functions
import 'package:new_cross_app/services/auth_service.dart'; // Authentication service
import 'package:new_cross_app/services/database_service.dart'; // Database service
import 'package:sizer/sizer.dart'; // For responsive sizing
import '../../helper/constants.dart'; // Helper constants

import '../main.dart'; // Main entry point

/// Screen through which users can login.
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
// Controllers for email and password
  // final TextEditingController emailController = TextEditingController();
  // final TextEditingController passwordController = TextEditingController();

//consumer test account
  // final TextEditingController emailController =
  //     TextEditingController(text: "cella@outlook.com");
  // final TextEditingController passwordController =
  //     TextEditingController(text: "123456");

//tradie test account
  final TextEditingController emailController =
      TextEditingController(text: "tben@outlook.com");
  final TextEditingController passwordController =
      TextEditingController(text: "123456");

  // Loading state
  bool _isLoading = false;

  // Authentication service instance
  AuthService authService = AuthService();

  // Logger instance
  final logger = Logger(printer: PrettyPrinter());

  // Title widget
  final jemmaTitle = Center(
    child: FittedBox(
        fit: BoxFit.contain,
        child: Text("Jemma", style: GoogleFonts.parisienne(fontSize: 40.sp))),
  );

  // Form key
  final _formKey = GlobalKey<FormState>();

  Widget googleSignInButton() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 300), // 设置最大宽度为300
      child: GestureDetector(
        onTap: () async {
          bool isSignedIn = await authService.signInWithGoogle();
          if (isSignedIn && mounted) {
            // 获取当前登录的用户
            User? user = FirebaseAuth.instance.currentUser;
            // Check if user is not null
            if (user != null) {
              // 保存用户数据到 HelperFunctions
              await HelperFunctions.saveUserLoggedInStatus(true);
              await HelperFunctions.saveUserEmailSF(user.email!);
              await HelperFunctions.saveUserNameSF(user.displayName!);
              await HelperFunctions.saveUserIdSF(user.uid);
              // Initialize Constants
              Constants.myName = user.displayName!;
              Constants.MyId = user.uid;
              print("登录成功后当前用户的ID为: ${Constants.MyId}");
              // Navigate to the home page
              GoRouter.of(context)
                  .pushNamed(RouterName.homePage, params: {'userId': user.uid});
            } else {
              // Handle the case where user is null (this should not happen if isSignedIn is true)
              print("User is null");
            }
          }
        },
        child: Container(
          width: double.infinity, // 使容器尽可能宽
          height: 45,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Image.asset('assets/images/google.png'),
              ),
              const Text(
                'Continue with Google',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 100.ph(size)),
            child: Stack(
              children: [
                SingleChildScrollView(
                  // Allow scrolling if screen size is too small
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
                              style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  padding: const EdgeInsets.all(20),
                                  backgroundColor: kLogoColor),
                              onPressed: () {
                                login();
                              },
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

                      SignupForgotRow(size: size),
                      SizedBox(
                          height: max(1.75.ph(size), 10)), // Add some spacing
                      googleSignInButton(),
                    ]),
                  ),
                ),
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

  login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .loginWithUserNameandPassword(
              emailController.text, passwordController.text)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(emailController.text);
          // saving the values to our shared preferences
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(emailController.text);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);
          await HelperFunctions.saveUserIdSF(snapshot.docs[0]['uid']);

          // Initialize Constants
          Constants.myName = snapshot.docs[0]['fullName'];
          String userId = snapshot.docs[0]['uid'];
          Constants.MyId = userId;
          print("登录成功后当前用户的ID为: ${Constants.MyId}");
          GoRouter.of(context)
              .pushNamed(RouterName.homePage, params: {'userId': userId});
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

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_cross_app/Login/utils/constants.dart';
import 'package:new_cross_app/Login/widgets/login/input_fields.dart';
import 'package:new_cross_app/Login/widgets/login/signup_row.dart';
import 'package:go_router/go_router.dart';
import 'package:new_cross_app/Sign_up/signup_customer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_cross_app/helper/helper_function.dart';
import 'package:new_cross_app/services/auth_service.dart';
import 'package:new_cross_app/Routes/route_const.dart';
import 'package:logger/logger.dart';

// 确保 MyApp 已在正确的位置定义
import '../main.dart';

// 确保 Constants 类已在正确的位置定义
import '../../helper/constants.dart';

// 确保 DatabaseService 和 showSnackbar 已定义
import 'package:new_cross_app/services/database_service.dart';
import 'package:new_cross_app/Sign_up/widgets/signup/show_snackbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  AuthService authService = AuthService();
  final logger = Logger(printer: PrettyPrinter());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                ConstrainedBox(
                  constraints: BoxConstraints(minHeight: size.height * 0.30),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text("Jemma", style: GoogleFonts.parisienne(fontSize: size.height * 0.2)),
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 300),
                  child: InputFields(emailController: emailController, passwordController: passwordController, size: size),
                ),
                SizedBox(height: max(size.height * 0.0125, 7.5)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.all(20),
                      backgroundColor: kLogoColor),
                  onPressed: login,
                  child: const Text("Login", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                ),
                SizedBox(height: max(size.height * 0.0175, 10)),
                SignupForgotRow(size: size),
                SizedBox(height: max(size.height * 0.0175, 10)),
                googleSignInButton(),
              ]),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MyApp())),
          child: const Icon(Icons.arrow_back, color: Colors.black87),
        )
    );
  }

  Widget googleSignInButton() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 300),
      child: GestureDetector(
        onTap: signInWithGoogle,
        child: Container(
          width: double.infinity,
          height: 45,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Image.asset('assets/images/google.png'),
              ),
              const Text('Continue with Google', style: TextStyle(fontSize: 17)),
            ],
          ),
        ),
      ),
    );
  }

  void login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      bool loginSuccess = await authService.loginWithUserNameandPassword(emailController.text, passwordController.text);
      if (loginSuccess) {
        // Process user data retrieval and setup
        handleSuccessfulLogin();
      } else {
        showSnackbar(context, kMenuColor, "Login Failed");
        setState(() => _isLoading = false);
      }
    }
  }

  void signInWithGoogle() async {
    bool isSignedIn = await authService.signInWithGoogle();
    if (isSignedIn && mounted) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await HelperFunctions.saveUserLoggedInStatus(true);
        await HelperFunctions.saveUserEmailSF(user.email!);
        await HelperFunctions.saveUserNameSF(user.displayName!);
        await HelperFunctions.saveUserIdSF(user.uid);
        Constants.myName = user.displayName!;
        Constants.MyId = user.uid;
        GoRouter.of(context).pushNamed(RouterName.homePage, params: {'userId': user.uid});
      } else {
        logger.e("User is null after successful Google sign-in");
      }
    }
  }

  void handleSuccessfulLogin() async {
    QuerySnapshot snapshot = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettingUserData(emailController.text);
    await HelperFunctions.saveUserLoggedInStatus(true);
    await HelperFunctions.saveUserEmailSF(emailController.text);
    await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);
    await HelperFunctions.saveUserIdSF(snapshot.docs[0]['uid']);
    Constants.myName = snapshot.docs[0]['fullName'];
    Constants.MyId = snapshot.docs[0]['uid'];
    GoRouter.of(context).pushNamed(RouterName.homePage, params: {'userId': Constants.MyId});
  }
}

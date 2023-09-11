import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:new_cross_app/helper/helper_function.dart';
import 'package:new_cross_app/services/database_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //login
  Future loginWithUserNameandPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //sign up for customer uesr
  Future registerCustomerWithEmailAndPassword(
      String fullName, String email, String password) async {
    try {
      //
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      //user.sendEmailVerification();

      if (user != null) {
        //call out database to update the user data
        await DatabaseService(uid: user.uid)
            .savingCustomerData(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

// Cross-Platform Google Sign-In
  Future<bool> signInWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    UserCredential? userCredential;

    try {
      if (kIsWeb) {
        // For Web
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        userCredential = await auth.signInWithPopup(googleProvider);
      } else {
        // For Android & iOS
        GoogleSignIn _googleSignIn = GoogleSignIn(
          scopes: [
            'email',
            'https://www.googleapis.com/auth/contacts.readonly',
          ],
        );
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser != null) {
          final GoogleSignInAuthentication googleAuth =
              await googleUser.authentication;
          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          userCredential = await auth.signInWithCredential(credential);
        }
      }

      if (userCredential != null) {
        User? user = userCredential.user;
        if (user != null) {
          // Save user data to CustomerCollection
          await DatabaseService(uid: user.uid)
              .savingCustomerData(user.displayName ?? '', user.email ?? '');
          return true; // Return true on successful authentication
        }
      }
    } catch (error) {
      // Handle any errors that might occur during the sign-in process
      print('Error during Google Sign-In: $error');
    }
    return false; // Return false if authentication fails or is cancelled
  }

  // signout
  Future signOut() async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmailSF("");
      await HelperFunctions.saveUserNameSF("");
      await HelperFunctions.saveUserIdSF("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }

  // update user password
  Future<bool> updatePassword(String newPassword) async {
    User? user = firebaseAuth.currentUser;

    try {
      await user!.updatePassword(newPassword);
      await user.reload();
      user = firebaseAuth.currentUser;
      return true;
    } catch (e) {
      print("An error occurred while trying to update password: $e");
      return false;
    }
  }
}

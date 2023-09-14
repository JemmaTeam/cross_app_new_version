import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  // Firestore collection reference for users
  static final CollectionReference userRef =
      FirebaseFirestore.instance.collection('users');

  // Shared Preferences keys
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userIDKey = "USERIDKEY";

  // Save user login status to Shared Preferences
  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isUserLoggedIn);
  }

  // Save user name to Shared Preferences
  static Future<bool> saveUserNameSF(String userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userName);
  }

  // Save user email to Shared Preferences
  static Future<bool> saveUserEmailSF(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);
  }

  // Save user ID to Shared Preferences
  static Future<bool> saveUserIdSF(String userId) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userIDKey, userId);
  }

  // Retrieve user login status from Shared Preferences
  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }

  // Retrieve user email from Shared Preferences
  static Future<String?> getUserEmailFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }

  // Retrieve user name from Shared Preferences
  static Future<String?> getUserNameFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }

  // Retrieve user ID from Shared Preferences
  static Future<String?> getUserIdFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userIDKey);
  }

  // Retrieve user name from Firestore using user ID
  static Future<String?> getUserNameFromId(String userId) async {
    String userName = '';
    await userRef.get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          if (docSnapshot.id == userId) {
            if (docSnapshot.data() != null) {
              var data = docSnapshot.data() as Map<String, dynamic>;
              userName = data['fullName'];
            }
          }
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    return userName;
  }
}

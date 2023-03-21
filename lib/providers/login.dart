import 'dart:convert';

import 'package:jemma/models/user.dart';
import 'package:jemma/repository.dart';
import 'package:jemma/screens/login.dart';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';


/// Handles the  logic of the [Login] process.
class LoginNotifier extends ChangeNotifier{

  var logger = Logger(
    printer: PrettyPrinter(),
  );

  bool isAuthenticated = false;
  final url  = Uri.parse("${Repository.baseUrl}/login/");


  /// Authenticates the user asynchronously.
  ///
  /// [resultHandler] is the callback which is being used to send the notification result.
  /// [client] is the [http.Client] instance and is injected so to assist in the unit test.
  void authenticate(String username,String password,
                    http.Client client,
                    void Function(String resultMessage) resultHandler) async {
    var resultMessage = "";
    await client.post(url,headers: {"Content-type":"application/json"},
        body: jsonEncode({"username":username,"password":password})).then((response) {
      logger.d(username + password);
      if (response.statusCode == 200){
        User user = User.fromJson(jsonDecode(response.body));
        Repository().user.value = user;
        Hive.box(Repository.hiveEncryptedBoxName).put("user", user);
        isAuthenticated = true;
        // TODO Persistent storage (local)
        resultMessage = "Logging in";
        logger.d("Successful login");
      }
      else{
        resultMessage = "Invalid credential";
        logger.d("Unsuccessful login");
      }
    }).catchError((onError){
      logger.e(onError.toString());
      resultMessage = "Oops. Something wrong happen.";

    }).whenComplete((){
      logger.d("authenticate() completed.");
      notifyListeners();
      resultHandler(resultMessage);
    } );

  }

}

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:jemma/providers/login.dart';
import 'package:mockito/annotations.dart';



@GenerateMocks([http.Client])
void main() {

  test("Given an invalid credential, user should be not regarded as authenticated by the login system.",() async {
   await checkLoginValidity(400,false);
  });

  test("Given a valid credential, user should be regarded as authenticated by the login system.",() async {
    await checkLoginValidity(200,true);
  });
  
}

Future<void> checkLoginValidity(int responseCode,bool expectedIsAuthentication) async {
  var loginNotifier = LoginNotifier();
  var mockResultCallback = (_) {  };

  final client = MockClient((request) => Future.value(http.Response("", responseCode)));

  loginNotifier.authenticate("username", "password", client, mockResultCallback);

  loginNotifier.addListener(() { expect(loginNotifier.isAuthenticated,expectedIsAuthentication);});

}

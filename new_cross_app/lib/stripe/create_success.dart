import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CreateSuccess extends StatelessWidget {
  const CreateSuccess({Key? key}) : super(key: key);

  void _launchURL() async {
    const url = 'https://jemma-b0fcd.web.app/#/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Successful'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Your stripe account has been registered.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _launchURL();
              },
              child: Text('Back to Home Page'),
            ),
          ],
        ),
      ),
    );
  }
}

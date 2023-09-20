import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Widget for displaying an error page when a page is not found
class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Center(
          child: const Text('Page Not Found'),
        ),
      ),
    );
  }
}

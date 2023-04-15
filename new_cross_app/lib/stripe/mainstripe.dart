import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_cross_app/stripe/components/card_type.dart';
import 'package:new_cross_app/stripe/components/card_utilis.dart';
import 'package:new_cross_app/stripe/constains.dart';

import 'components/input_formatters.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stripe payment',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      // home: const HomeScreen(title: 'Flutter Demo Home Page'),
    );
  }
}

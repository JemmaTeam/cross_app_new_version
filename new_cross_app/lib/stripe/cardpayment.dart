import 'package:new_cross_app/stripe/add_new_card.dart';
import 'package:new_cross_app/stripe/constains.dart';
import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

class CardPayment extends StatelessWidget {
  const CardPayment({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jemma',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          elevation: 0,
          titleTextStyle:
              TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFFF8F8F9),
          hintStyle: TextStyle(
            color: Color(0xFFB8B5C3),
          ),
          border: defaultOutlineInputBorder,
          enabledBorder: defaultOutlineInputBorder,
          focusedBorder: defaultOutlineInputBorder,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            minimumSize: const Size(double.infinity, 56),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 56),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
      ),
      home: const AddNewCardScreen(),
    );
  }
}

const OutlineInputBorder defaultOutlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide.none,
  borderRadius: BorderRadius.all(Radius.circular(12)),
);

import 'package:flutter/material.dart';
import 'card_form_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stripe Example')),
      body: ListTile(
          onTap: () {
            //TODO:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CardFormScreen(),
              ),
            );
          },
          title: const Text('Go to the Card Form'),
          trailing: const Icon(Icons.chevron_right_rounded)),
    );
  }
}

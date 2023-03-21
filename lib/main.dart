import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:jemma/repository.dart';
import 'package:jemma/routes.dart';
import 'package:sizer/sizer.dart';

import 'config/configure_non_web.dart'
    if (dart.library.html) 'config/configure_web.dart';
import 'package:logger/logger.dart';
import 'package:hive_flutter/hive_flutter.dart';

final logger = Logger(
  printer: PrettyPrinter(),
);

void main() {
  configureApp();
  initialise();
  runApp(const App());
}

void initialise() async {
  await Hive.initFlutter();
  Repository().init();
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Jemma',
          routes: {
            for (var screen in Screen.values)
              screen.getURL(): (context) => screen.getScreenWidget()
          },
          theme: ThemeData(
              appBarTheme: const AppBarTheme(
                backwardsCompatibility: false,
                iconTheme: IconThemeData(color: Colors.black),
                titleTextStyle:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                backgroundColor: Color(0xFFDDFFB3),
              ),
              colorScheme: ThemeData().colorScheme.copyWith(
                    primary: const Color(0xFF4CAF50),
                    secondary: const Color(0xFFB3B3B3),
                  ),
              chipTheme: ChipTheme.of(context).copyWith(
                  secondarySelectedColor: Colors.green,
                  selectedColor: Colors.white,
                  backgroundColor: Colors.white,
                  secondaryLabelStyle: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  labelStyle: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold))),
        );
      },
    );
  }
}

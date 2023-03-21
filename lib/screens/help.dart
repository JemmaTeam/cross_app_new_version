import 'package:flutter/material.dart';
import 'package:jemma/screens/home.dart';
import '../widgets/nav_bar.dart';
import 'package:jemma/utils/adaptive.dart';
import 'package:jemma/widgets/notification_panel.dart';

class Help extends StatelessWidget {
  const Help({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: isWeb()
              ? null
              : IconButton(
                  onPressed: () => Navigator.of(context).pop(Home),
                  icon: const Icon(Icons.arrow_back)),
          title: const Text("Help"),
          actions: [
            Builder(
              builder: (context) => IconButton(
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                  icon: const Icon(Icons.add_alert)),
            ),
          ],
        ),
        drawer: NavBar(),
        endDrawer: const NotificationPanel());
  }
}

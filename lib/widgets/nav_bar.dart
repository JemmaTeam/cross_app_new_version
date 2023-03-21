import 'package:flutter/material.dart';
import 'package:jemma/routes.dart';

class NavBar extends StatelessWidget {
  // TODO: Make it responsive; See https://gallery.flutter.dev/#/starter

  final _navBarScreens = [
    Screen.home,
    Screen.profile,
    Screen.bookings,
    Screen.quotes,
    Screen.help,
    Screen.calendar,
    Screen.chat_home_page,
  ];

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Drawer(
        child: ListView(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            // color: Theme.of(context).primaryColor,
            color: Theme.of(context).colorScheme.primary,
          ),
          child: const Text('Jemma'),
        ),
        for (var screen in _navBarScreens)
          ListTile(
            title: Text(screen.toStyledString()),
            // tileColor: Theme.of(context).accentColor,
            tileColor: Theme.of(context).colorScheme.secondary,
            onTap: () {
              Navigator.pushNamed(
                context,
                screen.getURL(),
              );
            },
          )
      ],
    ) // Populate the Drawer in the next step.
        );
  }

  Widget desktopView(BuildContext context, Size size) {
    return Row(
      children: <Widget>[
        Expanded(
            flex: size.width > 1340 ? 3 : 4,
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    // color: Theme.of(context).primaryColor,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: const Text('Jemma'),
                ),
                for (var screen in _navBarScreens)
                  ListTile(
                    title: Text(screen.toStyledString()),
                    // tileColor: Theme.of(context).accentColor,
                    tileColor: Theme.of(context).colorScheme.secondary,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        screen.getURL(),
                      );
                    },
                  )
              ],
            ))
      ],
    );
  }

  //Just got to copy the main code here
  Widget mobileView() {
    return const Drawer();
  }
}

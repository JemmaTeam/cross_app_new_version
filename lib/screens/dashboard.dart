
import 'package:flutter/material.dart';
import '../widgets/nav_bar.dart';
class Dashboard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Dashboard"),
        ),
        drawer: NavBar());

  }
}



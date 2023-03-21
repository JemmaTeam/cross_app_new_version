import 'package:flutter/material.dart';
import 'package:jemma/widgets/login_button.dart';

import '../repository.dart';

List<Widget> buildActions(){
 return  <Widget>[
    if (!Repository().isLoggedIn)
      const Center(child: LoginButton()),
    const SizedBox(width: 10,),
    if (Repository().isLoggedIn)
      IconButton(
        icon: const Icon(Icons.notifications),
        onPressed: () {},
      ),
  ];
}

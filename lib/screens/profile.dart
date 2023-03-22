import 'dart:convert';
// import 'dart:html';
import 'package:universal_html/html.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:jemma/screens/home.dart';
import 'package:jemma/utils/notification.dart';
import 'package:jemma/widgets/nav_bar.dart';
import 'package:jemma/widgets/notification_panel.dart';
import 'package:jemma/widgets/save_button.dart';
import 'package:sizer/sizer.dart';
import 'package:jemma/utils/adaptive.dart';
import 'package:string_validator/string_validator.dart';
//import 'package:jemma/widgets/save_button.dart';


class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formkey = GlobalKey<FormState>();
  var scrollController = ScrollController();
  // final myController = TextEditingController();
  final TextEditingController name = new TextEditingController(),
      age = new TextEditingController(),
      phone = new TextEditingController(),
      aaddress = new TextEditingController(),
      card = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    Widget iconSection = Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            backgroundImage: const AssetImage("assets/images/user_profile.png"),
            radius: 60,
          ),
          const IconButton(
              onPressed:null,
              icon: const Icon(Icons.edit, size: 40.0,)),
        ],
      ),
    );

    Widget personalInformation = Container(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Icon(Icons.account_box_rounded, size:40.0)
            ),
            Center(
              child: Form(
                  key: _formkey,
                  child: OverflowBar(
                      spacing: 5.w,
                      overflowAlignment: OverflowBarAlignment.center,
                      overflowSpacing: 16,
                      children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child:ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 400),
                              child: TextFormField(
                                controller: name,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Name',
                                    hintText: 'Enter your full name'),
                              ),
                            )
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child:ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 400),
                              child: TextFormField(
                                controller: age,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Age',
                                    hintText: 'Enter your age'),
                              ),
                            )
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child:ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 400),
                              child: TextFormField(
                                controller: phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Phone Number',
                                    hintText: 'Enter your phone number'),
                              ),
                            )
                        ),
                      ]
                  )
              ),
            ),
          ],
        )
    );

    Widget address = Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left:30.0, top:30.0),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Icon(Icons.house, size: 40.0),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 20, bottom: 10),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child:ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 300),
                child: TextFormField(
                  controller: aaddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Address',
                      hintText: 'Enter your full address'),
                ),
              )
          ),
        ],
      ),
    );

    Widget bankAccount = Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left:30.0, top:30.0),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Icon(Icons.credit_card_outlined, size: 40.0),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 20, bottom: 10),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child:ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 300),
                child: TextFormField(
                  controller: card,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Card number',
                      hintText: 'Enter your card number'),
                ),
              )
          ),
        ],
      ),
    );


    Widget submitbutton =TextButton(
        onPressed: (){
          submit();
        },
        child: Text("Submit"),
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith(
                (states) {
              if (states.contains(MaterialState.focused) &&
                  !states.contains(MaterialState.pressed)){
                return Colors.lightGreenAccent;
              } else if (states.contains(MaterialState.pressed)){
                return Colors.grey;
              }
              return Colors.green;
            },
          ),

        )
    );



    return Scaffold(
      appBar: AppBar(
        leading: isWeb() ? null : IconButton(
            onPressed: () => Navigator.of(context).pop(Home),
            icon: Icon(Icons.arrow_back)
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                icon: const Icon(Icons.notifications)),
          ),
        ],
        title: Text("Profile"),
        centerTitle: true,
      ),
      drawer: NavBar(),
      endDrawer: NotificationPanel(),
      body:  Scrollbar(
        isAlwaysShown: isWeb(),
        controller: scrollController,
        child:ListView(
            controller: scrollController,
            children: [
              iconSection,
              personalInformation,
              address,
              bankAccount,
              submitbutton,
            ]
        ),
      ),
    );
  }
  bool submit_ALLOW = true;

  void submit() {

    /*
      POST Data Builder
    */
    Map<String, dynamic> data = new Map();

    /* Account details */
    data["name"] = this.name.text;
    data["age"] = this.age.text;
    data["phone_number"] = this.phone.text;
    data["address"] = this.aaddress.text;
    data["card_number"] = this.card.text;

    /* Personal details */
    if (this.name.text.length > 0)
      data["name"] = this.name.text;
    if (this.age.text.length > 0)
      data["age"] = int.parse(this.age.text);
    if (this.phone.text.length > 0)
      data["phone_number"] = int.parse(this.phone.text);
    // /* Address details */
    if (this.aaddress.text.length > 0)
      data["address"] = this.aaddress.text;
    //   /* Payment details */
    if (this.card.text.length > 0)
      data["card_number"] = int.parse(this.card.text);


    debugPrint("\n${jsonEncode(data)}\n");

    /* Submit request and show progress */
    showNotification(context, "Submitting", NotificationType.info);

    // TODO: the url below should be tested
    post(Uri.parse("http://localhost:8000/signup/"),
        body: jsonEncode(data),
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json"
        }).then((Response value) {
      /* Request Success */
      debugPrint("\nThen: ${value.body}\n");
      var response = json.decode(value.body);
      if (response.containsKey("id")) {
        /*showNotification(context, "Account created", NotificationType.success, duration: Duration(seconds: 3))
            .closed
            .then((_) => Navigator.pop(context));*/
        showNotification(context, "Submit created", NotificationType.success,
            duration: const Duration(seconds: 3));

      }
      else {
        showNotification(context, "Failed", NotificationType.error,
            duration: const Duration(seconds: 3));
      }
    }).catchError((x) {
      /* Request Failed */
      debugPrint("\nError: ${x.toString()}\n");
      showNotification(context, "Failed", NotificationType.error,
          duration: const Duration(seconds: 3));
    }).whenComplete(() {
      this.submit_ALLOW = true;
    });
  }

}




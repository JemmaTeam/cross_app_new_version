library home;

//import 'dart:js_interop';

import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
//import 'package:jemma/models/user.dart';
//import 'package:jemma/repository.dart';
import 'package:new_cross_app/Home Page/adaptive.dart';
import 'package:new_cross_app/Home Page/responsive.dart';
import 'package:new_cross_app/Home Page/graphical_banner.dart';
import 'package:new_cross_app/Home Page/login_button.dart';
import 'package:new_cross_app/Home Page/nav_bar.dart';
import 'package:new_cross_app/Home Page/notification_panel.dart';
import 'package:new_cross_app/Home Page/web_footer.dart';
import 'package:new_cross_app/Home Page/about_jemma.dart';
import 'package:new_cross_app/Home Page/why_jemma.dart';
import 'package:new_cross_app/Routes/route_const.dart';

import '../Calendar/Consumer/ConsumerProfilePage.dart';
import '../Calendar/Consumer/TradieDemo.dart';
import '../Calendar/RatePage.dart';
import '../Calendar/Tradie/TradieProfilePage.dart';
import '../Login/login.dart';
import '../Login/utils/constants.dart';
import '../Profile/profile.dart';
//import '../Sign_up/signup.dart';
import '../chat/screens/chat_home_screen.dart';
import '../helper/helper_function.dart';
import '../stripe/card_form_screen.dart';
import '../stripe/check_out.dart';
import 'decorations.dart';

part 'package:new_cross_app/Home Page/search_bar.dart';

/// Home screen for guests and customers
///
/// Restricting max width of widgets to be 1080 based on the data from:
/// https://gs.statcounter.com/screen-resolution-stats/desktop/worldwide
class Home extends StatefulWidget {
  String userId = '';
  Home.G({Key? key}) : super(key: key);
  Home(String userId) {
    this.userId = userId;
  }

  @override
  HomeState createState() => HomeState(userId: userId);
}

final logger = Logger(
  printer: PrettyPrinter(),
);
bool _isLoggedIn = false;
late bool _isConsumer = true;

class HomeState extends State<Home> {
  String userId;
  HomeState({required this.userId});
  static const borderRadius = 40.0;
  static const maxWidth = 1080.0;

  //bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    isConsumer(userId).then((value) {
      _isConsumer = value;
    });
  }

  void _checkLoginStatus() async {
    bool? userLoggedIn = await HelperFunctions.getUserLoggedInStatus();
    setState(() {
      _isLoggedIn = userLoggedIn ?? false;
    });
  }

  void logout() async {
    await HelperFunctions.saveUserLoggedInStatus(false);
    print("Logout succusfully. LoggedInStatus: " +
        (await HelperFunctions.getUserLoggedInStatus()).toString());
    setState(() {
      _isLoggedIn = false;
      userId = '';
    });
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_isLoggedIn ? 'Confirm Logout' : 'Not Logged In'),
          content: Text(_isLoggedIn
              ? 'Are you sure you want to logout?'
              : 'You are not logged in.'),
          actions: <Widget>[
            if (_isLoggedIn)
              TextButton(
                onPressed: () {
                  logout();
                  Navigator.of(context).pop();
                },
                child: Text('Yes'),
              ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var scrollController = ScrollController();
    return Scaffold(
        endDrawer: const NotificationPanel(),
        appBar: AppBar(
          actions: [
            if (_isLoggedIn)
              Builder(
                builder: (context) => IconButton(
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                    icon: const Icon(Icons.notifications)),
              ),
            if (_isLoggedIn)
              IconButton(
                icon: CircleAvatar(
                  backgroundColor: Colors.lightGreen, // 你可以选择任何颜色
                  child: Text(
                    userId.isNotEmpty
                        ? userId[0].toUpperCase()
                        : '', // TODO:将id首字母替换成名字首字母或者头像
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                onPressed: () {
                  GoRouter.of(context).pushNamed(RouterName.profilePage,
                      params: {'userId': userId}); // 跳转至用户的profile页面
                },
              ),
            if (_isLoggedIn)
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'logout') {
                    _showLogoutDialog(); // 使用_logoutDialog方法显示弹出对话框
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Text('Log Out'),
                  ),
                ],
              ),
            if (!_isLoggedIn)
              IconButton(
                icon: Icon(Icons.login), // 登录图标
                onPressed: () {
                  GoRouter.of(context).pushNamed(RouterName.Login); // 跳转至登录页面
                },
              ),
          ],
          /*title: ValueListenableBuilder<User?>(
              valueListenable: Repository().user,
              builder: (BuildContext context, User? user, Widget? child) {

                return Row(
                  children:  [
                    const Text("Home"),
                    const Spacer(),
                    if(user == null)
                    const LoginButton(),
                  ],
                );
              })*/
        ),
        drawer: Drawer(
          child: userId == '' || !_isLoggedIn
              ? ListView(
                  children: [
                    const DrawerHeader(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Text(
                        'Please Login First',
                        textAlign: TextAlign.center,
                        textScaleFactor: 2.0,
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          GoRouter.of(context).pushNamed(RouterName.Login);
                        },
                        child: const Text(
                          'Login',
                          textScaleFactor: 2.0,
                        )),
                    TextButton(
                        onPressed: () {
                          GoRouter.of(context).pushNamed(RouterName.SignUp);
                        },
                        child: const Text(
                          'Sign Up',
                          textScaleFactor: 2.0,
                        ))
                  ],
                )
              : ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.lightGreen,
                      ),
                      child: Text(
                        'Menu',
                      ),
                    ),
                    ListTile(
                      title: const Text('Profile'),
                      onTap: () {
                        GoRouter.of(context)
                            .pushNamed(RouterName.profilePage, params: {
                          'userId': userId,
                        });
                      },
                    ),
                    ListTile(
                      title: const Text('Calendar'),
                      onTap: () {
                        context.pushNamed(RouterName.CalendarConsumer, params: {
                          'userId': userId,
                        });
                      },
                    ),
                    ListTile(
                      title: const Text('Chat'),
                      onTap: () {
                        GoRouter.of(context)
                            .pushNamed(RouterName.chat, params: {
                          'userId': userId,
                        });
                      },
                    ),
                    ListTile(
                      title: const Text('History Boookings'),
                      onTap: () {
                        GoRouter.of(context)
                            .pushNamed(RouterName.BookingHistory, params: {
                          'userId': userId,
                        });
                      },
                    ),
                    /*
                  ListTile(
                    title: Text(
                      _isLoggedIn ? 'Logout' : 'Login',
                    ),
                    onTap: _isLoggedIn ? _showLogoutDialog : () {},
                  ),
                  */
                  ],
                ),
        ),
        body: SafeArea(
          child: Scrollbar(
            isAlwaysShown: isWeb(),
            controller: scrollController,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Container(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      constraints: const BoxConstraints(maxWidth: maxWidth),
                      child: Column(children: [
                        SizedBox(height:  MediaQuery.of(context).size.height*0.1),
                        const GraphicalBanner(),
                        SizedBox(height: MediaQuery.of(context).size.height*0.1),
                        SearchBar(
                          userId: userId,
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height*0.1),
                        const AboutJemma(),
                        SizedBox(height:  MediaQuery.of(context).size.height*0.1),
                        WhyJemma(),
                      ]),
                    ),
                    if (isWeb()) const WebFooter()
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

Future<bool> isConsumer(userId) async {
  bool result = false;
  if(userId!='' || userId == null){
    await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: userId)
        .get()
        .then(
          (querySnapshot) {
        if (querySnapshot.docs[0].data()['Is_Tradie']) {
          result = true;
        } else {
          result = false;
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }
  return result;
}

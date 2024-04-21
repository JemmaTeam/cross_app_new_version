import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_cross_app/Home%20Page/responsive.dart';
import 'package:new_cross_app/Profile/register_tradie.dart';
import 'package:new_cross_app/Profile/tradie_work_publish.dart';
import 'package:new_cross_app/search/image_display_const.dart';
import '../Home Page/constants.dart';
import '../Home Page/decorations.dart';
import '../Home Page/home.dart';
import '../Routes/route_const.dart';
import '../search/rate_star_widget.dart';
import 'customer_info_edit.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'dart:js' as js;


import '../services/platform_service.dart';


class ProfileHome extends StatefulWidget {
  String userId;

  ProfileHome({super.key, required this.userId});

  @override
  _ProfileHomeState createState() => _ProfileHomeState(userId: userId);
}

bool _isConsumer = true;
final databaseReference = FirebaseFirestore.instance;
final CollectionReference colRef = databaseReference.collection('users');
final PlatformService platformService = PlatformService();

class _ProfileHomeState extends State<ProfileHome> {
  String userId;

  _ProfileHomeState({required this.userId});

  // General customer information
  String name = "";
  String address = "";
  String email = "";
  String phone = "";

  // Tradie information
  String licenseNumber = "";
  String lincensePic = ImageURL.certificateDefault;
  String workType = "";
  String workTitle = "";
  num workStart = 0;
  num workEnd = 0;
  bool workWeekend = false;
  num rate = 0;
  num tOrders = 0;
  String workDescription = "";

  @override
  void initState() {
    super.initState();
    getUserProfile(userId);
  }

  Future<void> getUserProfile(String userId) async {
    DocumentSnapshot docSnapshot = await colRef.doc(userId).get();
    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

    // Set general customer info
    setState(() {
      _isConsumer = !data['Is_Tradie'];
      name =
          data['fullName']?.isEmpty ? 'No Name Information' : data['fullName'];
      address =
          data['address']?.isEmpty ? 'No Address Information' : data['address'];
      email = data['email']?.isEmpty ? 'No Mail Information' : data['email'];
      phone = data['Phone']?.isEmpty ? 'No Phone Information' : data['Phone'];
    });

    // Set tradie info
    if (data['Is_Tradie']) {
      setState(() {
        licenseNumber = data['licenseNumber']?.isEmpty
            ? 'No Information'
            : data['licenseNumber'];
        workType =
            data['workType']?.isEmpty ? 'No Information' : data['workType'];
        workTitle =
            data['workTitle']?.isEmpty ? 'No Information' : data['workTitle'];
        workDescription = data['workDescription']?.isEmpty
            ? 'No Information'
            : data['workDescription'];
        workWeekend = data['workWeekend'];
        workStart = data['workStart'];
        workEnd = data['workEnd'];
        rate = data['rate'];
        tOrders = data['tOrders'];
        if (data.containsKey('lincensePic')) {
          if(!data['lincensePic'].isEmpty){
            lincensePic = data['lincensePic'];
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(color: Colors.black54)),
      ),
      body: Scrollbar(
        controller: scrollController,
        child: Center(
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(children: [
              // General customer information part
              customerInfo(size),
              SizedBox(height: size.height * 0.025), // 替换 2.5.ph(size)
              // Tradie register button
              if (_isConsumer)
                TextButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                RegisterTradiePage(uid: userId)),
                      );
                      if (result.toString() == 'update') {
                        await getUserProfile(userId);
                        setState(() {}); // update the state
                      }
                    },
                    child: const Text('Register as a tradie',
                        style: TextStyle(color: Colors.black87))),
              // Tradie information part
              if (!_isConsumer)
                Container(
                  width: size.width * 0.50, // 替换 50.pw(size)
                  constraints: const BoxConstraints(minWidth: 400),
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: defaultShadows,
                    borderRadius: BorderRadius.circular(HomeState.borderRadius),
                    border: Border.all(
                      color: kLogoColor,
                      width: 2.0,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text('Tradie Information',
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.w600)),
                      certificateInfo(size),
                      stripeAccount(size),
                      ratingInfo(size),
                      workingDetails(size),
                    ],
                  ),
                ),
            ]),
          ),
        ),
      ),
    );
  }


  Container customerInfo(Size size) {
    return Container(
      width: size.width * 0.50,  // 替换 50.pw(size)
      // height: 240,
      constraints: const BoxConstraints(minWidth: 400),
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
      padding: EdgeInsets.all(size.width * 0.04),  // 替换 4.pw(size)
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: defaultShadows,
        borderRadius: BorderRadius.circular(HomeState.borderRadius),
        border: Border.all(
          color: kLogoColor,
          width: 2.0,
        ),
      ),
      child: Row(
        children: [
          // avatar and contact
          // TODO: change to the actual avatar image of the logged user
          const CircleAvatar(
            backgroundImage: AssetImage("images/Tom.jpg"),
            radius: 55,
          ),
          // Personal Info
          SizedBox(width: size.width * 0.05),  // 替换 5.pw(size)
          Stack(clipBehavior: Clip.none, children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.w600)),
                SizedBox(height: size.height * 0.06),  // 替换 6.ph(size)
                Text(
                  email,
                  style: const TextStyle(color: Colors.black87),
                ),
                SizedBox(height: size.height * 0.03),  // 替换 3.ph(size)
                Container(
                  width: size.width * 0.25,  // 替换 25.pw(size)
                  constraints: const BoxConstraints(minWidth: 150),
                  child: Text(
                    address,
                    style: const TextStyle(color: Colors.black87),
                  ),
                ),
                SizedBox(height: size.height * 0.03),  // 替换 3.ph(size)
                Text(
                  phone,
                  style: const TextStyle(color: Colors.black87),
                ),
              ],
            ),
            Positioned(
                top: -5,
                right: 0,
                child: IconButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CustomerInfoEdit(userID: userId)),
                    );
                    if (result.toString() == 'update') {
                      await getUserProfile(userId);
                      setState(() {}); // update the state
                    }
                  },
                  icon: const Icon(Icons.edit, size: 20),
                ))
          ]),
        ],
      ),
    );
  }


  Container certificateInfo(Size size) {
    return Container(
        width: size.width * 0.40, // 替换 40.pw(size)
        constraints: const BoxConstraints(minWidth: 320),
        margin: EdgeInsets.fromLTRB(size.width * 0.01, 30, size.width * 0.01, 0), // 替换 1.pw(size) 两侧
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: defaultShadows,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Title
              const Text(
                'Certification',
                style: TextStyle(
                    color: kTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: size.height * 0.02), // 替换 2.ph(size)
              // Display information
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: 120,
                      height: 100,
                      child: CachedNetworkImage(
                        imageUrl: lincensePic,
                        placeholder: (context, url) => CircularProgressIndicator(), // placeholder when loading
                        errorWidget: (context, url, error) => Icon(Icons.error), // error icon
                      )
                  ),
                  SizedBox(width: size.width * 0.04), // 替换 4.pw(size)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height * 0.015), // 替换 1.5.ph(size)
                      // Work type information
                      Text(workType, style: TextStyle(fontSize: 12)),
                      SizedBox(height: size.height * 0.015), // 替换 1.5.ph(size)
                      // License number information
                      Text(licenseNumber, style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ]),
            // Button to edit the certification information
            Positioned(
                top: -10,
                right: 10,
                child: IconButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterTradiePage(uid: userId)),
                    );
                    if (result.toString() == 'update') {
                      await getUserProfile(userId);
                      setState(() {}); // update the state
                    }
                  },
                  icon: Icon(Icons.edit, size: 20),
                ))
          ],
        ));
  }


  Container stripeAccount(Size size) {
    return Container(
      width: size.width * 0.40,  // 替换了 40.pw(size)
      constraints: const BoxConstraints(minWidth: 320),
      margin: EdgeInsets.fromLTRB(size.width * 0.01, 30, size.width * 0.01, 0), // 替换了 1.pw(size)
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: defaultShadows,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Stripe Account',
            style: TextStyle(
                color: kTextColor, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: size.height * 0.02), // 替换了 2.ph(size)
          Row(
            children: [
              Icon(
                Icons.account_box,
                color: Colors.green.shade500,
              ),
              TextButton(
                  onPressed: () {
                    createStripeConnectAccount(userId);
                  },
                  child: const Text(
                    "Go to your stripe account",
                    style: TextStyle(color: Colors.black87),
                  ))
            ],
          ),
        ],
      ),
    );
  }


  Container ratingInfo(Size size) {
    // Set the average rating scores
    num averageRate = 0;
    if (tOrders == 0) {
      averageRate = rate;
    } else {
      averageRate = rate / tOrders;
    }
    return Container(
      width: size.width * 0.40,  // Replaced 40.pw(size)
      constraints: const BoxConstraints(minWidth: 320),
      margin: EdgeInsets.fromLTRB(size.width * 0.01, 30, size.width * 0.01, 0), // Replaced 1.pw(size)
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: defaultShadows,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text(
          'Tradie Rating',
          style: TextStyle(
              color: kTextColor, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: size.height * 0.02), // Replaced 2.ph(size)
        // Create a row to display rating stars and actual rating number
        buildRateStars(averageRate, 'start'),
      ]),
    );
  }


  Container workingDetails(Size size) {
    String workTime = "";
    if (workStart == 0 && workEnd == 0) {
      workTime = "No information";
    } else {
      String workStartSuffix =
      workStart >= 12 && workStart < 24 ? ":00 PM" : ":00 AM";
      String workEndSuffix =
      workEnd >= 12 && workEnd < 24 ? ":00 PM" : ":00 AM";
      if (workWeekend) {
        workTime = 'Monday to Sunday: $workStart$workStartSuffix to $workEnd$workEndSuffix';
      }
      if (!workWeekend) {
        workTime = 'Monday to Friday: $workStart$workStartSuffix to $workEnd$workEndSuffix\nNo Work on Weekends';
      }
    }
    return Container(
        width: size.width * 0.40, // 替换 40.pw(size)
        constraints: const BoxConstraints(minWidth: 320),
        margin: EdgeInsets.fromLTRB(size.width * 0.01, 30, size.width * 0.01, 0), // 替换 1.pw(size)
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: defaultShadows,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Display information
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Work Title
                const Text(
                  'Work Title',
                  style: TextStyle(
                      color: kTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: size.height * 0.02), // 替换 2.ph(size)
                Container(
                  padding: EdgeInsets.fromLTRB(size.width * 0.01, 4, size.width * 0.01, 4), // 替换 1.pw(size)
                  width: size.width * 0.36, // 替换 36.pw(size)
                  constraints:
                  const BoxConstraints(minWidth: 240, maxHeight: 50),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.grey.withOpacity(0.15)),
                  child: Text(workTitle,
                      style: const TextStyle(color: Colors.black54, fontSize: 10)),
                ),
                SizedBox(height: size.height * 0.03), // 替换 3.ph(size)
                // Working Time
                const Text(
                  'Working Time',
                  style: TextStyle(
                      color: kTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: size.height * 0.02), // 替换 2.ph(size)
                Container(
                  padding: EdgeInsets.fromLTRB(size.width * 0.01, 4, size.width * 0.01, 4), // 替换 1.pw(size)
                  width: size.width * 0.36, // 替换 36.pw(size)
                  constraints:
                  const BoxConstraints(minWidth: 240, maxHeight: 50),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.grey.withOpacity(0.15)),
                  child: Text(workTime,
                      style: const TextStyle(color: Colors.black54, fontSize: 10)),
                ),
                SizedBox(height: size.height * 0.03), // 替换 3.ph(size)
                // Work Description
                const Text(
                  'Work Description',
                  style: TextStyle(
                      color: kTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: size.height * 0.02), // 替换 2.ph(size)
                Container(
                  padding: EdgeInsets.fromLTRB(size.width * 0.01, 4, size.width * 0.01, 4), // 替换 1.pw(size)
                  width: size.width * 0.36, // 替换 36.pw(size)
                  constraints:
                  const BoxConstraints(minWidth: 240, maxHeight: 50),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.grey.withOpacity(0.15)),
                  child: Text(workDescription,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black54, fontSize: 10)),
                ),
              ],
            ),
            // Edit information button
            Positioned(
                top: -18,
                right: 10,
                child: IconButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TradieWorkPublish(userID: userId)),
                    );
                    if (result.toString() == 'update') {
                      await getUserProfile(userId);
                      setState(() {}); // update State
                    }
                  },
                  icon: Icon(Icons.edit, size: 20),
                ))
          ],
        ));
  }


  Future<void> createStripeConnectAccount(String userId) async {
    Map<String, String> body = {'userId': userId};
    await http
        .post(
            Uri.parse(
                'https://us-central1-jemma-b0fcd.cloudfunctions.net/createConnectAccount'),
            body: body)
        .then((response) {
      if (response.statusCode == 200) {
        print('请求成功：${response.body}');
        Map<String, dynamic> responseMap = json.decode(response.body);
        String accountId = responseMap['id']!.toString();
        print(accountId);
        FirebaseFirestore.instance.collection('users').doc(userId).update({
          'stripeId': accountId,
        });
        platformService.openExternalUrl(responseMap['url']!.toString());
        // openExternalUrl(responseMap['url']!.toString());
      } else {
        print('请求失败：${response.statusCode}');
      }
    }).catchError((error) {
      print(error.toString());
    });
  }

  // void openExternalUrl(String url) {
  //   js.context.callMethod('openExternalUrl', [url]);
  // }
}

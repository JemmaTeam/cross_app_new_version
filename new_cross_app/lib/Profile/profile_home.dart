import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_cross_app/Home%20Page/responsive.dart';
import 'package:new_cross_app/Profile/register_tradie.dart';
import 'package:new_cross_app/Profile/tradie_work_publish.dart';
import '../Home Page/constants.dart';
import '../Home Page/decorations.dart';
import '../Home Page/home.dart';
import '../Routes/route_const.dart';
import '../search/certificate_image_display.dart';
import 'customer_info_edit.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher_string.dart';
import 'dart:js' as js;

class ProfileHome extends StatefulWidget {
  String userId;

  ProfileHome({super.key, required this.userId});

  @override
  _ProfileHomeState createState() => _ProfileHomeState(userId: userId);
}

bool _isConsumer = true;
final databaseReference = FirebaseFirestore.instance;
final CollectionReference colRef = databaseReference.collection('users');

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
  // TODO: need to change the default certificate image
  String lincensePic = "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1f/Oryctolagus_cuniculus_Rcdo.jpg/1200px-Oryctolagus_cuniculus_Rcdo.jpg";
  String workType = "";
  String workTitle = "";
  num workStart = 0;
  num workEnd = 0;
  bool workWeekend = false;
  String rate = "";
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
        //TODO: need to change the default certificate image
        if (data.containsKey('lincensePic')) {
          lincensePic = data['lincensePic'].isEmpty
              ? 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1f/Oryctolagus_cuniculus_Rcdo.jpg/1200px-Oryctolagus_cuniculus_Rcdo.jpg'
              : data['lincensePic'];
        } else {
          lincensePic =
              'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1f/Oryctolagus_cuniculus_Rcdo.jpg/1200px-Oryctolagus_cuniculus_Rcdo.jpg';
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
              SizedBox(height: 2.5.ph(size)),
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
                        setState(() {}); // 更新状态
                      }
                    },
                    child: const Text('Register as a tradie',
                        style: TextStyle(color: Colors.black87))),
              // Tradie information part
              if (!_isConsumer)
                Container(
                  width: 50.pw(size),
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
      width: 50.pw(size),
      // height: 240,
      constraints: const BoxConstraints(minWidth: 400),
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
      padding: EdgeInsets.all(4.pw(size)),
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
          CircleAvatar(
            backgroundImage: AssetImage("images/Tom.jpg"),
            radius: 55,
          ),
          // Personal Info
          SizedBox(width: 5.pw(size)),
          Stack(clipBehavior: Clip.none, children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.w600)),
                SizedBox(height: 6.ph(size)),
                Text(
                  email,
                  style: TextStyle(color: Colors.black87),
                ),
                SizedBox(height: 3.ph(size)),
                Container(
                  width: 25.pw(size),
                  constraints: const BoxConstraints(minWidth: 150),
                  child: Text(
                    address,
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
                SizedBox(height: 3.ph(size)),
                Text(
                  phone,
                  style: TextStyle(color: Colors.black87),
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
                      setState(() {}); // 更新状态
                    }
                  },
                  icon: Icon(Icons.edit, size: 20),
                ))
          ]),
        ],
      ),
    );
  }

  Container certificateInfo(Size size) {
    return Container(
        width: 40.pw(size),
        constraints: const BoxConstraints(minWidth: 320),
        margin: EdgeInsets.fromLTRB(1.pw(size), 30, 1.pw(size), 0),
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
              SizedBox(height: 2.ph(size)),
              // Display information
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Certificate image
                  // Image(
                  //   image: AssetImage("images/certificate.png"),
                  //   width: 100,
                  // ),
                  // TODO: image display error needs to be fixed
                  Container(
                      width: 100,
                      height: 80,
                      child: CertificateDisplay(imageUrl: lincensePic)),
                  SizedBox(width: 4.pw(size)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 1.5.ph(size)),
                      // Work type information
                      Text(workType, style: TextStyle(fontSize: 12)),
                      SizedBox(height: 1.5.ph(size)),
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
                  onPressed: () {},
                  icon: Icon(Icons.edit, size: 20),
                ))
          ],
        ));
  }

  Container stripeAccount(Size size) {
    return Container(
      width: 40.pw(size),
      constraints: const BoxConstraints(minWidth: 320),
      margin: EdgeInsets.fromLTRB(1.pw(size), 30, 1.pw(size), 0),
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
          SizedBox(height: 2.ph(size)),
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
    return Container(
      width: 40.pw(size),
      constraints: const BoxConstraints(minWidth: 320),
      margin: EdgeInsets.fromLTRB(1.pw(size), 30, 1.pw(size), 0),
      padding: EdgeInsets.all(20),
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
        SizedBox(height: 2.ph(size)),
        // TODO: replace with the actual rating score
        Image(
          image: AssetImage("images/five_star.png"),
          width: 150,
        ),
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
        width: 40.pw(size),
        constraints: const BoxConstraints(minWidth: 320),
        margin: EdgeInsets.fromLTRB(1.pw(size), 30, 1.pw(size), 0),
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
                SizedBox(height: 2.ph(size)),
                Container(
                  padding: EdgeInsets.fromLTRB(1.pw(size), 4, 1.pw(size), 4),
                  width: 36.pw(size),
                  constraints:
                      const BoxConstraints(minWidth: 240, maxHeight: 50),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.grey.withOpacity(0.15)),
                  child: Text(workTitle,
                      style: const TextStyle(color: Colors.black54, fontSize: 10)),
                ),
                SizedBox(height: 3.ph(size)),
                // Working Time
                const Text(
                  'Working Time',
                  style: TextStyle(
                      color: kTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 2.ph(size)),
                Container(
                  padding: EdgeInsets.fromLTRB(1.pw(size), 4, 1.pw(size), 4),
                  width: 36.pw(size),
                  constraints:
                      const BoxConstraints(minWidth: 240, maxHeight: 50),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.grey.withOpacity(0.15)),
                  child: Text(workTime,
                      style: const TextStyle(color: Colors.black54, fontSize: 10)),
                ),
                SizedBox(height: 2.ph(size)),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: Colors.green.shade500,
                    ),
                    TextButton(
                        onPressed: () {
                          GoRouter.of(context).pushReplacementNamed(
                              RouterName.CalendarTradie,
                              params: {'userId': userId});
                        },
                        child: const Text(
                          "Go to Tradie's Calendar",
                          style: TextStyle(color: Colors.black87),
                        ))
                  ],
                ),
                SizedBox(height: 3.ph(size)),
                // Work Description
                const Text(
                  'Work Description',
                  style: TextStyle(
                      color: kTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 2.ph(size)),
                Container(
                  padding: EdgeInsets.fromLTRB(1.pw(size), 4, 1.pw(size), 4),
                  width: 36.pw(size),
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
                      setState(() {}); // 更新状态
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
        openExternalUrl(responseMap['url']!.toString());
      } else {
        print('请求失败：${response.statusCode}');
      }
    }).catchError((error) {
      print(error.toString());
    });
  }

  void openExternalUrl(String url) {
    js.context.callMethod('openExternalUrl', [url]);
  }
}

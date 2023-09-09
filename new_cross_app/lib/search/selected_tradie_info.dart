import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

import '../Home Page/constants.dart';
import '../Routes/route_const.dart';

/// Initialize Firestore database and user collection references
final databaseReference = FirebaseFirestore.instance;
final CollectionReference colRef = databaseReference.collection('users');

/// StatefulWidget to display selected tradie information
class SelectedTradieInfo extends StatefulWidget {
  final String userId;
  final String selectedUserId;

  SelectedTradieInfo({required this.userId, required this.selectedUserId});

  @override
  _SelectedTradieInfoState createState() =>
      _SelectedTradieInfoState(selectedUserId: selectedUserId);
}

class _SelectedTradieInfoState extends State<SelectedTradieInfo> {
  String selectedUserId;

  _SelectedTradieInfoState({required this.selectedUserId});

  // Variables to hold tradie information
  String name = "";
  String licenseNumber = "";
  String lincensePic = "";
  String workType = "";
  String workTitle = "";
  num workStart = 0;
  num workEnd = 0;
  bool workWeekend = false;
  num rate = 0;
  String workDescription = "";

  @override
  void initState() {
    super.initState();
    // Fetch user profile data when the widget is initialized
    getUserProfile(selectedUserId);
  }

  /// Async function to fetch and set user profile data
  Future<void> getUserProfile(String userId) async {
    // Fetch user document from Firestore
    DocumentSnapshot docSnapshot = await colRef.doc(userId).get();
    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

    // Update the state with fetched tradie information
    setState(() {
      name = data['fullName']?.isEmpty ? 'No Name Information' : data['fullName'];
      licenseNumber = data['licenseNumber']?.isEmpty ? 'No Information' : data['licenseNumber'];
      workType = data['workType']?.isEmpty ? 'No Information' : data['workType'];
      workTitle = data['workTitle']?.isEmpty ? 'No Information' : data['workTitle'];
      workDescription = data['workDescription']?.isEmpty ? 'No Information' : data['workDescription'];
      workWeekend = data['workWeekend'];
      workStart = data['workStart'];
      workEnd = data['workEnd'];
      rate = data['rate'];
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive layout
    double screenWidth = MediaQuery.of(context).size.width;

    // Initialize workTime to store working hours information
    String workTime = "";

    // Check if workStart and workEnd are zero (meaning no information)
    if (workStart == 0 && workEnd == 0) {
      workTime = "No information";
    } else {
      // Determine the time suffix for workStart and workEnd (AM or PM)
      String workStartSuffix =
          workStart >= 12 && workStart < 24 ? ":00 PM" : ":00 AM";
      String workEndSuffix =
          workEnd >= 12 && workEnd < 24 ? ":00 PM" : ":00 AM";
      // Update workTime based on whether work is available on weekends or not
      if (workWeekend) {
        workTime = 'Monday to Sunday: $workStart$workStartSuffix to $workEnd$workEndSuffix';
      }
      if (!workWeekend) {
        workTime = 'Monday to Friday: $workStart$workStartSuffix to $workEnd$workEndSuffix\nNo Work on Weekends';
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tradie Details"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display workTitle in bold
              Text(
                workTitle,
                textAlign: TextAlign.center, // Center-align text
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // TODO: replace the following image with the actual certificate image
              Image(
                image: AssetImage("images/certificate.png"),
                width: 300, // // Set image width
                height: 250, // Set image height
                fit: BoxFit.fill, // Fill the entire part, some images may be stretched or compressed
              ),
              const SizedBox(height: 8),
              // Display license number
              Text(
                licenseNumber,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              // Display tradie name in bold
              Text(
                name,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // Display workType
              Text(
                workType,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Generate star icons based on rating
                  ...getStarIconsBasedOnRate(rate),
                  const SizedBox(width: 4),
                  // Display the rating number
                  Text(
                    rate.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Display work description title
              const Text(
                "Work Description:",
                textAlign: TextAlign.center, // Center-align text
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              // Display work description
              ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 400,
                  maxWidth: screenWidth * 2 / 3,
                ),
                child: Text(
                  workDescription,
                  textAlign: TextAlign.center, // Center-align text
                  style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
              ),
              const SizedBox(height: 16),
              // Display work time title
              const Text(
                "Work Time:",
                textAlign: TextAlign.center, // Add this line for center alignment
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              // Display work time
              Text(
                workTime,
                textAlign: TextAlign.center,
                // Add this line for center alignment
                style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Chat button
                  ElevatedButton(
                    onPressed: () {
                      //TODO: Navigate to chat page and pass required parameters
                    },
                    style: ElevatedButton.styleFrom(primary: kLogoColor, elevation: 2),
                    child: const Text(
                      "Chat",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Booking button
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to Booking page and pass required parameters
                      GoRouter.of(context).pushNamed(RouterName.Booking,params: {'userId':widget.userId,'tradieId':selectedUserId});
                    },
                    style: ElevatedButton.styleFrom(primary: kLogoColor, elevation: 2),
                    child: const Text(
                      "Booking",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Return the corresponding star icon based on the rating
  List<Icon> getStarIconsBasedOnRate(dynamic rate) {
    // Parse the rate to double, default to 0.0 if rate is not a number (or no rating available)
    double parsedRate = rate is num ? rate.toDouble() : 0.0;

    // Calculate the number of full stars and half stars
    int fullStars = parsedRate.floor();
    int halfStars = parsedRate.ceil() - fullStars;

    // Initialize an empty list to hold the star icons
    List<Icon> stars = [];

    // If the parsed rate is zero, then add an empty star
    if (parsedRate == 0.0) {
      stars.add(const Icon(Icons.star_border_outlined, color: Colors.yellow));
    } else {
      // Add full star icons based on the fullStars count
      for (int i = 0; i < fullStars; i++) {
        stars.add(const Icon(Icons.star, color: Colors.yellow));
      }
      // If there's a half star, add a half star icon
      if (halfStars > 0) {
        stars.add(const Icon(Icons.star_half, color: Colors.yellow));
      }
    }

    return stars; // Return the list of star icons
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:new_cross_app/search/rate_star_widget.dart';

import '../Home Page/constants.dart';
import '../Routes/route_const.dart';
import '../services/database_service.dart';
import 'image_display_const.dart';

// Initialize a reference to the Firestore database.
final databaseReference = FirebaseFirestore.instance;
// Create a reference to the 'users' collection within the Firestore database.
final CollectionReference colRef = databaseReference.collection('users');
// Instantiate the DatabaseService class for database-related operations.
DatabaseService databaseservice = DatabaseService();

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
  String lincensePic =
      ImageURL.certificateDefault; // initialize with the default image
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
      name =
          data['fullName']?.isEmpty ? 'No Name Information' : data['fullName'];
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
        if (!data['lincensePic'].isEmpty) {
          lincensePic = data['lincensePic'];
        }
      }
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
        workTime =
            'Monday to Sunday: $workStart$workStartSuffix to $workEnd$workEndSuffix';
      }
      if (!workWeekend) {
        workTime =
            'Monday to Friday: $workStart$workStartSuffix to $workEnd$workEndSuffix\nNo Work on Weekends';
      }
    }
    // Set the average rating scores
    num averageRate = 0;
    if (tOrders == 0) {
      averageRate = rate;
    } else {
      averageRate = rate / tOrders;
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
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // TODO: replace the following image with the actual certificate image
              Container(
                  width: 420,
                  height: 350,
                  child: CachedNetworkImage(
                    imageUrl: lincensePic,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    // placeholder when loading
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error), // error icon
                  )),

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
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // Display workType
              Text(
                workType,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              // Create a row to display rating stars and actual rating number
              buildRateStars(averageRate, 'center'),
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
                  style: const TextStyle(
                      fontSize: 16, fontStyle: FontStyle.italic),
                ),
              ),
              const SizedBox(height: 16),
              // Display work time title
              const Text(
                "Work Time:",
                textAlign: TextAlign.center,
                // Add this line for center alignment
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              // Display work time
              Text(
                workTime,
                textAlign: TextAlign.center,
                // Add this line for center alignment
                style:
                    const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ElevatedButton widget for initiating a chat.
                  ElevatedButton(
                    onPressed: () async {
                      // Generate a chatRoomID based on the current user ID and the selected user ID.
                      String chatRoomID =
                          getChatRoomId(widget.userId, widget.selectedUserId);
                      // Check if a chat room with the generated ID already exists.
                      bool exists = await checkChatRoomExists(chatRoomID);
                      // If the chat room does not exist, create one.
                      if (!exists) {
                        // Create a list of users involved in the chat room.
                        List<String> users = [
                          widget.userId,
                          widget.selectedUserId
                        ];
                        // Create a map object to hold the chat room data.
                        Map<String, dynamic> chatRoom = {
                          "users": users,
                          "chatRoomId": chatRoomID,
                        };
                        // Add the new chat room to the database.
                        databaseservice.addChatRoom(chatRoom, chatRoomID);
                      }
                      // Navigate to the ChatRoom screen, passing in the user ID and chat room ID as parameters.
                      GoRouter.of(context)
                          .pushNamed(RouterName.ChatRoom, params: {
                        'userId': widget.userId,
                        'chatRoomId': chatRoomID,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        primary: kLogoColor, elevation: 2),
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
                      GoRouter.of(context).pushNamed(RouterName.Booking,
                          params: {
                            'userId': widget.userId,
                            'tradieId': selectedUserId
                          });
                    },
                    style: ElevatedButton.styleFrom(
                        primary: kLogoColor, elevation: 2),
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

  /// Function to generate a chat room ID based on two user IDs
  getChatRoomId(String userIdA, String userIdB) {
    // Compare the ASCII code of the first character of userIdA and userIdB.
    if (userIdA.substring(0, 1).codeUnitAt(0) >
        userIdB.substring(0, 1).codeUnitAt(0)) {
      // If the ASCII code of the first character in userIdA is greater than that in userIdB,
      // return a string combining userId B and A, separated by an underscore.
      return "$userIdB\_$userIdA";
    } else {
      // Otherwise, return a string combining userId A and B, separated by an underscore.
      return "${userIdA}_$userIdB";
    }
  }

  /// Asynchronous function to check if a chat room with a given ID exists in the Firestore database.
  Future<bool> checkChatRoomExists(String chatRoomID) async {
    // Execute a Firestore query to get documents from the 'chatRoom' collection that match the given chatRoomID.
    final QuerySnapshot result = await databaseReference
        .collection('chatRoom') // Specify the collection to query.
        .where('chatRoomId', isEqualTo: chatRoomID) // Set the query condition.
        .get(); // Execute the query.

    // Retrieve all documents that match the query.
    final List<DocumentSnapshot> documents = result.docs;

    // Return true if one or more documents are found, otherwise return false.
    return documents.length > 0;
  }
}

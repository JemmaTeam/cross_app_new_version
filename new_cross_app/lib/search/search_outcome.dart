import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_cross_app/search/rate_star_widget.dart';
import 'package:new_cross_app/search/selected_tradie_info.dart';

import '../Home Page/constants.dart';
import '../Home Page/decorations.dart';
import '../Home Page/home.dart';
import 'image_display_const.dart';

class SearchOutcome extends StatefulWidget {
  final String userId;
  final String postcode;
  final String workType;

  SearchOutcome(
      {required this.userId, required this.postcode, required this.workType});

  @override
  _SearchOutcomeState createState() => _SearchOutcomeState();
}

class _SearchOutcomeState extends State<SearchOutcome> {
  late Stream<QuerySnapshot> _userStream;
  num itemWidth = 400;
  num itemHeight = 450;

  @override
  void initState() {
    super.initState();

    _userStream = FirebaseFirestore.instance
        .collection('users')
        .where('Is_Tradie', isEqualTo: true)
        .where('postcode', isEqualTo: widget.postcode)
        .where('workType', isEqualTo: widget.workType)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Available Tradies')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          // Filter out documents with empty "WorkTitle"
          final docs = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data['workTitle'] != '' && data['uid'] != widget.userId && (data['workStart'] != 0 || data['workEnd'] != 0);
          }).toList();

          // If docs.length is 0, display prompt information
          if (docs.length == 0) {
            return const Center(
              child: Text(
                "There is no available tradies based on your search criteria, please reset your search criteria.",
                textAlign: TextAlign.center,
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              // Calculate the maximum number of items that can be placed in each row
              final crossAxisCount = (constraints.maxWidth / itemWidth).floor();
              // The minimum is 1 to prevent division by 0 errors
              final effectiveCrossAxisCount = max(1, crossAxisCount);
              // Calculate the remaining width and distribute it evenly to each item
              final double spacing = (constraints.maxWidth -
                      (effectiveCrossAxisCount * itemWidth)) /
                  (effectiveCrossAxisCount + 1);

              return GridView.builder(
                padding: EdgeInsets.all(spacing),
                //Set padding based on remaining space
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: effectiveCrossAxisCount,
                  mainAxisSpacing: 20, //Set the vertical axis spacing
                  crossAxisSpacing: spacing, // Set horizontal axis spacing
                  childAspectRatio:
                      1.0 * (itemWidth / itemHeight), // Set aspect ratio
                ),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  return GestureDetector(
                    onTap: () {
                      // Jump to new page and pass parameters
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectedTradieInfo(
                            userId: widget.userId,
                            selectedUserId: data['uid'],
                          ),
                        ),
                      );
                    },
                    child: buildTradieItem(data),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

/// Function to build an individual item for a tradie
  Widget buildTradieItem(Map<String, dynamic> data) {
    // Set the certificate image URL, if not exists, use the default one
    String lincensePic = ImageURL.certificateDefault;
    if (data.containsKey('lincensePic')) {
      if(!data['lincensePic'].isEmpty){
        lincensePic = data['lincensePic'];
      }
    }
    return Container(
      // Padding and margin settings
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(10),
      // Set the decoration for the container
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: defaultShadows,
        borderRadius: BorderRadius.circular(HomeState.borderRadius),
        border: Border.all(
          color: kLogoColor,
          width: 2.0,
        ),
      ),
      // Create a column to stack children vertically
      child: Column(
        // Center align the items on the cross-axis
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            // Display work title, default to 'Unknown' if empty
            data['workTitle'].isEmpty ? 'Unknown' : data['workTitle'],
            textAlign: TextAlign.center, // Add this line for center alignment
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          // Add some vertical space
          const SizedBox(height: 8),
          // Display the certificate image. If not exists, display the default one.
          Container(
              width: 300,
              height: 250,
              child:
              CachedNetworkImage(
                imageUrl: lincensePic,
                placeholder: (context, url) => CircularProgressIndicator(), // placeholder when loading
                errorWidget: (context, url, error) => Icon(Icons.error), // error icon
              )
          ),
          // Add some more vertical space
          const SizedBox(height: 8),
          // Display full name, default to 'Unknown' if empty
          Text(
            data['fullName'].isEmpty ? 'Unknown' : data['fullName'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          // Add some more vertical space
          const SizedBox(height: 4),
          // Display work type, default to 'Unknown' if empty
          Text(
            data['workType'].isEmpty ? 'Unknown' : data['workType'],
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          // Add some more vertical space
          const SizedBox(height: 4),
          // Create a row to display rating stars and actual rating number
          buildRateStars(data['rate'], 'center'),
        ],
      ),
    );
  }
}

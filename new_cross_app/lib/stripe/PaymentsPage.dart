import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Widget for displaying a list of payments retrieved from Firestore
class PaymentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('payments').snapshots(),
      builder: (context, snapshot) {
        // Check if there's an error in the snapshot
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');

        // If data is not available yet, display a loading indicator
        if (!snapshot.hasData) return CircularProgressIndicator();

        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Text('Awaiting...'); // While waiting for data, show this message
          default:
          // Build a ListView based on the data in Firestore
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = snapshot.data!.docs[index];
                // Handle your data and display notifications or relevant UI changes
                return ListTile(
                  title: Text(document['description'] ?? 'No Description'),
                  // You can add more fields from the document as necessary
                );
              },
            );
        }
      },
    );
  }
}

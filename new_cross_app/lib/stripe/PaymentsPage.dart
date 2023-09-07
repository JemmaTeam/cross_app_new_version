import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('payments').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        if (!snapshot.hasData) return CircularProgressIndicator();

        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Text('Awaiting...');
          default:
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = snapshot.data!.docs[index];
                // Handle your data and display notifications or relevant UI changes
                return ListTile(
                  title: Text(document['description'] ?? 'No Description'),
                  // Add more fields as necessary
                );
              },
            );
        }
      },
    );
  }
}


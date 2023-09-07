import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';




class NotificationPanel extends StatefulWidget {

  const NotificationPanel({Key? key}) : super(key: key);

  @override
  _NotificationPanelState createState() => _NotificationPanelState();


}

class _NotificationPanelState extends State<NotificationPanel> {
  final _read = new Set<String>();
  final _biggerFont = const TextStyle(fontSize: 16.0);

  final consumerId = FirebaseAuth.instance.currentUser!
      .uid; // This gets the current user's ID
  late Stream<QuerySnapshot> userNotifications;

  @override
  void initState() {
    super.initState();
    // Initialize the Firestore stream
    userNotifications = FirebaseFirestore.instance
        .collection('users')
        .doc(consumerId)
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Widget _buildNotifications(String content) {
    final alreadyRead = _read.contains(content);
    return Card(
        child: ListTile(
            title: new Text(
              content,
              // TODO: The real content can be accessed from database
            ),
            trailing: new Icon(
                alreadyRead ? Icons.remove_red_eye : Icons
                    .assignment_turned_in_rounded
            ),
            onTap: () {
              setState(() {
                if (!alreadyRead) {
                  _read.add(content);
                }
              }
              );
            }
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(75),
          bottomLeft: Radius.circular(75),
        ),
        color: Colors.grey[100],
      ),
      width: 300,
      child: StreamBuilder<QuerySnapshot>(
        stream: userNotifications,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading...");
          }

          final notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length + 2, // +2 for header and footer
            itemBuilder: (context, index) {
              if (index == 0) {
                return DrawerHeader(
                  child: Center(
                    child: Text('Notifications',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500)),
                  ),
                );
              } else if (index == notifications.length + 1) {
                return Container(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    "That's all your notifications from the last 30 days.",
                    softWrap: true,
                  ),
                );
              } else {
                final notification = notifications[index - 1];
                final content = notification.get('message');
                return _buildNotifications(content);
              }
            },
          );
        },
      ),
    );
  }
}

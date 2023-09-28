import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationPanel extends StatefulWidget {
  const NotificationPanel({Key? key}) : super(key: key);

  @override
  _NotificationPanelState createState() => _NotificationPanelState();
}

class _NotificationPanelState extends State<NotificationPanel> {
  final _biggerFont = const TextStyle(fontSize: 16.0);
  final consumerId = FirebaseAuth.instance.currentUser!.uid;

  late Stream<QuerySnapshot> userNotifications;
  bool _wantEmailNotification = false;

  @override
  void initState() {
    super.initState();
    userNotifications = FirebaseFirestore.instance
        .collection('users')
        .doc(consumerId)
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .snapshots();

    // Fetch the 'NeedEmailInformed' field
    FirebaseFirestore.instance
        .collection('users')
        .doc(consumerId)
        .get()
        .then((doc) {
      if (doc.exists && doc.data()!.containsKey('NeedEmailInformed')) {
        setState(() {
          _wantEmailNotification = doc.data()!['NeedEmailInformed'];
        });
      }
    });
  }

  Widget _buildNotifications(String content, String docId, bool isRead) {
    return Card(
        child: ListTile(
            title: Text(
              content,
            ),
            trailing: Icon(isRead
                ? Icons.remove_red_eye
                : Icons.assignment_turned_in_rounded),
            onTap: () {
              setState(() {
                if (!isRead) {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(consumerId)
                      .collection('notifications')
                      .doc(docId)
                      .update({'read': true});
                }
              });
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
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
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading...");
          }

          final notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length +
                3, // +3 to account for header, checkbox, and footer
            itemBuilder: (context, index) {
              if (index == 0) {
                return const DrawerHeader(
                  child: Center(
                    child: Text('Notifications',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500)),
                  ),
                );
              } else if (index == notifications.length + 1) {
                return Container(
                  padding: const EdgeInsets.all(32.0),
                  child: const Text(
                    "That's all your notifications from the last 30 days.",
                    softWrap: true,
                  ),
                );
              } else if (index == notifications.length + 2) {
                return Padding(
                  padding: const EdgeInsets.only(left: 50.0),
                  child: CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text("Do you want email notifications?"),
                    value: _wantEmailNotification,
                    onChanged: (bool? value) {
                      setState(() {
                        _wantEmailNotification = value!;
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(consumerId)
                            .update(
                                {'NeedEmailInformed': _wantEmailNotification});
                      });
                    },
                  ),
                );
              } else {
                final notification = notifications[index - 1];
                final content = notification.get('message');
                final docId = notification.id;
                final isRead = notification.get('read');
                return _buildNotifications(content, docId, isRead);
              }
            },
          );
        },
      ),
    );
  }
}

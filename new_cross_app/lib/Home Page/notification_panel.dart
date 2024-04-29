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
  int testNum = -1;
  @override
  void initState() {
    super.initState();
    userNotifications = FirebaseFirestore.instance
        .collection('users')
        .doc(consumerId)
        .collection('notifications')
        .orderBy('read', descending: false)
        .orderBy('timestamp', descending: true)
        .snapshots();

    userNotifications.listen((snapshot) {
      testNum = snapshot.docs.length;
    });

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
          title: Text(content),
          leading: IconButton(
            // Adding the delete button
            icon: Icon(Icons.delete),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(consumerId)
                  .collection('notifications')
                  .doc(docId)
                  .delete();
            },
          ),
          trailing: Icon(isRead
              ? Icons.assignment_turned_in_rounded
              : Icons.remove_red_eye),
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
          }),
    );
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
      child: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: userNotifications,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading...");
                }

                final notifications = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap:
                      true, // This ensures that the ListView doesn't scroll separately
                  physics:
                      NeverScrollableScrollPhysics(), // This ensures that the ListView doesn't interfere with the outer SingleChildScrollView
                  itemCount: notifications.length +
                      2, // +2 to account for header and footer
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const DrawerHeader(
                        child: Center(
                          child: Text('NotificationsLOL',
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
                    } else {
                      final notification = notifications[index - 1];
                      final content = notification.get('message');
                      final docId = notification.id;
                      final isRead = notification.get('read');
                      // print(' Notifications Button: $testNum');
                      return _buildNotifications(content, docId, isRead);
                    }
                  },
                );
              },
            ),
            Padding(
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
                        .update({'NeedEmailInformed': _wantEmailNotification});
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

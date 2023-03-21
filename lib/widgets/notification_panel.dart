import 'package:flutter/material.dart';


class NotificationPanel extends StatefulWidget {
  const NotificationPanel({Key? key}) : super(key: key);

  @override
  _NotificationPanelState createState() => _NotificationPanelState();
}

class _NotificationPanelState extends State<NotificationPanel> {
  final _read = new Set<String>();
  final _biggerFont = const TextStyle(fontSize: 16.0);

  Widget _buildNotifications(String content) {
    final alreadyRead = _read.contains(content);
    return  Card(
      child:ListTile(
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
    return new Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.only(
          topLeft: Radius.circular(75),
          bottomLeft: Radius.circular(75),
        ),color:Colors.grey[100],),
        width: 300,
        child: ListView(
          children: [
            new DrawerHeader(
              child: Center(
                child: Text('Notifications',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            _buildNotifications('Customer ABC has given a quote'),
            _buildNotifications('Customer XYZ has given a feedback'),
            new Container(
                padding: const EdgeInsets.all(32.0),
                child: new Text(
                  "That's all your notifications from the last 30 days.",
                  softWrap: true,
                )
            )
          ],
        )
    );
  }
}

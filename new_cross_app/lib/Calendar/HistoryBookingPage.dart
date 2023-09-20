import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'Consumer/Booking.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booking History',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BookingHistoryPage(userId: '',),
    );
  }
}

class BookingHistoryPage extends StatefulWidget {
  String userId;
  BookingHistoryPage({Key? key, required this.userId})
      : super(key: key);
  @override
  _BookingHistoryPageState createState() => _BookingHistoryPageState(userId);
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  String userId;
  _BookingHistoryPageState(this.userId);
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Filters
  String selectedYear = "2023";
  String selectedMonth = "September";
  String userTypeFilter = "Consumer"; // Change as needed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking History'),
      ),
      body: Column(
        children: <Widget>[
          // Filters
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              DropdownButton<String>(
                value: selectedYear,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedYear = newValue!;
                  });
                },
                items: <String>['2023', '2022', '2021', '2020']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              DropdownButton<String>(
                value: selectedMonth,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedMonth = newValue!;
                  });
                },
                items: <String>[
                  'January',
                  'February',
                  'March',
                  'April',
                  'May',
                  'June',
                  'July',
                  'August',
                  'September',
                  'October',
                  'November',
                  'December'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              DropdownButton<String>(
                value: userTypeFilter,
                onChanged: (String? newValue) {
                  setState(() {
                    userTypeFilter = newValue!;
                  });
                },
                items: <String>['Consumer', 'Provider']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          // Booking List
          Expanded(
            child: StreamBuilder(
              stream: firestore.collection('bookings').where('consumerId',isEqualTo: userId).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                List<Widget> filteredBookings = [];
                List<Booking>? bookings = snapshot.data?.docs
                    .map((e) => Booking(
                  eventName: e['eventName'] ?? '',
                  from: DateFormat('yyyy-MM-dd HH:mm:ss.sss').parse(e['from']),
                  to: DateFormat('yyyy-MM-dd HH:mm:ss.sss').parse(e['to']),
                  status: e['status'],
                  consumerName: e['consumerName'] ?? '',
                  tradieName: e['tradieName'] ?? '',
                  description: e['description'] ?? '',
                  key: e['key'],
                  consumerId: e['consumerId'] ?? '',
                  tradieId: e['tradieId'] ?? '',
                  quote: e['quote'] ?? '',
                  rating: e['rating']?? '',
                  comment: e['comment']?? '',
                ))
                    .toList();
                // Apply filters
                for (var booking in bookings!) {
                  if (booking.from.year == selectedYear &&
                      booking.from.month == selectedMonth &&
                      booking.consumerId == userTypeFilter) {
                    filteredBookings.add(
                      ListTile(
                        title: Text(booking.eventName),
                        subtitle: Text(booking.from.toString()),
                      ),
                    );
                  }
                }

                return ListView(
                  children: filteredBookings,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

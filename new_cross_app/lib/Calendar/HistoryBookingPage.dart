import 'package:flutter/material.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

//import '../firebase_options.dart';
import 'Consumer/Booking.dart';


class BookingHistoryPage extends StatefulWidget {
  String userId;
  BookingHistoryPage({Key? key, required this.userId}) : super(key: key);
  @override
  _BookingHistoryPageState createState() => _BookingHistoryPageState(userId);
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  // Filters
  String selectedYear = "2023";
  String selectedMonth = "September";
  String userTypeFilter = "Consumer"; // Change as needed
  late Stream<QuerySnapshot> _usersStream;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String userId;

  _BookingHistoryPageState(this.userId) {
    _usersStream = firestore
        .collection('bookings')
        .where(Filter.or(Filter('consumerId', isEqualTo: userId),
        Filter('tradieId', isEqualTo: userId)))
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text('Booking History'),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              backgroundColor: Colors.green,
            ),
            body: SafeArea(
              child: Column(
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
                        items: <String>['2024', '2023', '2022', '2021', '2020']
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
                        items: <String>['Consumer', 'Tradie']
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
                      stream: _usersStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          print(snapshot.error);
                          return const Text('Something went wrong');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text("Loading");
                        }
                        if (snapshot.data!.docs.length == 0) {
                          print('not data');
                        }
                        List<Widget> filteredBookings = [];
                        List<Booking>? bookings = snapshot.data?.docs
                            .map((e) =>
                            Booking(
                              eventName: e['eventName'] ?? '',
                              from: DateFormat('yyyy-MM-dd HH:mm:ss.sss')
                                  .parse(e['from']),
                              to: DateFormat('yyyy-MM-dd HH:mm:ss.sss')
                                  .parse(e['to']),
                              status: e['status'],
                              consumerName: e['consumerName'] ?? '',
                              tradieName: e['tradieName'] ?? '',
                              description: e['description'] ?? '',
                              key: e['key'],
                              consumerId: e['consumerId'] ?? '',
                              tradieId: e['tradieId'] ?? '',
                              quote: e['quote'] ?? '',
                              rating: e['rating'] ?? '',
                              comment: e['comment'] ?? '',
                            ))
                            .toList();
                        // Apply filters

                        for (var booking in bookings!) {
                          if (booking.from.year.toString() == selectedYear &&
                              booking.from.month.toInt() ==
                                  monthtonum(selectedMonth)) {
                            if (userTypeFilter == 'Consumer' &&
                                booking.consumerId == userId) {
                              filteredBookings.add(getCard(
                                  context, 'consumer', booking));
                            } else if (userTypeFilter == 'Tradie' &&
                                booking.tradieId == userId) {
                              filteredBookings.add(getCard(
                                  context, 'tradie', booking));
                            }
                          } else {
                            print(booking.from.year);
                            print(booking.from.month);
                            print(selectedYear);
                            print(selectedMonth);
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
            )));
  }

  GestureDetector getCard(BuildContext context, String s, Booking booking) {
    if (s == 'consumer') {
      return GestureDetector(
        onTap: () {
          showGeneralDialog(
            context: context,
            barrierDismissible: true,
            barrierLabel: MaterialLocalizations
                .of(context)
                .modalBarrierDismissLabel,
            transitionDuration: const Duration(milliseconds: 200),
            pageBuilder: (BuildContext buildContext,
                Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return Center(
                child: Material( // Add Material widget here
                  child: Container(
                    width: 350.0,
                    height: 200.0,
                    color: Colors.white,
                    alignment: Alignment.centerLeft,
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          title: Text(booking.eventName),
                          titleTextStyle: TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                        Divider(
                          height: 1,
                        ),
                        SelectableText('Tradie Name: ' + booking.tradieName),
                        SizedBox(height: 8.0),
                        //SelectableText('From: ' + booking.from.toString()),
                        SelectableText('From: ' + DateFormat('yyyy-MM-dd HH:mm').format(booking.from)),
                        SizedBox(height: 8.0),
                        //SelectableText('To: ' + booking.to.toString()),
                        SelectableText('To: ' + DateFormat('yyyy-MM-dd HH:mm').format(booking.to)),
                        SizedBox(height: 8.0),
                        SelectableText('Quote: ' + booking.quote.toString()),
                        SizedBox(height: 8.0),
                        SelectableText('Rating: ' + booking.rating.toString()),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: Material( // Add Material widget here
          child: Card(
            color: Colors.lightGreen[300],
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: Colors.black, width: 1.0),
            ),
            child: ListTile(
              title: Text(booking.eventName),
              titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(booking.tradieName),
                  SizedBox(height: 10),
                  //Text(booking.from.toString()),
                  Text(DateFormat('yyyy-MM-dd HH:mm').format(booking.from)),
                  SizedBox(height: 10),
                  Text(DateFormat('yyyy-MM-dd HH:mm').format(booking.to)),
                  //Text(booking.to.toString()),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          showGeneralDialog(
            context: context,
            barrierDismissible: true,
            barrierLabel: MaterialLocalizations
                .of(context)
                .modalBarrierDismissLabel,
            transitionDuration: const Duration(milliseconds: 200),
            pageBuilder: (BuildContext buildContext,
                Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return Center(
                child: Material( // Add Material widget here
                  child: Container(
                    width: 350.0,
                    height: 200.0,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ListTile(
                          title: Text(booking.eventName),
                          titleTextStyle: TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                        Divider(
                          height: 1,
                        ),
                        SelectableText('Consumer Name: ' + booking
                            .consumerName),
                        SizedBox(height: 8.0),
                        SelectableText('From: ' + booking.from.toString()),
                        SizedBox(height: 8.0),
                        SelectableText('To: ' + booking.to.toString()),
                        SizedBox(height: 8.0),
                        SelectableText('Quote: ' + booking.quote.toString()),
                        SizedBox(height: 8.0),
                        SelectableText('Rating: ' + booking.rating.toString()),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: Material( // Add Material widget here
          child: Card(
            color: Colors.lightGreen[300],
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: Colors.black, width: 1.0),
            ),
            child: ListTile(
              title: Text(booking.eventName),
              titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(booking.consumerName),
                  SizedBox(height: 10),
                  Text(booking.from.toString()),
                  SizedBox(height: 10),
                  Text(booking.to.toString()),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  num monthtonum(String month) {
    List<String> months = [
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
    ];
    return months.indexOf(month) + 1;
  }
}

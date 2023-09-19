import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../Calendar/Consumer/Booking.dart';
import '../Routes/route_const.dart';
import 'card_form_screen.dart';

import 'package:flutter/material.dart';

class StripeApp extends StatelessWidget {
  String bookingId;
  String userId;
  StripeApp({Key? key, required this.bookingId, required this.userId})
      : super(key: key);
  Booking booking = Booking(from: DateTime.now(), to: DateTime.now());

  // Function to fetch booking details from Firestore
  Future<Booking> getBooking() async {
    var data = await FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingId)
        .get();

    // Parse Firestore data into a Booking object
    booking = Booking(
      eventName: data['eventName'] ?? '',
      from: DateFormat('yyyy-MM-dd HH:mm:ss.sss').parse(data['from']),
      to: DateFormat('yyyy-MM-dd HH:mm:ss.sss').parse(data['to']),
      status: data['status'],
      consumerName: data['consumerName'] ?? '',
      tradieName: data['tradieName'] ?? '',
      description: data['description'] ?? '',
      key: data['key'],
      quote: data['quote'] ?? '',
      consumerId: data['consumerId'] ?? '',
      tradieId: data['tradieId'] ?? '',
    );

    return booking;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Check Out"),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Request Information", style: TextStyle(fontSize: 30.0)),
            SizedBox(
              child: Container(
                color: Colors.lightGreen,
                height: 180.0,
                child: Row(children: [
                  Image(
                    image: NetworkImage(
                        'https://www.tradieshirts.com.au/rshared/ssc/i/riq/5717778/1600/1600/t/0/0/Tradie%20Shirts%20Printed%20Sydney1.jpg?1621509120'),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("Work:"),
                            Text(booking.eventName),
                          ],
                        ),
                        Row(
                          children: [
                            Text("From:"),
                            Text(booking.from.toString()),
                          ],
                        ),
                        Row(
                          children: [
                            Text("To:"),
                            Text(booking.to.toString()),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Quote:"),
                            Text('40'),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Tradie Name:"),
                            Text(booking.tradieName),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Status:"),
                            Text(booking.status),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
            ElevatedButton(
                child: Text("Make a Payment"),
                onPressed: () {
                  // Update the status to 'Rating' in Firestore
                  FirebaseFirestore.instance
                      .collection('bookings')
                      .doc(bookingId)
                      .update({'status': 'Rating'});

                  // Navigate to the home page with user ID
                  GoRouter.of(context)
                      .pushNamed(RouterName.homePage, params: {'userId': userId});
                })
          ],
        ),
      ),
    );
  }
}

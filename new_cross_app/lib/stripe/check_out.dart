import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../Routes/route_const.dart';
import 'card_form_screen.dart';

import 'package:flutter/material.dart';

class StripeApp extends StatelessWidget {
  String bookingId;
  StripeApp({Key? key, required this.bookingId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('bookingId' + bookingId);
    Booking booking = Booking(from: DateTime.now(), to: DateTime.now());
    FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingId)
        .get()
        .then((value) {
      var data = value.data()!;
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
    });

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Check Out"),
      ),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("Request Information", style: TextStyle(fontSize: 30.0)),
          Container(
              color: Colors.lightGreen,
              height: 200.0,
              child: Row(children: [
                Image(
                    image: NetworkImage(
                        'https://www.tradieshirts.com.au/rshared/ssc/i/riq/5717778/1600/1600/t/0/0/Tradie%20Shirts%20Printed%20Sydney1.jpg?1621509120')),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Type of work:"),
                    Text("The number of worker:"),
                    Text("From:"),
                    Text("To:"),
                    Text("Money:"),
                    Text("Name:"),
                    Text("Status:")
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(booking.eventName),
                    Text(booking.from.toString()),
                    Text(booking.to.toString()),
                    Text(booking.quote.toString()),
                    Text(booking.tradieName),
                    Text(booking.status)
                  ],
                ),
              ])),
          ElevatedButton(
              child: Text("make a payment"),
              onPressed: () {
               GoRouter.of(context).pushNamed(RouterName.Pay,params: {
                 'bookingId':bookingId
               });
              })
        ],
      )),
    );
  }
}

class Booking {
  Booking(
      {required this.from,
      required this.to,
      this.status = 'Pending',
      this.eventName = '',
      this.tradieName = '',
      this.consumerName = '',
      this.description = '',
      this.key = '',
      this.consumerId = '',
      this.tradieId = '',
      this.quote = 0});

  final String tradieName;
  final String consumerName;
  final String eventName;
  DateTime from;
  DateTime to;
  String status;
  String description;
  String key;
  num quote;
  String consumerId;
  String tradieId;
}
/*
List<Booking> getBookingDetails(String tradie) {

  List<Booking> bookings = <Booking>[];
  DateTime today = DateTime.now();
  if (tradie == 'Jack') {
    Booking b1 = Booking(
        from: DateTime(today.year, today.month, today.day, 10, 0, 0),
        to: DateTime(today.year, today.month, today.day, 11, 0, 0),
        tradieName: 'Jack',
        consumerName: 'Black',
        eventName: 'Painting',
        status: 'Pending');
    Booking b2 = Booking(
        from: DateTime(today.year, today.month, today.day, 12, 0, 0),
        to: DateTime(today.year, today.month, today.day, 14, 0, 0),
        tradieName: 'Jack',
        consumerName: 'Lance',
        eventName: 'Painting',
        status: 'Pending');
    bookings.add(b1);
    bookings.add(b2);
  } else {
    Booking b1 = Booking(
        from: DateTime(today.year, today.month, today.day, 10, 0, 0),
        to: DateTime(today.year, today.month, today.day, 11, 0, 0),
        tradieName: 'Tom',
        consumerName: 'Black',
        eventName: 'Painting',
        status: 'Pending');
    Booking b2 = Booking(
        from: DateTime(today.year, today.month, today.day, 15, 0, 0),
        to: DateTime(today.year, today.month, today.day, 17, 0, 0),
        tradieName: 'Tom',
        consumerName: 'Lance',
        eventName: 'Painting',
        status: 'Pending');
    bookings.add(b1);
    bookings.add(b2);
  }
  return bookings;
}
*/

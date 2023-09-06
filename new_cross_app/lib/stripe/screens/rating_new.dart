import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../Calendar/Consumer/Booking.dart';
import '../../Routes/route_const.dart';
import '../stripe_web/stripe_payment_web.dart';

class Rating extends StatefulWidget {
  String bookingId;
  Rating({required this.bookingId});
  @override
  _RatingState createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  double _serviceRating = 0;
  TextEditingController _textEditingController = TextEditingController();
  late Future<Booking> bookingFuture;

  @override
  void initState() {
    super.initState();
    bookingFuture = getBooking(widget.bookingId);
  }

  Future<Booking> getBooking(bookingId) async {
    var data = await FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingId)
        .get();
    Booking booking = Booking(
      from: DateFormat('yyyy-MM-dd HH:mm:ss.sss').parse(data['from']),
      to: DateFormat('yyyy-MM-dd HH:mm:ss.sss').parse(data['to']),
      key: data['key'] ?? '',
      tradieId: data['tradieId'] ?? '',
      consumerId: data['consumerId'] ?? '',
      comment: data['comment'] ?? '',
      rating: data['rating'] ?? 0,
    );
    return booking;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rating Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Rate Your Service'),
        ),
        body: FutureBuilder<Booking>(
          future: bookingFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData) {
              return Text('No data available');
            } else {
              Booking booking = snapshot.data!;
              return Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How was your experience with the service?',
                      style: TextStyle(fontSize: 30.0),
                    ),
                    SizedBox(height: 10.0),
                    /*Text(
                      booking.key,
                      style: TextStyle(fontSize: 15.0),
                    ),*/
                    Container(height: 5.0),
                    Container(
                        child: Row(children: [
                      Icon(Icons.star, size: 15.0, color: Colors.amber),
                      Text(
                        booking.rating.toString(),
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ])),
                    Container(height: 15.0),
                    Divider(height: 0.0, indent: 10.0, color: Colors.black),
                    Container(height: 15.0),
                    Text(
                      'Rate your experience',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    // TODO Rate Change
                    SizedBox(height: 10.0),
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          _serviceRating =
                              rating; // Update the service rating value
                        });
                      },
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Leave a comment',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        hintText: 'Write a review',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: null,
                    ),
                    Container(height: 15.0),
                    Divider(height: 0.0, indent: 10.0, color: Colors.black),
                    Container(height: 15.0),
                    ElevatedButton(
                      onPressed: () {
                        String comment = _textEditingController.text.trim();
                        double serviceRating = _serviceRating;
                        FirebaseFirestore.instance
                            .collection('bookings')
                            .doc(booking.key)
                            .update({
                          'comment': comment,
                          'rating': serviceRating,
                          // Update the service rating field
                        });
                        // Todo: Get accountId & quote from firebase

                      },
                      child: ElevatedButton(
                          child: Text('Submit'),
                          onPressed: (){
                            confirmWork({'accountId': 'acct_1NkozJC1m29tlvhX', 'amount': '90'});
                            GoRouter.of(context).pushReplacementNamed(
                                RouterName.CalendarConsumer,
                                params: {
                                  'userId': booking.consumerId,
                                });

                          },
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

Future<void> confirmWork(Map<String, String> body) async {
  final res = await http.post(
    Uri.parse('https://us-central1-jemma-b0fcd.cloudfunctions.net/Transfer'),
    body: body,
  );
  print(res.body);
  if (res.statusCode == 200) {
    print(res.body);
    print('success');
  } else if (res.statusCode == 400) {
    print('failed: ${res.body}');
  }
}

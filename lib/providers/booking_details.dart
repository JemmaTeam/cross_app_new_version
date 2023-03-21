

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:jemma/models/booking.dart';
import 'package:jemma/models/quote.dart';
import 'package:jemma/models/tradie.dart';
import 'package:jemma/screens/util.dart';
import 'package:jemma/utils/notification.dart';

import '../main.dart';
import '../repository.dart';


/// Observable which handles logic of the booking screen.
class BookingDetailsNotifier extends ChangeNotifier{

  bool isLoading = true;
  Booking? booking;
  bool isLoaded = false;
  bool isError = false;

  void setBooking(Booking booking) {
    if(!isLoaded) {
      this.booking = booking;
      _fetchBookingDetail();
    }
  }

  /// Returns all bookings associated with user.
  _fetchBookingDetail() async {
    if(booking != null && !isLoaded) {
      var bookingId = booking!.id.toString();
      final url = Repository().getDetailUrl(screen: DetailScreen.bookings, id: bookingId);
      logger.d(url);

      final response = await Repository().getResponse(url);

        if(response.statusCode == 200 && response.body.isNotEmpty) {
          booking = Booking.fromJson(jsonDecode(response.body));
          isLoading = false;
          isLoaded = true;
          logger.d(booking);
          notifyListeners();
        }

      else{
          //TODO show notifications
          isError = true;
          notifyListeners();
      }


    }
  }



}
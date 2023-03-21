


import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:jemma/screens/bookings.dart';

import '../enums/booking_status.dart';


/// Observable which handles logic of the dashboard screen which can be seen only by the tradie.
/// TODO
class DashboardNotifier extends ChangeNotifier {

  /// Retrieves a list of money earned for the past few weeks.
  ///
  /// TODO: Decide on how many weeks.
  List<Double> getMoneyEarnedWeekly(){
    return [];
  }

  /// Obtain Bookings related numbers.
  Map<BookingStatus,int>  getNumberOfBookings(){
    return {};
  }

  /// Obtains recent jobs for the tradie.
  List<Bookings> getRecentBookings(){
    return [];
  }

}
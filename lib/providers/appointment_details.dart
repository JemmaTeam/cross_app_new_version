
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:jemma/models/appointment_details.dart';
import 'package:jemma/models/booking.dart';


import 'package:jemma/screens/calendar.dart';
import 'package:jemma/screens/util.dart';
import 'package:jemma/utils/notification.dart';

import '../main.dart';
import '../repository.dart';


/// Observable which handles logic of the booking screen.
class Appointment_detailsNotifier extends ChangeNotifier{

  bool isLoading = true;
  Appointment_details? appointment_details;
  bool isLoaded = false;
  bool isError = false;

  void setAppointment_details(Appointment_details appointmentDetails) {
    if(!isLoaded) {
      this.appointment_details = appointment_details;
      _fetchAppointment_details();
    }
  }

  /// Returns all calendar associated with user.
  _fetchAppointment_details() async {
    if(appointment_details != null && !isLoaded) {
      var calendarId = appointment_details!.id.toString();
      final url = Repository().getDetailUrl(screen: DetailScreen.appointment_details, id: calendarId);
      logger.d(url);

      final response = await Repository().getResponse(url);

      if(response.statusCode == 200 && response.body.isNotEmpty) {
        appointment_details = Appointment_details.fromJson(jsonDecode(response.body));
        isLoading = false;
        isLoaded = true;
        logger.d(appointment_details);
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
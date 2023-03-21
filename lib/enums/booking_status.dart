import 'package:recase/recase.dart';

import '../main.dart';

/// Status of a [Booking].
enum BookingStatus{
  scheduled,
  pendingReview,
  cancelled,
  completed
}

BookingStatus? parseBookingStatusString(String status){
  for (var bookingStatus in BookingStatus.values){
      if(bookingStatus.toSimpleString().constantCase == status.constantCase){
        return bookingStatus;
      }
  }
  return null;
}

extension BookingUtil on BookingStatus{
  String toSimpleString() => toString().split('.').last.constantCase;
  String toStyledString() => toSimpleString().sentenceCase;
}
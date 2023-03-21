import 'package:jemma/enums/booking_status.dart';
import 'package:jemma/models/quote.dart';
import 'package:jemma/models/tradie.dart';

import 'customer.dart';


/// An essential event which Jemma revolves around.
/// Tradies call it Job and Customers call it Order.
///
///
/// Each booking usually has a [quote]; There could be bookings without [quote], but in those cases the backend would
/// internally use quote but will not show this to the users.
class Booking{
  int id;
  Tradie? tradie;
  Customer? customer;
  Quote? quote;
  BookingStatus? status;
  DateTime? timeStamp;

  Booking(this.id,[
    this.tradie,
    this.customer,
    this.quote,
    this.status,
    this.timeStamp]);

  Booking._fromJson(Map<String, dynamic> json) :
        id =json["id"],
        tradie=json["tradie"] != null ? Tradie.fromJson(json["tradie"]): null,
        customer=json["customer"] !=null ? Customer.fromJson(json["customer"]) : null,
        quote=json["quote"] != null ? Quote.fromJson(json["quote"]): null,
        status=json["status"] != null ? parseBookingStatusString(json["status"]) ?? BookingStatus.scheduled :null,
        timeStamp=json["time_stamp"] != null ? DateTime.parse(json["time_stamp"]) : null;

  Map<String, dynamic> toJson() => {
    "id": id,
    "tradie": tradie?.toJson(),
    "customer": customer?.toJson(),
    "quote": quote?.toJson(),
    "status": status,
    "date": timeStamp.toString()
  };

 factory Booking.fromJson(json){
    if (json is int) {
      return Booking(json);
    } else{
      return Booking._fromJson(json);
    }
  }
  
  @override
  String toString() {
    return 'Booking{id: $id, \n tradie: $tradie, customer: $customer, quote: $quote, status: $status, timeStamp: $timeStamp}\n';
  }
}
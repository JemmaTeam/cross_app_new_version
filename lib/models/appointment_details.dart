import 'dart:ui';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:jemma/enums/booking_status.dart';
import 'package:jemma/models/quote.dart';
import 'package:jemma/models/tradie.dart';

import 'customer.dart';
// class MeetingDataSource extends CalendarDataSource {
//   MeetingDataSource(List<Appointment> source) {
//     appointments = source;
//   }
//
//   @override
//   DateTime getStartTime(int index) {
//     return appointments![index].from;
//   }
//
//   @override
//   DateTime getEndTime(int index) {
//     return appointments![index].to;
//   }
//
//   @override
//   Color getColor(int index) {
//     return appointments![index].background;
//   }
//
//   @override
//   String getEndTimeZone(int index) {
//     return appointments![index].toZone;
//   }
//
//   @override
//   List<DateTime> getRecurrenceExceptionDates(int index) {
//     return appointments![index].exceptionDates;
//   }
//
//   @override
//   String getRecurrenceRule(int index) {
//     return appointments![index].recurrenceRule;
//   }
//
//   @override
//   String getStartTimeZone(int index) {
//     return appointments![index].fromZone;
//   }
//
//   @override
//   String getSubject(int index) {
//     return appointments![index].title;
//   }
//
//   @override
//   bool isAllDay(int index) {
//     return appointments![index].isAllDay;
//   }
// }
class Appointment_details {
  DateTime? from;
  DateTime? to;
  String title;
  bool isAllDay;
  Color? background;
  String fromZone;
  String toZone;
  String recurrenceRule;
  List<DateTime>? exceptionDates;

  Appointment_details(int json,
      [ this.from,
        this.to,
        this.title = '',
        this.isAllDay = false,
        this.background,
        this.fromZone = '',
        this.toZone = '',
        this.exceptionDates,
        this.recurrenceRule = '']);

  Appointment_details._fromJson(Map<String, dynamic> json)
      :
        from =json["from"] != null ? DateTime.parse(json["from"]) : null,
        to =json["to"] != null ? DateTime.parse(json["to"]) : null,
        title=json["title"],
        isAllDay=json["isAllDay"],
        background=json["background"],
        fromZone=json["fromZone"],
        toZone=json["toZone"],
        exceptionDates=json["exceptionDates"],
        recurrenceRule=json["recurrenceRule"];

  get id => null;

  Map<String, dynamic> toJson() =>
      {
        "from": from,
        "to": to,
        "title": title,
        "isAllDay": isAllDay,
        "background": background,
        "fromZone": fromZone,
        "toZone": toZone,
        "exceptionDates": exceptionDates,
        "recurrenceRule": recurrenceRule,
      };

  factory Appointment_details.fromJson(json){
    if (json is int) {
      return Appointment_details(json);
    } else {
      return Appointment_details._fromJson(json);
    }
  }

  @override
  String toString() {
    return 'Calendar{from: $from, \n to: $to, title: $title, isAllDay: $isAllDay, fromZone: $fromZone, toZone: $toZone, exceptionDates: $exceptionDates, recurrenceRule: $recurrenceRule}\n';
  }
}
import 'package:flutter/material.dart';
import 'package:jemma/enums/user_type.dart';
import 'package:jemma/models/appointment_details.dart';
import 'package:jemma/models/user.dart';
import 'package:jemma/providers/appointment_details.dart';
import 'package:jemma/widgets/nav_bar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:jemma/repository.dart';
import 'package:flutter/widgets.dart';

import '../main.dart';


class Calendar extends StatelessWidget {




  @override
  Widget build(BuildContext context) {
    // TODO: Prolly look into better ways of data transmission
    final arguments = ModalRoute.of(context)?.settings.arguments as Map?;
    final Appointment_details? initialAppointment_details = arguments?["appointment_details"];
    var appointment_detailsNotifier;
    appointment_detailsNotifier?.setBooking(initialAppointment_details);

    DataSource _getCalendarDataSource() {
      final List<Appointment> appointments = <Appointment>[];


      if (appointment_detailsNotifier == null){
        appointments.add(
            Appointment(
            startTime: DateTime.now(),
            endTime: DateTime.now().add(Duration(hours: 1)),
            subject: 'Meeting',
            color: Colors.green,
          ));
          appointments.add(Appointment(
            startTime: DateTime.now(),
            endTime: DateTime.now().add(Duration(hours: 1)),
            subject: 'Restrospective',
            color: Colors.red,
          ));
          appointments.add(Appointment(
            startTime: DateTime.now(),
            endTime: DateTime.now().add(Duration(hours: 1)),
            subject: 'Planning',
            color: Colors.grey,
          ));
          appointments.add(Appointment(
            startTime: DateTime.now().add(Duration(days: -5)),
            endTime: DateTime.now().add(Duration(days: -5)),
            subject: 'Planning',
            color: Colors.grey,
          ));
          appointments.add(Appointment(
            startTime: DateTime.now().add(Duration(days: -9)),
            endTime: DateTime.now().add(Duration(days: -9)),
            subject: 'Consulting',
            color: Colors.grey,
          ));
          appointments.add(Appointment(
            startTime: DateTime.now().add(Duration(days: -9, hours: 1)),
            endTime: DateTime.now().add(Duration(days: -9, hours: 1)),
            subject: 'Holiday support',
            color: Colors.grey,
          ));
          appointments.add(Appointment(
            startTime: DateTime.now().add(Duration(days: -15)),
            endTime: DateTime.now().add(Duration(days: -15)),
            subject: 'Retrospective',
            color: Colors.grey,
          ));
          appointments.add(Appointment(
            startTime: DateTime.now().add(Duration(days: 5)),
            endTime: DateTime.now().add(Duration(days: 5)),
            subject: 'Sprint Plan',
            color: Colors.grey,
          ));
          appointments.add(Appointment(
            startTime: DateTime.now().add(Duration(days: 9)),
            endTime: DateTime.now().add(Duration(days: 9)),
            subject: 'Weekly Report',
            color: Colors.grey,
          ));
          appointments.add(Appointment(
            startTime: DateTime.now().add(Duration(days: 3)),
            endTime: DateTime.now().add(Duration(days: 3)),
            subject: 'Meeting',
            color: Colors.green,
          ));
      }else{
      for(var i = 0; i < appointment_detailsNotifier.appointment_details?.length; i++){
        appointments.add(Appointment(
          startTime: appointment_detailsNotifier.appointment_details?.from,
          endTime: appointment_detailsNotifier.appointment_details?.to,
          subject: appointment_detailsNotifier.appointment_details?.title,
          color: appointment_detailsNotifier.appointment_details?.background,
        ));
      }}


      return DataSource(appointments);
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text("Calendar"),
        ),

        body: Container(
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.indeterminate_check_box, color: Colors.blue[500]),
                      const Text('Fully booked'),
                      Icon(Icons.add_box, color: Colors.grey[500]),
                      const Text('Pending'),
                      Icon(Icons.check_box, color: Colors.green[500]),
                      const Text('Available'),
                      Icon(Icons.indeterminate_check_box_outlined, color: Colors.red[500]),
                      const Text('Unavailable'),
                    ],
                  ),
                ),
                Expanded(
                  child: SfCalendar(
                    view: CalendarView.month,
                    monthCellBuilder: monthCellBuilder,
                    initialDisplayDate: DateTime.now(),
                    dataSource:_getCalendarDataSource(),
                    monthViewSettings: const MonthViewSettings(
                        appointmentDisplayMode: MonthAppointmentDisplayMode.none,
                        showAgenda: true,
                    ),

                  ),
                ),
              ],
            ),
        ),

        drawer: NavBar());
  }


}


Widget monthCellBuilder(BuildContext context, MonthCellDetails details) {
  var length = details.appointments.length;
  if (details.appointments.isNotEmpty) {
    return Container(
      child: Column(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                details.date.day.toString(),
                textAlign: TextAlign.center,
              ),
              const Divider(color: Colors.transparent,),
              Text(
                '$length',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.green),
              ),
            ],
          )
        ],
      ),
    );

  }
  return Container(
    color: Colors.grey,
    child: Column(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              details.date.day.toString(),
              textAlign: TextAlign.center,
            ),
            const Divider(color: Colors.transparent,),
            const Icon(
              Icons.event_busy,
              color: Colors.red,
              size: 20,
            ),
          ],
        )
      ],
    ),
  );

}
class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source) {
    appointments = source;
  }
}
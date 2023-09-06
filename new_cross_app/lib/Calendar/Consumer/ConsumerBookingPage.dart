library booking_calendar;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_cross_app/Calendar/Consumer/ConsumerProfilePage.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'dart:js' as js;
import '../../Routes/route_const.dart';
import '../../stripe/check_out.dart';
import 'Booking.dart';
part 'BookingEditor.dart';

class ConsumerBooking extends StatefulWidget {
  String tradie;
  String userId;

  ConsumerBooking({Key? key, required this.tradie,required this.userId})
      : super(key: key);

  @override
  ConsumerBookingState createState() => ConsumerBookingState(tradie,userId);
}

//Variables
List<Color> _colorCollection = <Color>[];
List<String> _colorNames = <String>[];
int _selectedStatusIndex = 0;
List<String> _statusNames = <String>[];
String _tradie = '';
String selectedKey='';
String _tradieName = '';
String _consumerName='';
List<Booking> ls=<Booking>[];
late DataSource _bookings=DataSource(ls);
Booking? _selectedAppointment;
String user_consumerId ='';
String user_consumerName='';
String user_tradieName='';
String user_tradieId='';
String _consumerId='';
String _tradieId='';
String user_subject='';
late num quote=0;
late DateTime _startDate;
late TimeOfDay _startTime;
late DateTime _endDate;
late TimeOfDay _endTime;
late num workStart;
late num workEnd;
late bool weekend;
bool _isAllDay = false;
String _subject = '';
String _notes = '';
String _comment = '';
num _rating = 0;
final db = FirebaseFirestore.instance;
final usersRef = db.collection('users');
final bookingRef = db.collection('bookings');
class ConsumerBookingState extends State<ConsumerBooking> {

  late Stream<QuerySnapshot> _usersStream;
  String tradie;
  String userId;
  ConsumerBookingState(this.tradie, this.userId) {
    user_tradieId=tradie;
    user_consumerId=userId;
    //monitor bookings
    bookingRef.where('tradieId', isEqualTo: user_tradieId).snapshots().listen(
          (event) => print("get query"+_tradieId),

      onError: (error) => print("Listen failed: $error"),
    );
    // setup Stream for realtime update
    _usersStream = bookingRef.where('tradieId', isEqualTo: user_tradieId).snapshots();
    getName(user_tradieId, user_consumerId);
  }
  // get tradie name, job title and consumer's name
  Future<void> getName(tradieId, consumerId)async {
    await usersRef.where('uid', isEqualTo: tradieId).get().then((value) => {
      user_tradieName=value.docs[0]['fullName'],
      user_subject = value.docs[0]['workTitle'],
      workStart=value.docs[0]['workStart'],
      workEnd=value.docs[0]['workEnd'],
    });
    await usersRef.where('uid', isEqualTo: consumerId).get().then((value) => user_consumerName=value.docs[0]['fullName']);

  }
  //TODO: get working time from firebase

  late List<Booking> appointments;
  CalendarController calendarController = CalendarController();
  @override
  void initState() {
    setUpBooking();
    appointments = <Booking>[];
    _bookings = DataSource(appointments);
    _selectedAppointment = null;
    _selectedStatusIndex = 0;
    _subject = '';
    _notes = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        // Get Bookings from firebase and stored into list
        List<Booking>? list = snapshot.data?.docs
            .map((e) => Booking(
          eventName: e['eventName'] ?? '',
          from: DateFormat('yyyy-MM-dd HH:mm:ss.sss').parse(e['from']),
          to: DateFormat('yyyy-MM-dd HH:mm:ss.sss').parse(e['to']),
          status: e['status'],
          consumerName: e['consumerName'] ?? '',
          tradieName: e['tradieName'] ?? '',
          description: e['description'] ?? '',
          key: e['key'],
          consumerId: e['consumerId'] ?? '',
          tradieId: e['tradieId'] ?? '',
          quote: e['quote'] ?? '',
          rating: e['rating']?? '',
          comment: e['comment']?? '',
        ))
            .toList();
        _bookings = DataSource(list!);

        return Scaffold(
            appBar: AppBar(
                leading: IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                      Icons.arrow_back
                  ),
                )
            ),
            resizeToAvoidBottomInset: true,
            body: getBookingCalendar(_bookings, onCalendarTapped));
      },
    );
  }

  SfCalendar getBookingCalendar(
      CalendarDataSource dataSource, CalendarTapCallback calendarTapCallback) {
    return SfCalendar(
        view: CalendarView.month,
        controller: calendarController,
        //Display Mode:
        allowedViews: const [CalendarView.week, CalendarView.month],
        dataSource: dataSource,
        onTap: calendarTapCallback,
        appointmentBuilder: (context, calendarAppointmentDetails) {
          final Booking booking = calendarAppointmentDetails.appointments.first;
          //Container for every meeting
          if (booking.consumerId != user_consumerId) {
            return Container(
              color: Colors.deepOrange.withOpacity(0.5),
              child: const Text('Unavaliable'),
            );
          } else {
            return Container(
              color: Colors.lightGreen.withOpacity(0.5),
              child: Text(booking.eventName),
            );
          }
        },
        initialDisplayDate: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 0, 0, 0),
        monthViewSettings: const MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
        //Minimum appointment duration set to be 60 mins
        timeSlotViewSettings: const TimeSlotViewSettings(
            minimumAppointmentDuration: Duration(minutes: 60)));
  }

  void onCalendarTapped(CalendarTapDetails calendarTapDetails) {
    print(calendarTapDetails.targetElement.name);
    if (calendarController.view == CalendarView.month) {
      if (calendarTapDetails.targetElement != CalendarElement.calendarCell &&
          calendarTapDetails.targetElement != CalendarElement.appointment) {
        return;
      } else if (calendarTapDetails.targetElement ==
          CalendarElement.calendarCell) {
        calendarController.view = CalendarView.day;
      }
    } else if (calendarController.view == CalendarView.day) {
      if (calendarTapDetails.targetElement != CalendarElement.calendarCell &&
          calendarTapDetails.targetElement != CalendarElement.appointment) {
        return;
      } else {
        setState(() {
          if (calendarTapDetails.appointments != null &&
              calendarTapDetails.appointments!.length == 1) {
            final Booking meetingDetails = calendarTapDetails.appointments![0];
            _selectedAppointment = meetingDetails;
            if (meetingDetails.consumerId == user_consumerId) {
              //set up variables
              _startDate = meetingDetails.from;
              _endDate = meetingDetails.to;
              _selectedStatusIndex =
                  _statusNames.indexOf(meetingDetails.status);
              _tradieName = meetingDetails.tradieName;
              _consumerName=meetingDetails.consumerName;
              _subject = meetingDetails.eventName;
              _notes = meetingDetails.description;
              selectedKey=meetingDetails.key;
              _consumerId=meetingDetails.consumerId;
              _tradieId=meetingDetails.tradieId;
              quote=meetingDetails.quote;
              _rating = meetingDetails.rating;
              _comment = meetingDetails.comment;
              // Goto Editor
              GoRouter.of(context).pushNamed(RouterName.BookingEditor);
            }
            //如果返回appointments 为null，则说明是新的meeting,根据点击的时间点设置信息，并且跳转到appointment editor
          } else {
            final DateTime date = calendarTapDetails.date!;
            _startDate = date;
            _endDate = date.add(const Duration(hours: 1));
            _startTime =
                TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
            _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
            _consumerId=user_consumerId;
            _tradieId=user_tradieId;
            _consumerName=user_consumerName;
            _tradieName=user_tradieName;
            _subject=user_subject;
            GoRouter.of(context).pushNamed(RouterName.BookingEditor);
          }
        });
      }
    }
  }
}

class DataSource extends CalendarDataSource {
  DataSource(List<Booking> source) {
    appointments = source;
  }

  @override
  String getSubject(int index) => appointments![index].eventName;

  //@override
  //String getStartTimeZone(int index) => appointments![index].startTimeZone;

  @override
  String getNotes(int index) => appointments![index].description;

  /*@override
  String getTradie(int index)=>appointments![index].toString();*/
  //@override
  //String getEndTimeZone(int index) => appointments![index].endTimeZone;

  /*@override
  Color getColor(int index) => appointments![index].status;*/

  @override
  DateTime getStartTime(int index) => appointments![index].from;

  @override
  DateTime getEndTime(int index) => appointments![index].to;
}



void setUpBooking() {
  _statusNames.add('Pending');
  _statusNames.add('Confirmed');
  _statusNames.add('Working');
  _statusNames.add('Rating');
  _statusNames.add('Complete');
  _statusNames.add('Unavailable');

  _colorCollection.add(const Color(0xFF0F8644));
  _colorCollection.add(const Color(0xFF8B1FA9));
  _colorCollection.add(const Color(0xFFD20100));
  _colorCollection.add(const Color(0xFFFC571D));
  _colorCollection.add(const Color(0xFF85461E));
  _colorCollection.add(const Color(0xFFFF00FF));
  _colorCollection.add(const Color(0xFF3D4FB5));
  _colorCollection.add(const Color(0xFFE47C73));
  _colorCollection.add(const Color(0xFF636363));

}

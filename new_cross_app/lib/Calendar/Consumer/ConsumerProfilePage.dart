library booking_Calendar;
// import 'dart:js' as js;
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:new_cross_app/Calendar/Consumer/TradieDemo.dart';
import 'package:new_cross_app/main.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../Routes/route_const.dart';
import '../../stripe/check_out.dart';
import '../../stripe/stripe_web/stripe_payment_web.dart';
import 'Booking.dart';
import 'ConsumerBookingPage.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher_string.dart';

import '../../services/platform_service.dart';


part 'StatusPicker.dart';

part 'AppointmentEditor.dart';


//ignore: must_be_immutable
class ConsumerProfilePage extends StatefulWidget {
  String consumer='';
  ConsumerProfilePage({Key? key, required  this.consumer}) : super(key: key);

  @override
  ConsumerProfileState createState() => ConsumerProfileState(this.consumer);
}

//Variables
List<Color> _colorCollection = <Color>[];
List<String> _colorNames = <String>[];
int _selectedStatusIndex = 0;
List<String> _statusNames = <String>[];
List<Booking> ls = <Booking>[];
late DataSource _events = DataSource(ls);
Booking? _selectedAppointment;
String selectedKey='';
String _tradieName = '';
String _consumerName='';
String _tradieId='';
String _consumerId='';
late num quote;
late DateTime _startDate;
late TimeOfDay _startTime;
late DateTime _endDate;
late TimeOfDay _endTime;
bool _isAllDay = false;
String _subject = '';
String _notes = '';
String _comment = '';
late num _rating;
final databaseReference = FirebaseFirestore.instance;
final CollectionReference bookingRef=databaseReference.collection('bookings');
class ConsumerProfileState extends State<ConsumerProfilePage> {
  String consumer;
  late Stream<QuerySnapshot> _usersStream;
  ConsumerProfileState(String this.consumer){
    _consumerId=this.consumer;
    print(_consumerId);
    bookingRef.where('consumerId', isEqualTo: _consumerId).snapshots().listen(
          (event) => print("get query"+_consumerId),

      onError: (error) => print("Listen failed: $error"),
    );
    print("this"+_consumerId);
    _usersStream = bookingRef.where('consumerId', isEqualTo: _consumerId).snapshots();
  }

  late List<String> eventNameCollection;
  late List<Booking> appointments = <Booking>[];
  CalendarController calendarController = CalendarController();


  @override
  void initState() {
    addListDetails();
    super.initState();
  }
 
  //Main Page
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
          rating: e['quote'] ?? '',
          comment: e['comment']?? '',
        ))
            .toList();
        _events = DataSource(list!);

        return Scaffold(
            appBar: AppBar(
            ),
            resizeToAvoidBottomInset: true,
            body: getEventCalendar(_events, onCalendarTapped));
      },
    );
  }

  //Set up Calendar
  SfCalendar getEventCalendar(
      DataSource _calendarDataSource, CalendarTapCallback calendarTapCallback) {
    return SfCalendar(
        view: CalendarView.month,
        controller: calendarController,
        //Display Mode:
        allowedViews: const [CalendarView.week, CalendarView.month],
        dataSource: _calendarDataSource,
        onTap: calendarTapCallback,

        appointmentBuilder: (context, calendarAppointmentDetails) {
          final Booking meeting = calendarAppointmentDetails.appointments.first;
          //Container for every meeting
          return Container(
            color: _colorCollection[_statusNames.indexOf(meeting.status==''?'Pending':meeting.status)]
                .withOpacity(0.5),
            child: Center(
              child: Text(
                meeting.eventName,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
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
    if (calendarTapDetails.targetElement != CalendarElement.calendarCell &&
        calendarTapDetails.targetElement != CalendarElement.appointment) {
      return;
    } else {
      calendarController.view = CalendarView.day;
      if (calendarTapDetails.targetElement != CalendarElement.calendarCell) {
        setState(() {
          _selectedAppointment = null;
          _selectedStatusIndex = 0;
          if (calendarTapDetails.appointments != null &&
              calendarTapDetails.appointments!.length == 1) {
            final Booking meetingDetails = calendarTapDetails.appointments![0];
            _startDate = meetingDetails.from;
            _endDate = meetingDetails.to;
            _selectedStatusIndex = _statusNames.indexOf(meetingDetails.status);
            _tradieName = meetingDetails.tradieName;
            _consumerName = meetingDetails.consumerName;
            _subject = meetingDetails.eventName == '(No title)'
                ? ''
                : meetingDetails.eventName;
            _notes = meetingDetails.description;
            selectedKey=meetingDetails.key;
            _consumerId=meetingDetails.consumerId;
            _tradieId=meetingDetails.tradieId;
            _selectedAppointment = meetingDetails;
            quote=meetingDetails.quote;
            _rating=meetingDetails.rating;
            _comment=meetingDetails.comment;

            //如果返回appointments 为null，则说明是新的meeting,根据点击的时间点设置信息，并且跳转到appointment editor
          } else {
            final DateTime date = calendarTapDetails.date!;
            _startDate = date;
            _endDate = date.add(const Duration(hours: 1));
          }
          //点击当前存在的meeting只会返回list length 为1.
          _startTime =
              TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
          _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
          GoRouter.of(context).pushNamed(RouterName.AppointmentEditor);
        });
      }
    }

  }

  void addListDetails() {
    //_colorCollection = <Color>[];
    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF85461E));
    _colorCollection.add(const Color(0xFFFF00FF));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));

    //_colorNames = <String>[];
    _colorNames.add('Green');
    _colorNames.add('Purple');
    _colorNames.add('Red');
    _colorNames.add('Orange');
    _colorNames.add('Caramel');
    _colorNames.add('Magenta');
    _colorNames.add('Blue');
    _colorNames.add('Peach');
    _colorNames.add('Gray');

    _statusNames.add('Pending');
    _statusNames.add('Confirmed');
    _statusNames.add('Working');
    _statusNames.add('Rating');
    _statusNames.add('Complete');
    _statusNames.add('Unavailable');
  }

}

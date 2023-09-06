library tradie_calendar;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_cross_app/Calendar/Consumer/TradieDemo.dart';
import 'package:new_cross_app/main.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../Consumer/Booking.dart';

part 'BookingEditorT.dart';

part 'AddNonWorking.dart';

//ignore: must_be_immutable
class TradieProfilePage extends StatefulWidget {
  String tradie = '';
  // 传参进来 获得tradieid
  TradieProfilePage({Key? key, required this.tradie}) : super(key: key);
  @override
  TradieProfileState createState() => TradieProfileState(this.tradie);
}

//Variables
List<Color> _colorCollection = <Color>[];
List<String> _colorNames = <String>[];
int _selectedStatusIndex = 0;
List<String> _statusNames = <String>[];

List<Booking> ls = <Booking>[];
late DataSource _events = DataSource(ls);
Booking? _selectedAppointment;
String _tradie = '';
late DateTime _startDate;
late TimeOfDay _startTime;
late DateTime _endDate;
late TimeOfDay _endTime;
bool _isAllDay = false;
String _subject = '';
String _notes = '';
String selectedKey = '';
String _tradieName = '';
String _consumerName = '';
String _tradieId = '';
String _consumerId = '';
String user_tradieName = '';
//String user_tradieId='C6lHBZcGEyVSO7wSbozURFpObKV2';
String user_subject = '';
late num quote;

final databaseReference = FirebaseFirestore.instance;
final CollectionReference colRef = databaseReference.collection('bookings');

class TradieProfileState extends State<TradieProfilePage> {
  String tradie = '';
  late Stream<QuerySnapshot> _usersStream;

  TradieProfileState(String this.tradie) {
    _tradieId = this.tradie;
    //user_tradieId=this.tradie;
    print(_tradieId);
    colRef.where('tradieId', isEqualTo: _tradieId).snapshots().listen(
          (event) => print("get query" + _tradieId),
          onError: (error) => print("Listen failed: $error"),
        );
    print("this" + _tradieId);
    _usersStream = colRef.where('tradieId', isEqualTo: _tradieId).snapshots();
  }

  late List<String> eventNameCollection;
  late List<Booking> appointments = <Booking>[];
  CalendarController calendarController = CalendarController();

  //Calendar Initialisation
  @override
  void initState() {
    addListDetails();
    super.initState();
  }

  //Main Page
  // @override
  // Widget build(BuildContext context) {
  //   _tradie = widget.tradie;
  //   return Scaffold(
  //       appBar: AppBar(
  //         title: Text('Current Bookings'),
  //         leading: IconButton(
  //           icon: Icon(Icons.house),
  //           onPressed: () {
  //             Navigator.push(
  //                 context, MaterialPageRoute(builder: (context) => MyApp()));
  //           },
  //         ),
  //       ),
  //       resizeToAvoidBottomInset: true,
  //       body: Padding(
  //           padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
  //           child: getEventCalendar(_events, onCalendarTapped)),
  //       floatingActionButton: FloatingActionButton(
  //         onPressed: () {
  //           final DateTime today = DateTime.now();
  //           _startDate = today;
  //           _endDate = today;
  //           _startTime =
  //               TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
  //           _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
  //
  //           Navigator.push<Widget>(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (BuildContext context) => AddNonWorking()),
  //           );
  //         },
  //         /*const Icon(Icons.delete_outline, color: Colors.white),*/
  //         backgroundColor: Colors.green,
  //         child: const Text(
  //           'Add',
  //           selectionColor: Colors.cyan,
  //         ),
  //       ));
  // }

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
                ))
            .toList();
        getName(_tradieId).then((value) {user_tradieName = value;});
        _events=DataSource(list!);
        return Scaffold(
            appBar: AppBar(
              title: Text('Current Bookings'),
            ),
            resizeToAvoidBottomInset: true,
            body: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: getEventCalendar(_events, onCalendarTapped)),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                final DateTime today = DateTime.now();
                _startDate = today;
                _endDate = today;
                _startTime =
                    TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
                _endTime =
                    TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);

                Navigator.push<Widget>(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => AddNonWorking()),
                );
              },
              /*const Icon(Icons.delete_outline, color: Colors.white),*/
              backgroundColor: Colors.green,
              child: const Text(
                'Add',
                selectionColor: Colors.cyan,
              ),
            ));
      },
    );
  }

  //Set up Calendar
  SfCalendar getEventCalendar(CalendarDataSource _calendarDataSource,
      CalendarTapCallback calendarTapCallback) {
    return SfCalendar(
        view: CalendarView.month,
        controller: calendarController,
        //Display Mode:
        allowedViews: const [CalendarView.week, CalendarView.month],
        dataSource: _calendarDataSource,
        onTap: calendarTapCallback,

        //看不懂的部分
        appointmentBuilder: (context, calendarAppointmentDetails) {
          final Booking meeting = calendarAppointmentDetails.appointments.first;
          //Container for every meeting
          return Container(
            color: _colorCollection[_statusNames.indexOf(meeting.status)]
                .withOpacity(0.5),
            child: Text(
              meeting.eventName,
              overflow: TextOverflow.ellipsis,
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
      } else if (calendarTapDetails.targetElement ==
          CalendarElement.appointment) {
        setState(() {
          if (calendarTapDetails.appointments != null &&
              calendarTapDetails.appointments!.length == 1) {
            final Booking meetingDetails = calendarTapDetails.appointments![0];
            _selectedAppointment = meetingDetails;
            if (meetingDetails.tradieId == _tradieId) {
              _startDate = meetingDetails.from;
              _endDate = meetingDetails.to;
              _selectedStatusIndex =
                  _statusNames.indexOf(meetingDetails.status);
              _tradieName = meetingDetails.tradieName;
              _consumerName = meetingDetails.consumerName;
              _subject = meetingDetails.eventName;
              _notes = meetingDetails.description;
              selectedKey = meetingDetails.key;
              _consumerId = meetingDetails.consumerId;
              _tradieId = meetingDetails.tradieId;
              quote = meetingDetails.quote;

              Navigator.push<Widget>(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => BookingEditorT()),
              );
            }
            //如果返回appointments 为null，则说明是新的meeting,根据点击的时间点设置信息，并且跳转到appointment editor
          } else {
            final DateTime date = calendarTapDetails.date!;
            _startDate = date;
            _endDate = date.add(const Duration(hours: 1));
            _startTime =
                TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
            _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
            _consumerId = 'user_tradieId';
            _tradieId = 'user_tradieId';
            // _consumerName=user_consumerName;
            _tradieName = user_tradieName;
            _subject = user_subject;

            Navigator.push<Widget>(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => BookingEditorT()),
            );
          }
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

Future<String> getName(userId) async {
  await FirebaseFirestore.instance
      .collection('tradeperson')
      .doc(userId)
      .get()
      .then((value) {
        print('getname');
    return value.data()!['fullName'].toString();
  });
  return 'not Found';
}

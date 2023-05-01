part of tradie_calendar;


class BookingEditor extends StatefulWidget {
  const BookingEditor({super.key});
  @override
  BookingEditorState createState() => BookingEditorState();
}

class BookingEditorState extends State<BookingEditor> {
  Widget _getAppointmentEditor(BuildContext context) {
    return Container(
        color: Colors.white,
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: <Widget>[
            //Booking Title
            ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                leading: const Text(''),
                title: Text(_subject),
            ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                leading: const Text(''),
                title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 7,
                        child: GestureDetector(
                            child: Text(
                                DateFormat('EEE, MMM dd yyyy')
                                    .format(_startDate),
                                textAlign: TextAlign.left),
                            onTap: () async {
                              final DateTime? date = await showDatePicker(
                                context: context,
                                initialDate: _startDate,
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                              );
                              if (date != null && date != _startDate) {
                                setState(() {
                                  final Duration difference =
                                  _endDate.difference(_startDate);
                                  _startDate = DateTime(
                                      date.year,
                                      date.month,
                                      date.day,
                                      _startTime.hour,
                                      _startTime.minute,
                                      0);
                                  _endDate = _startDate.add(difference);
                                  _endTime = TimeOfDay(
                                      hour: _endDate.hour,
                                      minute: _endDate.minute);
                                });
                              }
                            }),
                      ),
                      Expanded(
                          flex: 3,
                          child: false
                              ? const Text('')
                              : GestureDetector(
                              child: Text(
                                DateFormat('hh:mm a').format(_startDate),
                                textAlign: TextAlign.right,
                              ),
                              onTap: () async {
                                final TimeOfDay? time =
                                await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(
                                        hour: _startTime.hour,
                                        minute: _startTime.minute));

                                if (time != null && time != _startTime) {
                                  setState(() {
                                    _startTime = time;
                                    final Duration difference =
                                    _endDate.difference(_startDate);
                                    _startDate = DateTime(
                                        _startDate.year,
                                        _startDate.month,
                                        _startDate.day,
                                        _startTime.hour,
                                        _startTime.minute,
                                        0);
                                    _endDate = _startDate.add(difference);
                                    _endTime = TimeOfDay(
                                        hour: _endDate.hour,
                                        minute: _endDate.minute);
                                  });
                                }
                              })),
                    ])),
            ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                leading: const Text(''),
                title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 7,
                        child: GestureDetector(
                            child: Text(
                              DateFormat('EEE, MMM dd yyyy').format(_endDate),
                              textAlign: TextAlign.left,
                            ),
                            onTap: () async {
                              final DateTime? date = await showDatePicker(
                                context: context,
                                initialDate: _endDate,
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                              );

                              if (date != null && date != _endDate) {
                                setState(() {
                                  final Duration difference =
                                  _endDate.difference(_startDate);
                                  _endDate = DateTime(
                                      date.year,
                                      date.month,
                                      date.day,
                                      _endTime.hour,
                                      _endTime.minute,
                                      0);
                                  if (_endDate.isBefore(_startDate)) {
                                    _startDate = _endDate.subtract(difference);
                                    _startTime = TimeOfDay(
                                        hour: _startDate.hour,
                                        minute: _startDate.minute);
                                  }
                                });
                              }
                            }),
                      ),
                      Expanded(
                          flex: 3,
                          child: _isAllDay
                              ? const Text('')
                              : GestureDetector(
                              child: Text(
                                DateFormat('hh:mm a').format(_endDate),
                                textAlign: TextAlign.right,
                              ),
                              onTap: () async {
                                final TimeOfDay? time =
                                await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(
                                        hour: _endTime.hour,
                                        minute: _endTime.minute));

                                if (time != null && time != _endTime) {
                                  setState(() {
                                    _endTime = time;
                                    final Duration difference =
                                    _endDate.difference(_startDate);
                                    _endDate = DateTime(
                                        _endDate.year,
                                        _endDate.month,
                                        _endDate.day,
                                        _endTime.hour,
                                        _endTime.minute,
                                        0);
                                    if (_endDate.isBefore(_startDate)) {
                                      _startDate =
                                          _endDate.subtract(difference);
                                      _startTime = TimeOfDay(
                                          hour: _startDate.hour,
                                          minute: _startDate.minute);
                                    }
                                  });
                                }
                              })),
                    ])),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
              leading: Icon(
                Icons.people_alt,
              ),
              title: Text(_tradieName),
            ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
              leading: Icon(
                Icons.monetization_on
              ),
              title: Text(quote.toString()),
            ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            //Status
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
              leading: Icon(Icons.lens,
                  color: _colorCollection[_selectedStatusIndex]),
              title: Text(
                _statusNames[_selectedStatusIndex],
              ),
              trailing: _statusNames[_selectedStatusIndex] != 'Pending'
                  ? const Text('')
                  : IconButton(
                icon: Icon(
                  Icons.check_circle,
                  color: _colorCollection[_selectedStatusIndex],
                ),
                onPressed: () {
                  colRef.doc(selectedKey).update({'status': 'Confirmed'});
                  Navigator.pop(context);
                },
              ),
            ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            //Description
            ListTile(
              contentPadding: const EdgeInsets.all(5),
              leading: const Icon(
                Icons.subject,
                color: Colors.black87,
              ),
              title: TextField(
                controller: TextEditingController(text: _notes),
                onChanged: (String value) {
                  _notes = value;
                },
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Add Note',
                ),
              ),
            ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    print(_selectedStatusIndex);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            //最上方一行 new event
            appBar: AppBar(
              title: Text(getTile()),
              backgroundColor: _colorCollection[_selectedStatusIndex],
              //x 按钮
              leading: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              // √ botton
              actions: <Widget>[
                IconButton(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    icon: const Icon(
                      Icons.done,
                      color: Colors.white,
                    ),
                    onPressed: () async{
                      if(_selectedAppointment==null){
                        print('new booking');
                        final meetings = <Booking>[];
                        meetings.add(Booking(
                          from: _startDate,
                          to: _endDate,
                          status: _statusNames[_selectedStatusIndex],
                          consumerName: _consumerName,
                          tradieName: _tradieName,
                          description: _notes,
                          eventName: _subject,
                          consumerId: _consumerId,
                          tradieId: _tradieId,
                          key: selectedKey,
                        ));
                        _events.appointments!.add(meetings[0]);
                        _events.notifyListeners(
                            CalendarDataSourceAction.add, meetings);
                        List<String> keys = <String>[];
                        if (_events.appointments!.isNotEmpty ||
                            _events.appointments != null) {
                          for (int i = 0;
                          i < _events.appointments!.length;
                          i++) {
                            Booking b = _events.appointments![i];
                            keys.add(b.key);
                          }
                        }
                        colRef.doc().set({
                          'eventName': _subject,
                          'from': _startDate.toString(),
                          'to': _endDate.toString(),
                          'status': 'Pending',
                          'tradieName': _tradieName,
                          'consumerName': _consumerName,
                          'description': _notes,
                          'key': selectedKey,
                          'tradieId': _tradieId,
                          'consumerId': _consumerId,
                        });

                        var k = await getKey(keys);
                        colRef.doc(k).update({'key': k});

                      }else{
                        print('old booking');
                        final meetings = <Booking>[];
                        int remove = 0;
                        for (int i = 0; i < _events.appointments!.length; i++) {
                          Booking b = _events.appointments![i];
                          if (b.key == _selectedAppointment!.key) {
                            print('find');
                            remove = i;
                            break;
                          }
                        }
                        _events.appointments!.removeAt(remove);
                        _events.notifyListeners(CalendarDataSourceAction.remove,
                            <Booking>[]..add(_selectedAppointment!));
                        colRef.doc(_selectedAppointment?.key).update({
                          'eventName': _subject,
                          'from': _startDate.toString(),
                          'to': _endDate.toString(),
                          'status': _statusNames[_selectedStatusIndex],
                          'tradieName': _tradieName,
                          'consumerName': _consumerName,
                          'description': _notes,
                          'key': selectedKey,
                          'tradieId': _tradieId,
                          'consumerId': _consumerId,
                        });
                        meetings.add(Booking(
                          from: _startDate,
                          to: _endDate,
                          status: _statusNames[_selectedStatusIndex],
                          consumerName: _consumerName,
                          tradieName: _tradieName,
                          description: _notes,
                          eventName: _subject,
                          consumerId: _consumerId,
                          tradieId: _tradieId,
                          key: selectedKey,
                        ));
                        _events.appointments!.add(meetings[0]);
                        _events.notifyListeners(
                            CalendarDataSourceAction.add, meetings);
                      }
                      _selectedAppointment = null;
                      //_consumer.bookings.add(meetings[0]);
                      Navigator.pop(context);
                    })
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              //TODO 搞懂
              child: Stack(
                children: <Widget>[_getAppointmentEditor(context)],
              ),
            ),
            floatingActionButton: _selectedAppointment == null
                ? const Text('')
                : FloatingActionButton(
              onPressed: () {
                if (_selectedAppointment != null) {
                  int remove = 0;
                  for (int i = 0; i < _events.appointments!.length; i++) {
                    Booking b = _events.appointments![i];
                    if (b.key == _selectedAppointment!.key) {
                      print('find');
                      remove = i;
                      break;
                    }
                  }
                  _events.appointments!.removeAt(remove);
                  _events.notifyListeners(
                      CalendarDataSourceAction.remove,
                      <Booking>[]..add(_selectedAppointment!));
                  try {
                    colRef.doc(_selectedAppointment?.key).delete();
                  } catch (e) {}
                  _selectedAppointment = null;
                  Navigator.pop(context);
                }
              },
              child:
                const Text('Cancel',selectionColor: Colors.white,),
              /*const Icon(Icons.delete_outline, color: Colors.white),*/
              backgroundColor: Colors.red,
            )));
  }

  Future<String> getKey(List<String> oldkeys) async {
    String newKey = '';
    await colRef.where('key', isEqualTo: '').get().then(
          (QuerySnapshot snapshot) {
        if (snapshot.docs.length > 1) {
          for (var b in snapshot.docs) {
            if (oldkeys.indexOf(b.id) == -1) {
              var v = b.data() as Map<String, dynamic>;
              if (v['consumerId'] == _consumerId) {
                newKey = b.id;
                return newKey;
              }
            }
          }
        }
        for (var b in snapshot.docs) {
          if (oldkeys.indexOf(b.id) == -1) {
            newKey = b.id;
            print(newKey);
            return newKey;
          }
        }
      },
      onError: (e) => print("Error getting document: $e"),
    );
    return newKey;
  }

  String getTile() {
    return _subject.isEmpty ? 'New event' : 'Event details';
  }

}

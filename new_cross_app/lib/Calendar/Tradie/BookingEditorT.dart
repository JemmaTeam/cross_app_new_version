part of tradie_calendar;

class BookingEditorT extends StatefulWidget {
  const BookingEditorT({super.key});
  @override
  BookingEditorTState createState() => BookingEditorTState();
}

class BookingEditorTState extends State<BookingEditorT> {
  Widget _getAppointmentEditor(BuildContext context) {
    var textFieldC = TextEditingController(text: quote.toString());
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
              leading: Icon(Icons.monetization_on),
              title: TextField(
                controller: textFieldC,
                onChanged: (value) {
                  print(value);
                  try {
                    if (value.isNotEmpty) {
                      quote = num.parse(value);
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                keyboardType: TextInputType.number,
                maxLines: null,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Add Quote',
                ),
              ),
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

              trailing:  TextButton(
                      child: Text(displayText(_statusNames[_selectedStatusIndex])),
                      onPressed: () {
                        if(_statusNames[_selectedStatusIndex]=='Pending'){
                          setState(() {
                            _selectedStatusIndex=_statusNames.indexOf('Confirmed');
                          });
                          colRef.doc(selectedKey).update({'status': 'Confirmed'});
                        }else if(_statusNames[_selectedStatusIndex]=='Working'){
                          setState(() {
                            _selectedStatusIndex=_statusNames.indexOf('Rating');
                          });
                          colRef.doc(selectedKey).update({'status': 'Rating'});
                        }else{
                          final snackBar = SnackBar(
                            content: Text('No Action Allowed!'),
                            duration: Duration(seconds: 3),
                            action: SnackBarAction(
                              label: 'Close',
                              onPressed: () {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                // Handle the action when the user taps the "Close" button.
                              },
                            ),
                          );

                          // Show the SnackBar at the bottom of the screen
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
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
              title: Text(
                _notes,
                /*onChanged: (String value) {
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
                ),*/
              ),
            ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            ListTile(
              contentPadding: const EdgeInsets.all(5),
              leading: const Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              title: Text(_rating.toString()),
            ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            ListTile(
              contentPadding: const EdgeInsets.all(5),
              leading: const Icon(
                Icons.rate_review,
                color: Colors.black87,
              ),
              title:Text(_comment),
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
                    onPressed: () async {
                      if (_selectedAppointment == null) {
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
                          quote: 0,
                          comment: '',
                          rating: 0,
                        ));
                        print(_rating);
                        print(quote);
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
                          'quote': quote,
                          'rating': _rating,
                          'comment': _comment,
                        });
                        print(_rating);
                        print(quote);
                        var k = await getKey(keys);
                        colRef.doc(k).update({'key': k});
                      } else {
                        setState(() {
                          _selectedAppointment!.from = _startDate;
                          _selectedAppointment!.to = _endDate;
                          _selectedAppointment!.tradieName = _tradieName;
                          _selectedAppointment!.status =
                              _statusNames[_selectedStatusIndex];
                          _selectedAppointment!.consumerName = _consumerName;
                          _selectedAppointment!.description = _notes;
                          _selectedAppointment!.key = selectedKey;
                          _selectedAppointment!.tradieId = _tradieId;
                          _selectedAppointment!.consumerId = _consumerId;
                          _selectedAppointment!.quote = quote;
                          _selectedAppointment!.rating = _rating;
                          _selectedAppointment!.comment = _comment;
                          _selectedAppointment!.eventName = _subject;
                        });
                        print(_rating);
                        print(quote);
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
                          'quote': quote,
                          'rating': _rating,
                          'comment': _comment,
                        });
                        print(_rating);
                        print(quote);
                      }
                      _selectedAppointment = null;
                      //_consumer.bookings.add(meetings[0]);
                      GoRouter.of(context).pop();
                    })
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: Stack(
                children: <Widget>[_getAppointmentEditor(context)],
              ),
            ),
            floatingActionButton:FloatingActionButton(
                    onPressed: () async {
                      List<Booking> bookings = [_selectedAppointment!];
                      setState(() {
                        _events.appointments!.removeAt(_selectedStatusIndex);
                        _events.notifyListeners(CalendarDataSourceAction.remove,
                            bookings);
                      });
                      try {
                        colRef.doc(_selectedAppointment?.key).delete();
                        await usersRef.doc(_tradieId).get().then((DocumentSnapshot doc){
                          final data = doc.data() as Map<String, dynamic>;
                          var orders = data['tOrders'];
                          usersRef.doc(_tradieId).update({'tOrders': orders-1});
                        });
                      } catch (e) {}
                      _selectedAppointment = null;
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      selectionColor: Colors.white,
                    ),
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
  String displayText(String statusNam) {
    if(statusNam == 'Pending'){
      return 'Click to Confirm Booking';
    }else if (statusNam == 'Working'){
      return 'Click to complete Work';
    }else{
      return 'No Action Required';
    }
  }
}

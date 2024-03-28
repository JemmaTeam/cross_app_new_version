part of booking_calendar;

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
              title: Text(user_subject),
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
                trailing: TextButton(
                  child: Text(displayText(_statusNames[_selectedStatusIndex])),
                  onPressed: () async {
                    if (_statusNames[_selectedStatusIndex] == 'Rating') {
                      setState(() {
                        _selectedStatusIndex = _statusNames.indexOf('Complete');
                      });
                      GoRouter.of(context).pushNamed(RouterName.Rate,
                          params: {'bookingId': selectedKey});
                    } else if (_statusNames[_selectedStatusIndex] ==
                        'Confirmed') {
                      setState(() {
                        _selectedStatusIndex = _statusNames.indexOf('Working');
                      });
                      if (quote != 0) {
                        await createPaymentIntent({
                          'price': (quote * 100).toString(),
                          'consumerId': _consumerId,
                          'tradieId': _tradieId,
                          'product_name': _subject,
                          'consumerName': _consumerName,
                        });
                      }
                      bookingRef.doc(selectedKey).update({'status': 'Working'});
                    }
                  },
                )),
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
              title: _comment == ''
                  ? const Text('Your comment will display here.')
                  : Text(_comment),
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
                      AlertDialog alert_outBound;
                      if (!weekend && _startDate.weekday > 5) {
                        Widget OKButton = TextButton(
                          child: const Text("Ok"),
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                        );
                        alert_outBound = AlertDialog(
                          title: const Text("Alert"),
                          content: const Text('Out of Tradie Working Time'),
                          actions: [
                            OKButton,
                          ],
                        );
                        await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return alert_outBound;
                          },
                        );
                        return;
                      } else {
                        if (_startDate.hour < workStart ||
                            _endDate.hour > workEnd) {
                          Widget OKButton = TextButton(
                            child: const Text("Ok"),
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                          );
                          alert_outBound = AlertDialog(
                            title: const Text("Alert"),
                            content: const Text('Out of Tradie Working Time'),
                            actions: [
                              OKButton,
                            ],
                          );
                          await showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) {
                              return alert_outBound;
                            },
                          );
                          return;
                        }
                      }
                      final Booking? newTimeAppointment =
                          _isInterceptExistingAppointments(
                              _startDate, _endDate);
                      AlertDialog alert_conflict;
                      if (newTimeAppointment != null) {
                        Widget okButton = TextButton(
                          child: const Text("Ok"),
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                        );
                        alert_conflict = AlertDialog(
                          title: const Text("Alert"),
                          content: const Text('Have intercept with existing'),
                          actions: [
                            okButton,
                          ],
                        );

                        await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return alert_conflict;
                          },
                        );
                        return;
                      }
                      if (_selectedAppointment == null) {
                        print('add booking test');
                        print(selectedKey);
                        // making new booking
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
                          quote: quote,
                          rating: _rating,
                          comment: _comment,
                        ));
                        _bookings.appointments!.add(meetings[0]);
                        _bookings.notifyListeners(
                            CalendarDataSourceAction.add, meetings);
                        DocumentReference br = await bookingRef.add({
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
                        bookingRef.doc(br.id).update({'key': br.id.trim()});
                        // update torder
                        await usersRef
                            .doc(_tradieId)
                            .get()
                            .then((DocumentSnapshot doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          var orders = data['tOrders'];
                          usersRef
                              .doc(_tradieId)
                              .update({'tOrders': orders + 1});
                        });
                      } else {
                        print('old booking');
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
                        bookingRef.doc(_selectedAppointment?.key).update({
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
                          'comment': '',
                        });
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
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                List<Booking> bookings = [_selectedAppointment!];
                setState(() {
                  _bookings.appointments!.removeAt(_selectedStatusIndex);
                  _bookings.notifyListeners(
                      CalendarDataSourceAction.remove, bookings);
                });

                try {
                  bookingRef.doc(_selectedAppointment?.key).delete();
                  await usersRef
                      .doc(_tradieId)
                      .get()
                      .then((DocumentSnapshot doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    var orders = data['tOrders'];
                    usersRef.doc(_tradieId).update({'tOrders': orders - 1});
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
    await bookingRef.where('key', isEqualTo: '').get().then(
      (QuerySnapshot snapshot) {
        if (snapshot.docs.length > 1) {
          for (var b in snapshot.docs) {
            if (oldkeys.indexOf(b.id) == -1) {
              var v = b.data() as Map<String, dynamic>;
              if (v['consumerId'] == user_consumerId) {
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

  dynamic _isInterceptExistingAppointments(DateTime from, DateTime to) {
    if (from == null ||
        to == null ||
        _bookings == null ||
        _bookings.appointments == null ||
        _bookings.appointments!.isEmpty) return null;
    for (int i = 0; i < _bookings.appointments!.length; i++) {
      Booking appointment = _bookings.appointments![i];
      if (_isSameDay(appointment.from, from) &&
          _isSameDay(appointment.to, to) &&
          ((appointment.from.hour < from.hour &&
                  from.hour < appointment.to.hour) ||
              (appointment.from.hour < to.hour &&
                  to.hour < appointment.to.hour) ||
              (appointment.from.hour < from.hour &&
                  to.hour < appointment.to.hour) ||
              (appointment.from.hour == from.hour &&
                  to.hour == appointment.to.hour))) {
        return appointment;
      }
    }
    return null;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    if (date1 == date2) {
      return true;
    }

    if (date1 == null || date2 == null) {
      return false;
    }

    if (date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day) {
      return true;
    }

    return false;
  }

  String displayText(String statusNam) {
    if (statusNam == 'Rating') {
      return 'Go to Rating Page';
    } else if (statusNam == 'Confirmed') {
      return 'Make Payment';
    } else {
      return 'No Action Required';
    }
  }
}

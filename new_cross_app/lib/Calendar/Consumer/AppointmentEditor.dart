part of booking_Calendar;

class AppointmentEditor extends StatefulWidget {
  const AppointmentEditor({super.key});

  @override
  AppointmentEditorState createState() => AppointmentEditorState();
}

late int amount;

class AppointmentEditorState extends State<AppointmentEditor> {
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
                title: Text(_subject)),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            //start and end time
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
                              DateFormat('EEE, MMM dd yyyy').format(_startDate),
                              textAlign: TextAlign.left),
                        ),
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
                                )),
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
                        ),
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
                                )),
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
              trailing: _statusNames[_selectedStatusIndex] != 'Confirmed'
                  ? IconButton(
                      onPressed: () async {
                        if (_statusNames[_selectedStatusIndex] == 'Rating') {
                          setState(() {
                            _selectedStatusIndex =
                                _statusNames.indexOf('Complete');
                          });
                          await bookingRef
                              .doc(selectedKey)
                              .update({'status': 'Complete'});
                          GoRouter.of(context).pushReplacementNamed(
                              RouterName.Rate,
                              params: {'bookingId': selectedKey});
                        }
                      },
                      icon: _statusNames[_selectedStatusIndex] != 'Rating'
                          ? Icon(
                              Icons.check_circle,
                              color: Colors.white,
                            )
                          : Icon(
                              Icons.check_circle,
                            ))
                  : IconButton(
                      icon: Icon(
                        Icons.check_circle,
                        color: _colorCollection[_selectedStatusIndex],
                      ),
                      onPressed: () async {
                        setState(() {
                          _selectedStatusIndex =
                              _statusNames.indexOf('Working');
                        });
                        await bookingRef
                            .doc(selectedKey)
                            .update({'status': 'Working'});
                        await createPaymentIntent({
                          'price': (quote * 100).toString(),
                          'userId': _consumerId,
                          'product_name': _subject
                        });
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
              title: Text(_comment),
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
                  onPressed: () {
                    final List<Booking> meetings = <Booking>[];
                    //如果是已存在的appointment，从列表中移除，加上更改的
                    if (_selectedAppointment != null) {
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
                    }
                    bookingRef.doc(_selectedAppointment?.key).update({
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
          /*floatingActionButton:FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      _events.appointments!.removeAt(_selectedStatusIndex);
                      _events.notifyListeners(CalendarDataSourceAction.remove,
                          <Booking>[]..add(_selectedAppointment!));
                    });
                    try {
                      bookingRef.doc(_selectedAppointment?.key).delete();
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
                ),*/
        ));
  }

  String getTile() {
    return _subject.isEmpty ? 'New event' : 'Event details';
  }
}

Future<String> createPaymentIntent(Map<String, String> body) async {
  await http
      .post(
    Uri.parse(
        'https://us-central1-jemma-b0fcd.cloudfunctions.net/StripeCheckOut'),
    body: body,
  )
      .then((res) {
    if (res.statusCode == 200) {
      print('success');
      Map<String, dynamic> responseMap = json.decode(res.body);
      amount = int.parse(responseMap['amount']!.toString());
      openExternalUrl(responseMap['url']!.toString());
    } else {
      print('failed: ${res.body}');
    }
  });
  return '';
}

void openExternalUrl(String url) {
  js.context.callMethod('openExternalUrl', [url]);
}

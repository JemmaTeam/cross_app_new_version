import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_cross_app/Home%20Page/responsive.dart';
import '../Home Page/constants.dart';

class TradieWorkPublish extends StatefulWidget {
  final String userID;

  TradieWorkPublish({required this.userID});

  @override
  _TradieWorkPublishState createState() => _TradieWorkPublishState();
}

final databaseReference = FirebaseFirestore.instance;
final CollectionReference colRef = databaseReference.collection('users');

class _TradieWorkPublishState extends State<TradieWorkPublish> {
  TextEditingController workTitleController = TextEditingController();
  TextEditingController workDescriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  TextEditingController postcodeController = TextEditingController();

  bool? workWeekendValue;
  num? startTime;
  num? endTime;
  String stripeId ='';

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  @override
  void dispose() {
    workTitleController.dispose();
    workDescriptionController.dispose();
    postcodeController.dispose();
    super.dispose();
  }

  _getUserData() async {
    DocumentSnapshot docSnapshot = await colRef.doc(widget.userID).get();
    Map<String, dynamic> values = docSnapshot.data() as Map<String, dynamic>;

    if (values != null) {
      workTitleController.text = values['workTitle'] ?? '';
      workDescriptionController.text = values['workDescription'] ?? '';
      postcodeController.text = values['postcode'] ?? '';
      setState(() {
        stripeId = values['stripeId'];
        workWeekendValue = values['workWeekend'];
        startTime = values['workStart'];
        endTime = values['workEnd'];
      });
    }
  }

  _updateData() async {
    String workTitle = workTitleController.text;
    String workDescription = workDescriptionController.text;
    String postcode = postcodeController.text;

    Map<String, dynamic> updatedInfo = {
      'workTitle': workTitle,
      'workDescription': workDescription,
      'workStart': startTime,
      'workEnd': endTime,
      'workWeekend': workWeekendValue,
      'postcode': postcode,
    };

    // update information
    try {
      await colRef.doc(widget.userID).update(updatedInfo);
    } catch (e) {
      print("Error updating document: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Publish Work'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Work title
            attributeEdit(size, workTitleController, 'work title', 'Put your work title here'),
            SizedBox(height: 2.5.ph(size)),

            // work description
            attributeEdit(size, workDescriptionController, 'work description', 'Put your work description here'),
            SizedBox(height: 2.5.ph(size)),

            // work on weekends or not
            workWeekendDropdownButton(size),
            SizedBox(height: 2.5.ph(size)),

            // work start and end time
            startEndTimeDropDownButton(context, size),
            SizedBox(height: 2.5.ph(size)),

            // postcode of work area
            postcodeBuildForm(size),
            SizedBox(height: 2.5.ph(size)),

            // publish work button
            ElevatedButton(
              onPressed: () async {
                // the tradies can only publish work after they already have a Stripe accout
                if (stripeId.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.white,
                      content: Text('Publish work failed! Please go back to your profile page and link your Stripe account first.',
                          style: TextStyle(color: Colors.red)),
                    ),
                  );
                }
                else {
                  // if the postcode is invalid, the work can't be published
                  if (_formKey.currentState!.validate()) {
                    await _updateData();
                    Navigator.pop(context, 'update'); // return to the former page, with a parameter to indicate the information has been updated
                  }
                }
              },
              child: Text('Publish Work'),
            ),
          ],
        ),
      ),
    );
  }

  // Enter the postcode of the working area, postcode can only be 4 digits and will be validated
  Container postcodeBuildForm(Size size) {
    return Container(
      width: 50.pw(size),
      constraints: const BoxConstraints(minWidth: 400),
      child: Form(
            key: _formKey,
            child: TextFormField(
              controller: postcodeController,
              decoration: InputDecoration(
                labelText: 'working postcode',
                hintText: 'Put your working postcode here',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: kLogoColor, width: 1.0),
                ),
              ),
              keyboardType: TextInputType.number,
              maxLength: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a postcode';
                }
                final isDigitsOnly = int.tryParse(value);
                if (isDigitsOnly == null) {
                  return 'Please enter only numeric characters';
                }
                if (value.length != 4) {
                  return 'Postcode must be exactly 4 digits';
                }
                return null;
              },
            ),

          ),
    );
  }

  // choose the start and end time of work (the start time can't be later than the end time)
  Column startEndTimeDropDownButton(BuildContext context, Size size) {
    return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Work start time
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text(
                  'Work Start Time',
                  style: TextStyle(
                      color: kTextColor,
                      fontSize: 16),
                ),
                SizedBox(width: 5.pw(size)),
                DropdownButton<num>(
                value: startTime,
                items: List.generate(24, (index) {
                  return DropdownMenuItem<num>(
                    value: index,
                    child: Text(index < 10 ? '0$index' : '$index'),
                  );
                }),
                hint: Text('Select start time'),
                onChanged: (num? value) {
                  if (endTime != null && value! >= endTime!) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Start time cannot be later than end time'),
                      ),
                    );
                    return;
                  }
                  setState(() {
                    startTime = value!;
                  });
                },
              ),
            ]),
            SizedBox(height: 2.5.ph(size)),
            // Work end time
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text(
                  'Work End Time',
                  style: TextStyle(
                      color: kTextColor,
                      fontSize: 16),
                ),
                SizedBox(width: 5.pw(size)),
                DropdownButton<num>(
                value: endTime,
                items: List.generate(24, (index) {
                  return DropdownMenuItem<num>(
                    value: index,
                    child: Text(index < 10 ? '0$index' : '$index'),
                  );
                }),
                hint: Text('Select end time'),
                onChanged: (num? value) {
                  if (startTime != null && value! <= startTime!) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('End time cannot be earlier than start time'),
                      ),
                    );
                    return;
                  }
                  setState(() {
                    endTime = value!;
                  });
                },
              ),
            ]),
          ],
        );
  }

  // choose if work on weekend
  Row workWeekendDropdownButton(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Work on Weekends',
          style: TextStyle(
              color: kTextColor,
              fontSize: 16),
        ),
        SizedBox(width: 5.pw(size)),
        DropdownButton<bool>(
                value: workWeekendValue,
                items: [
                  DropdownMenuItem<bool>(
                    value: true,
                    child: Text('True'),
                  ),
                  DropdownMenuItem<bool>(
                    value: false,
                    child: Text('False'),
                  ),
                ],
                hint: Text('Select if you can work on weekend'),
                onChanged: (bool? newValue) {
                  setState(() {
                    workWeekendValue = newValue;
                  });
                },
              ),
      ],
    );
  }

  // Each input text field
  Container attributeEdit(Size size, TextEditingController controller,
      String labelText, String hintText) {
    return Container(
      width: 50.pw(size),
      constraints: const BoxConstraints(minWidth: 400),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: kLogoColor, width: 1.0),
          ),
        ),
      ),
    );
  }
}

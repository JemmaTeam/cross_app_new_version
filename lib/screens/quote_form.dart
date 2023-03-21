import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jemma/utils/constants.dart';
import 'package:jemma/widgets/quote/photo_description.dart';
import 'package:jemma/widgets/quote/quote_form_arguments.dart';
import 'package:jemma/widgets/quote/quote_form_confirm.dart';
import 'package:jemma/widgets/quote/text_description.dart';
import 'package:jemma/widgets/quote/tradie_detail.dart';
import 'package:jemma/utils/adaptive.dart';
import 'package:jemma/utils/responsive.dart';
import 'package:jemma/utils/notification.dart';
import '../widgets/nav_bar.dart';
import 'home.dart';

class QuoteForm extends StatefulWidget {
  const QuoteForm({Key? key}) : super(key: key);

  @override
  _QuoteFormState createState() => _QuoteFormState();
}

class _QuoteFormState extends State<QuoteForm> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as QuoteFormArguments;

    var size = MediaQuery.of(context).size;

    return Scaffold(
        drawer: NavBar(),
        appBar: AppBar(
          title: Text('Quote Form'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () => Navigator.of(context).pop(Home),
                icon: Icon(Icons.arrow_back)),
          ],
        ),
        body: Scrollbar(
          isAlwaysShown: isWeb(),
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1080),
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    SizedBox(height: 2.5.ph(size)),
                    TradieDetail(tradieId: args.tradieId, size: size),
                    SizedBox(height: 2.5.ph(size)),

                    /// stepper
                    Container(
                      height: max(size.height, size.width),
                      child: QuoteFormStep(size: size),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

class QuoteFormStep extends StatefulWidget {
  QuoteFormStep({Key? key, required this.size}) : super(key: key);

  final Size size;

  @override
  _QuoteFormStepState createState() => _QuoteFormStepState(size: size);
}

class _QuoteFormStepState extends State<QuoteFormStep> {
  _QuoteFormStepState({required this.size});
  final Size size;

  int _index = 0;
  final int _nStep = 2; // 0, 1, 2
  String? _selectedOption;

  final TextEditingController summaryController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  // Hi, I live in Acton. My tag was broken and I want someone to fix it. Please send me your quote. Thanks!

  List<String> jobTypes = ['General'];

  @override
  Widget build(BuildContext context) {
    return Stepper(
      type: StepperType.horizontal,
      currentStep: _index,
      onStepCancel: () {
        if (_index > 0) {
          setState(() {
            _index -= 1;
          });
        }
      },
      onStepContinue: () {
        if (_index < _nStep) {
          if ((_selectedOption?.isEmpty ?? true) ||
              summaryController.text.isEmpty ||
              descriptionController.text.isEmpty) {
            showNotification(
                context, 'Please complete this step.', NotificationType.error);
          } else {
            setState(() {
              _index += 1;
            });
          }
        }
      },
      onStepTapped: (int index) {
        setState(() {
          _index = index;
        });
      },
      controlsBuilder: (BuildContext context, ControlsDetails details) {
        //{VoidCallback? onStepContinue, VoidCallback? onStepCancel}) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            /// Previous button
            if (_index > 0)
              TextButton(
                onPressed: details.onStepCancel,
                child: const Text('Previous'),
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  foregroundColor: MaterialStateProperty.all(Colors.grey),
                ),
              ),

            SizedBox(width: 2.5.pw(size)),

            /// Next button
            TextButton(
              onPressed: details.onStepContinue,
              child:
                  (_index < _nStep) ? const Text('Next') : const Text('Submit'),
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                foregroundColor: MaterialStateProperty.all(Colors.black),
                backgroundColor: MaterialStateProperty.all(kLogoColor),
              ),
            ),
          ],
        );
      },
      steps: <Step>[
        /// Job type, summary, text description
        Step(
          title: const Text(''),
          content: Column(
            children: [
              /// Job type
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                decoration: const ShapeDecoration(
                  color: Colors.white10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      side: BorderSide(color: Colors.grey)),
                ),
                child: DropdownButton(
                  value: _selectedOption,
                  onChanged: (selection) => setState(() {
                    _selectedOption = selection.toString();
                  }),
                  hint: Container(
                      // padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: const Text(
                    'Job Type',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  )),
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: jobTypes.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    );
                  }).toList(),
                ),
              ),

              TextDescription(
                summaryController: summaryController,
                descriptionController: descriptionController,
              ),
            ],
          ),
        ),

        /// Photo description
        const Step(
          title: Text(''),
          content: PhotoDescription(),
        ),

        /// Confirmation
        Step(
            title: const Text(''),
            content: QuoteFormConfirmation(
              notesController: notesController,
              summary: summaryController.text,
              description: descriptionController.text,
              jobType: _selectedOption,
            )),
      ],
    );
  }
}

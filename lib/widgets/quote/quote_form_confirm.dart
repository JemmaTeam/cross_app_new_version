import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jemma/utils/constants.dart';
import 'package:jemma/utils/responsive.dart';

class QuoteFormConfirmation extends StatelessWidget {
  const QuoteFormConfirmation({
    Key? key,
    required this.notesController,
    required this.summary,
    required this.description,
    required this.jobType,
  }) : super(key: key);

  final TextEditingController notesController;
  final String summary;
  final String description;
  final String? jobType;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      child: Column(children: [
        Text('Please confirm the below details and add any additional notes, if needed.'),
        SizedBox(height: 2.5.ph(size)),

        Container(
          padding: const EdgeInsets.all(10),
          alignment: Alignment.centerLeft,
          decoration: const ShapeDecoration(
            color: Colors.white10,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                side: BorderSide(color: Colors.grey)
            ),
          ),
          child: Text(jobType.toString()),
        ),

        SizedBox(height: 2.5.ph(size)),

        /// summary
        Container(
          padding: const EdgeInsets.all(10),
          alignment: Alignment.centerLeft,
          decoration: const ShapeDecoration(
            color: Colors.white10,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                side: BorderSide(color: Colors.grey)
            ),
          ),
          child: Text(summary),
        ),

        SizedBox(height: 2.5.ph(size)),

        /// text description
        Container(
          padding: const EdgeInsets.all(10),
          alignment: Alignment.centerLeft,
          decoration: const ShapeDecoration(
            color: Colors.white10,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                side: BorderSide(color: Colors.grey)
            ),
          ),
          child: Text(description),
        )
      ],)
    );
  }
}

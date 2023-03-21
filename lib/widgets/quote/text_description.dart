import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jemma/utils/responsive.dart';

class TextDescription extends StatelessWidget {
  const TextDescription({
    Key? key,
    required this.summaryController,
    required this.descriptionController,
  }) : super(key: key);

  final TextEditingController summaryController;
  final TextEditingController descriptionController;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      child: Column(children: [
        SizedBox(height: 2.5.ph(size)),

        /// summary
        TextFormField(
          maxLength: 70,
          controller: summaryController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Summary',
            labelStyle: TextStyle(fontSize: 14),
          ),
        ),

        SizedBox(height: 2.5.ph(size)),

        /// text description
        TextFormField(
          maxLength: 500,
          maxLines: null,
          controller: descriptionController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Description',
            labelStyle: TextStyle(fontSize: 14),
          ),
        ),

        SizedBox(height: 2.5.ph(size)),
      ],),
    );
  }
}

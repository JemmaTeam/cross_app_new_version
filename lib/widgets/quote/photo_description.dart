import 'package:flutter/material.dart';
import 'package:jemma/utils/constants.dart';
import 'package:jemma/utils/responsive.dart';
import 'package:file_picker/file_picker.dart';

class PhotoDescription extends StatelessWidget {
  const PhotoDescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
        child: Column(children:[
          Text('Please add images, if needed.'),
          SizedBox(height: 2.5.ph(size)),

          Container(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Attachment Instructions:',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600, ),
                ),
                const Text(
                  'Allowed only files with extension (jpg, png, gif)',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
                const Text(
                  'Maximum number of allowed files 3 with 8MB of each',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 12, color: Colors.black),
                )
              ],
          ),),

          SizedBox(height: 2.5.ph(size)),

          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {},
              child: const Text(' Choose Image '),
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                foregroundColor: MaterialStateProperty.all(Colors.black),
                backgroundColor: MaterialStateProperty.all(kLogoColor),
              ),
            ),
          )
        ])
    );
  }
}

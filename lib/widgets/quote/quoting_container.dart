import 'dart:ui';

import 'package:jemma/models/quote.dart';
import 'package:jemma/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:jemma/utils/decorations.dart';

class QuotingContainer extends StatelessWidget {
  const QuotingContainer({Key? key, required this.size, required this.quoting} ) : super(key: key);
  final Size size;
  final Quote quoting;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        constraints:  const BoxConstraints(maxWidth: 1000, minWidth: 200),
        width: size.width,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: defaultShadows,
            borderRadius: BorderRadius.circular(40)
        ),
        padding: const EdgeInsets.all(20),

        child: Wrap(
          runAlignment: WrapAlignment.center,
          spacing: 7.25.ph(size),
          runSpacing: 25,
          children: [
            OverflowBar(
                spacing: 7.25.ph(size),
                overflowSpacing: 25,
                children:[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      const CircleAvatar( backgroundImage: AssetImage("assets/images/user_profile.png"),),
                      const SizedBox(width:5),
                      Text((quoting.tradie?.firstName ?? "")+ " " + (quoting.tradie?.lastName ?? "") ),
                      const SizedBox(width:10),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children:[
                          const Icon(Icons.home_repair_service),
                          const SizedBox(width:5),
                          Text(quoting.jobType?.name ?? ""),
                        ],
                      ),
                    ],
                  ),


                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children:[
                      const Icon(Icons.short_text),
                      const SizedBox(width:5),
                      Flexible(
                        child:Text(quoting.customerSummary?? "",maxLines: 4,),
                      ),
                    ],
                  ),
                ]),
            Row(
              mainAxisSize: MainAxisSize.min,
              children:[
                const Icon(Icons.location_pin),
                const SizedBox(width:5),
                Expanded(
                  child: SelectableText(quoting.address?.toSimpleString() ?? ""),),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children:[
                const Icon(Icons.monetization_on),
                const SizedBox(width:5),
                Text(quoting.price.toString()  ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children:[
                const Icon(Icons.date_range),
                const SizedBox(width:5),
                Text(quoting.timeStamp?.toString() ?? ""),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
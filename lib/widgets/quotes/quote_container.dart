import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jemma/models/quote.dart';
import 'package:jemma/routes.dart';
import 'package:jemma/utils/decorations.dart';
import 'package:jemma/utils/responsive.dart';


/// Reusable container which possess high level details of a [quote].
class QuoteContainer extends StatelessWidget {
  const QuoteContainer({Key? key, required this.size, required this.quote} ) : super(key: key);
  final Size size;
  final Quote quote;

  @override
  Widget build(BuildContext context) {
    final DateTime timeStamp =  quote.timeStamp ?? DateTime.now();
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

        child: InkWell(
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
                        // TODO: Load image via url after backend work on GCP buckets has been merged.
                        const CircleAvatar( backgroundImage: AssetImage("assets/images/user_profile.png"),),
                        const SizedBox(width:5),
                        Text((quote.tradie?.firstName ?? "")+ " " + (quote.tradie?.lastName ?? "") ),
                        const SizedBox(width:10),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children:[
                            const Icon(Icons.home_repair_service),
                            const SizedBox(width:5),
                            Text(quote.jobType?.name ?? ""),
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
                          child:Text(quote.customerSummary?? "",maxLines: 4,),
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
                    child: SelectableText(quote.address?.toSimpleString() ?? "Address not available."),),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children:[
                  const Icon(Icons.monetization_on),
                  const SizedBox(width:5),
                  Text(quote.price?.toString() ?? "Price not available." ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children:[
                  const Icon(Icons.date_range),
                  const SizedBox(width:5),
                  Text(quote.timeStamp != null ? DateFormat('dd-MM-yyyy hh:mm').format(timeStamp):"Time not available."),
                ],
              ),
            ],
          ),
          onTap: (){
            Navigator.pushNamed(
                context,
                Screen.quoteDetails.getURL(),
                arguments :{
                  "quote":quote
                }
            );

          },
        ),
      ),
    );
  }
}


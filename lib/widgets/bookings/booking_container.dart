import 'dart:ui';


import 'package:intl/intl.dart';
import 'package:jemma/screens/booking_details.dart';


import 'package:jemma/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:jemma/models/booking.dart';
import 'package:jemma/utils/decorations.dart';

import '../../routes.dart';



/// Reusable container which possess high level details of a [booking].
class BookingContainer extends StatelessWidget {
  const BookingContainer({Key? key, required this.size, required this.booking} ) : super(key: key);
  final Size size;
  final Booking booking;


  @override
  Widget build(BuildContext context) {
    final DateTime timeStamp =  booking.timeStamp ?? DateTime.now();
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
                        // TODO: Load image later
                        const CircleAvatar( backgroundImage: AssetImage("assets/images/user_profile.png"),),
                        const SizedBox(width:5),
                        Text((booking.tradie?.firstName ?? "")+ " " + (booking.tradie?.lastName ?? "") ),
                        const SizedBox(width:10),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children:[
                            const Icon(Icons.home_repair_service),
                            const SizedBox(width:5),
                            Text(booking.quote?.jobType?.name ?? "Name not available."),
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
                          child:Text(booking.quote?.customerSummary?? "Summary not available.",maxLines: 4,),
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
                    child: SelectableText(booking.quote?.address?.toSimpleString() ?? "Address not available."),),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children:[
                  const Icon(Icons.monetization_on),
                  const SizedBox(width:5),
                  Text(booking.quote?.price.toString() ?? "Price not available." ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children:[
                  const Icon(Icons.date_range),
                  const SizedBox(width:5),
                  Text(booking.timeStamp != null ? DateFormat('dd-MM-yyyy hh:mm').format(timeStamp):"Time not available."),
                ],
              ),
            ],
          ),
          onTap: (){
            Navigator.pushNamed(
                context,
                Screen.bookingDetails.getURL(),
                arguments :{
                  "booking":booking
                }
            );
          },
        ),
      ),
    );
  }
}
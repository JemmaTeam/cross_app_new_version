

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:jemma/enums/user_type.dart';
import 'package:jemma/models/booking.dart';
import 'package:jemma/providers/booking_details.dart';
import 'package:jemma/providers/quote_details.dart';
import 'package:jemma/repository.dart';
import 'package:jemma/utils/custom_app_bar.dart';

import 'package:jemma/providers/booking_details.dart';
import 'package:jemma/providers/quote_details.dart';
import 'package:jemma/repository.dart';

import 'package:provider/provider.dart';

import '../login_button.dart';


/// App bar meant for [BookingDetail] screen.
class CustomAppBar extends StatelessWidget {


  Booking initialBooking;
  CustomAppBar(this.initialBooking, {Key? key}) : super(key: key);
  static const double height  = 200;


  @override
  Widget build(BuildContext context) {

    TextEditingController textController = TextEditingController();

    final UserType loggedInUserType = Repository().user.value!.userType;
    String? userFirstName;
    double? rating;
    if (loggedInUserType == UserType.customer){
      userFirstName =  initialBooking.tradie?.firstName;
      rating = initialBooking.tradie?.rating;
    }
    else{
      userFirstName =  initialBooking.customer?.firstName;
      rating = initialBooking.customer?.rating;
    }


    return SliverAppBar(
      title: Text( 'Jemma',
          style: GoogleFonts.parisienne(fontSize: 20,fontWeight: FontWeight.w600)),
      floating: true,
      pinned: true,
      snap: false,



      actions: buildActions(),



      expandedHeight: height,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/banner_background.png"),
                fit: BoxFit.fill
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 0.2 * height),
              Text( Repository().getBookingName(isStyled: true) + " detail" ,
                  style: GoogleFonts.roboto(fontSize: 20,fontWeight: FontWeight.w600)),
              const SizedBox(height: 0.05 * height),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1080,maxHeight: 0.65*height),
                child: Consumer<BookingDetailsNotifier>(
                    builder: (context,bookingDetailNotifier,child) {
                      if(bookingDetailNotifier.isLoading){
                        return const CircularProgressIndicator();
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Flexible(
                              child: CircleAvatar(backgroundImage: AssetImage("assets/images/user_profile.png"), maxRadius: 0.15 * height,)),
                          const SizedBox(width: 10,),
                          Flexible(
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 750,minWidth: 275),
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.short_text),

                                      Flexible(child: Text(userFirstName ?? "First name not available.",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),overflow:TextOverflow.ellipsis ,)),

                                    ],
                                  ),
                                  SizedBox(
                                      width: 275,
                                      child: GFRating(onChanged: (_){}, value: rating?? 0.0, color: Colors.black,borderColor: Colors.black))
                                ],
                              ),
                            ),
                          )

                        ],
                      );}
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
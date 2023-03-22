// import 'dart:html';
import 'package:universal_html/html.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:jemma/enums/quote_status.dart';
import 'package:jemma/enums/user_type.dart';
import 'package:jemma/models/quote.dart';
import 'package:jemma/providers/quote_details.dart';
import 'package:jemma/repository.dart';
import 'package:jemma/utils/constants.dart';
import 'package:jemma/utils/decorations.dart';
import 'package:jemma/utils/notification.dart';
import 'package:jemma/widgets/image_viewer.dart';
import 'package:jemma/widgets/quote_details/custom_app_bar.dart';
import 'package:jemma/widgets/quote_details/decline_dialog.dart';

import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import '../main.dart';
import '../widgets/nav_bar.dart';
import 'dart:js' as js;

/// Shows the details of a selected [Quote]; Note: This screen can be accessed through Quote list page.
/// Expects the [Quote] to be sent as an arg via the Navigator.
class QuoteDetails extends StatelessWidget {

  final userType = Repository().user.value!.userType;
  
  /// Updates UI on receiving the result of decline from QuoteDetailsNotifier;
  ///
  /// [context] is the Context of the current screen.
  /// [isDeclined] is the boolean value in the [QuoteDetailsNotifier].
  /// [resultMessage] is the String to be shown in the notification.
  void handleDeclineResult(BuildContext context,bool isDeclined,String resultMessage){
    if(isDeclined) {
      showNotification(context,resultMessage,NotificationType.success);
    } else{
      showNotification(context,resultMessage,NotificationType.error);
    }
  }


  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    // TODO: Prolly look into better ways of data transmission
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    final Quote initialQuote = arguments["quote"];

    return Scaffold(
      drawer: NavBar(),
      body: Consumer<QuoteDetailsNotifier>(
        builder: (context,quoteDetailsNotifier,child) {
          Widget sliverContents;
          //TODO use if need timestamp in quote detail
          DateTime timeStamp =  quoteDetailsNotifier.quote?.timeStamp ?? DateTime.now();
          quoteDetailsNotifier.setQuote(initialQuote);
          Quote? displayQuote =  quoteDetailsNotifier.isLoading ? initialQuote :quoteDetailsNotifier.quote;
          logger.d("Building $displayQuote ${quoteDetailsNotifier.quote}");

          if (quoteDetailsNotifier.isLoading){
            sliverContents = SliverToBoxAdapter(
                child: Container(
                    height: size.height - CustomAppBar.height,
                    width: size.width,
                    child: const Center(
                        child: CircularProgressIndicator())
                )
            );
          }
          else{
            List<Widget> sliverContentsAsList = [
              Row(
                children: [
                  const Icon(Icons.info_rounded),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    elevation: 2,
                    padding: const EdgeInsets.all(5),
                    label: Text(quoteDetailsNotifier.quote?.status?.toStyledString() ?? "Status not available."),
                    selected: true ,
                    onSelected:(isSelected){
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.home_repair_service),
                  const SizedBox(width: 10),
                  Text(quoteDetailsNotifier.quote?.jobType?.name  ?? "Job type not available."),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.short_text),
                      const SizedBox(width: 5),
                      const Text("Summary",style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(quoteDetailsNotifier.quote?.customerSummary ?? "Summary not available."),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_pin),
                      const SizedBox(width: 5),
                      const Text("Address",style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(quoteDetailsNotifier.quote?.address?.toStyledString()?? "Address not available."),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.receipt_long),
                      const SizedBox(width: 5),
                      const Text("Description",style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  buildUserContentWidget(quoteDetailsNotifier.quote?.customerDescription ?? "Description not available."),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.note_add_rounded),
                      const SizedBox(width: 5),
                      const Text("Other notes",style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  buildUserContentWidget(quoteDetailsNotifier.quote?.notes ?? "customer notes"),
                ],
              ),

              Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.image),
                      const SizedBox(width: 5),
                      const Text("Images",style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: defaultShadows,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    padding: const EdgeInsets.all(20),
                    constraints: const BoxConstraints(maxHeight: 200,maxWidth: 500),

                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
                            showDialog<List<dynamic>>(context: context, builder: (_) => const ImageViewer(
                            ));

                          },
                          child: Container(
                            width: 160.0,
                            child: const Image(image:AssetImage("assets/images/organize.png"),),
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
              if(quoteDetailsNotifier.isDeclined())
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.cancel),
                        const SizedBox(width: 5),
                        const Text("Decline reason",style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(quoteDetailsNotifier.quote?.declineReason ?? "Reason not available")
                  ],
                ),

              if(!quoteDetailsNotifier.isDeclined())
                Wrap(
                  spacing: 20,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: (){
                          post(
                            Uri.parse("http://localhost:8000/quotes/" +
                                (quoteDetailsNotifier.quote?.id).toString() +
                                "/checkout/"),
                            headers: {
                              "Content-type": "application/json",
                              "Accept": "application/json",
                              "Authorization":
                              "Token ec9d08409f1b2e5724343cfb8ad8ea38d3d5895e"
                            }
                          ).then(
                              (Response value){
                                debugPrint("\nThen: ${value.body}\n");
                                var response = json.decode(value.body);
                                js.context.callMethod('open', [response]);
                              }
                          );
                        },
                        child: const Text(
                          "pay",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      style: ElevatedButton.styleFrom(
                        primary: kLogoColor,
                        elevation: 2,
                      ),
                    ),
                    ElevatedButton(onPressed: (){}, child: const Text("Accept",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),),
                      style: ElevatedButton.styleFrom(primary:kLogoColor,elevation: 2 ),),
                    ElevatedButton(onPressed: (){
                      showDialog<List<dynamic>>(context: context, builder: (_) =>  const QuoteDeclineDialog()
                      ).then((values) {
                        logger.d(values);
                       String reason =  values!.first;
                       quoteDetailsNotifier.decline(reason,(resultMessage) =>
                           handleDeclineResult(context,quoteDetailsNotifier.isDeclined(),resultMessage));
                      }
                      );
                    }, child: const Text("Decline",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                        style: ElevatedButton.styleFrom(primary:Colors.red.shade400,elevation: 2 )),
                    ElevatedButton(onPressed: (){}, child: const Text("Request in-person check",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(primary:kLogoColor,elevation: 2 ),)
                  ],
                ),
            ];

            sliverContents = SliverList(
              delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                return Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 1080, minWidth: 200),
                    margin: const EdgeInsets.all(15),
                    child: sliverContentsAsList[index],
                  ),
                );
              },
                childCount: sliverContentsAsList.length,

              ),
            );
          }
          return CustomScrollView(
            slivers: <Widget>[
              CustomAppBar(displayQuote!),
              sliverContents,
            ],

          );
        },

      ),
    );
  }

  /// TODO: For future functionalities which wants to allow edits to the detail page.
  Widget buildUserContentWidget(String content, { TextEditingController? controller }){
    if (userType == UserType.tradie){
      return Text(content);
    }
    if (userType == UserType.customer && controller != null){
      return TextFormField(
        controller: controller,
        keyboardType: TextInputType.multiline,
        readOnly:  true,
        initialValue: content,
      );
    }
    return Text(content);}
}
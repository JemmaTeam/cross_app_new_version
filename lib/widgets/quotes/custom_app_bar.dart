
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jemma/enums/sort_order.dart';
import 'package:jemma/providers/quotes.dart';
import 'package:jemma/utils/custom_app_bar.dart';
import 'package:jemma/widgets/quotes/filter_selection.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../login_button.dart';


/// App bar meant for [Quotes] screen.
class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);
  static const double height  = 200;
  @override
  Widget build(BuildContext context) {
    QuotesNotifier quotesNotifier = Provider.of<QuotesNotifier>(context, listen: false);
    TextEditingController textController = TextEditingController();
    textController.text = quotesNotifier.searchQuery ?? "";
    TextButton clearButton = TextButton(onPressed: () {
      textController.clear();
      quotesNotifier.clearSearch(); }, child: const Text("clear"));
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
          height: height,
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
              Text( "Quotes",
                  style: GoogleFonts.roboto(fontSize: 20,fontWeight: FontWeight.w600)),
              const SizedBox(height: 0.05 * height),

              Container(
                constraints: const BoxConstraints(maxWidth: 500),
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child:TextField(
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: quotesNotifier.searchQuery?.isNotEmpty ?? false ? clearButton : const SizedBox(),
                    prefixIcon: const Icon(Icons.search,color: Colors.black,),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.45),
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green.withOpacity(0.45),
                        )),
                    hintText: "Summary of the quotes",
                  ),
                  controller: textController,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      quotesNotifier.search(textController.text);
                    },
                    icon: const Icon(Icons.search,color: Colors.black,size: 18,),
                    label: const Text(
                      'Search',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(primary:Colors.white,elevation: 2 ),

                  ),

                  IconButton(onPressed: (){
                    showDialog<List<dynamic>>(context: context, builder: (_) => FilterSelection(sortField: quotesNotifier.currentSortField,)).then((values) {
                      logger.d(values);
                      var sortOrder = values?.first ?? SortOrder.none;
                      var fieldName = values?.last ?? "";
                      if (values?.length == 2 ){
                        quotesNotifier.setSortingData(sortOrder,fieldName);
                      }
                    });
                  }, icon:  Icon(Icons.filter_alt,color: Colors.grey.withOpacity(0.5),)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

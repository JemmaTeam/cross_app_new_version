
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

import 'package:jemma/providers/quotes.dart';
import 'package:jemma/utils/responsive.dart';
import 'package:jemma/widgets/quotes/custom_app_bar.dart';
import 'package:jemma/widgets/quotes/quote_container.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../widgets/nav_bar.dart';



/// A screen which shows the list of [Quote]s.
///
/// TODO: Refactor to reduce redundancies between quote and bookings if possible
class Quotes extends StatelessWidget {
  Quotes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return  Scaffold(
      drawer: NavBar(),
      body:Consumer<QuotesNotifier>(
          builder: (context,quotesNotifier,child) {
            Widget sliverContent;
            logger.d("building");
            if (quotesNotifier.hasError) {
              logger.e("error");
              sliverContent = SliverToBoxAdapter(child: SizedBox(
                  height: 15.ph(size),
                  child: const Center(child: Text("Something went wrong!"))));
            }
            else if(!quotesNotifier.hasFetchedInitialData || quotesNotifier.isLoading ){

              sliverContent = const SliverToBoxAdapter(child: SizedBox(
                  height:100,
                  child: Center(child: CircularProgressIndicator())),);
              if(!quotesNotifier.hasFetchedInitialData) {
                quotesNotifier.fetchData();
              }
            }
            else{
              sliverContent = SliverList(delegate:
              SliverChildBuilderDelegate( (context, index) {
                return QuoteContainer(
                    size: size, quote: quotesNotifier.quotes[index]);
              },
                  childCount: quotesNotifier.quotes.length)
              );
            }


            return CustomScrollView(
              slivers: <Widget>[
                CustomAppBar(),
                if(quotesNotifier.searchQuery?.isNotEmpty ?? false)
                  SliverToBoxAdapter(child: Container(
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(child: Text("Search results for ${quotesNotifier.searchQuery}",
                          style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)),
                      ],
                    ),
                  )),

                SliverToBoxAdapter(child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Wrap(
                        spacing: 25,
                        runSpacing: 25,
                        children: [
                          for (var status in QuotesNotifier.statuses)
                            ChoiceChip(
                              elevation: 2,
                              padding: const EdgeInsets.all(5),
                              label: Text(status),
                              selected: QuotesNotifier.selectedQuoteStatus == status ,
                              onSelected:(isSelected){
                                quotesNotifier.setStatus(status);
                              },
                            ),
                        ]
                    ),
                  ),
                ),
                ),

                sliverContent,
                if(quotesNotifier.hasFetchedInitialData)
                  SliverToBoxAdapter(
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 300 ),
                        child:buildNumberPagination(quotesNotifier),
                      ),
                    ),
                  ),


              ],
            );
          }
      ),
    );
  }

  /// Returns a state cleared widget if [needRebuilt] is true.
  NumberPaginator buildNumberPagination(QuotesNotifier bookingsNotifier) {
    return bookingsNotifier.needRebuilt? NumberPaginator(
      key: UniqueKey(),
      buttonSelectedBackgroundColor: Colors.green,
      numberPages: bookingsNotifier.maxPageCount,
      onPageChange: (int index) {
        bookingsNotifier.fetchData(pageNumber: index+1);
      },
    ) : NumberPaginator(
      buttonSelectedBackgroundColor: Colors.green,
      numberPages: bookingsNotifier.maxPageCount,
      onPageChange: (int index) {
        bookingsNotifier.fetchData(pageNumber: index+1);
      },
    ) ;
  }

}


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:jemma/providers/bookings.dart';
import 'package:jemma/utils/responsive.dart';
import 'package:jemma/widgets/bookings/booking_container.dart';
import 'package:jemma/widgets/bookings/custom_app_bar.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../widgets/nav_bar.dart';

/// A screen which shows the list of [Booking]s.
///
///  TODO: Refactor to reduce redundancies between quote and bookings if possible
class Bookings extends StatelessWidget {
  Bookings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      drawer: NavBar(),
      body: Consumer<BookingsNotifier>(
          builder: (context, bookingsNotifier, child) {
        Widget sliverContent;
        logger.d("building");
        if (bookingsNotifier.hasError) {
          logger.e("error");
          sliverContent = SliverToBoxAdapter(
              child: SizedBox(
                  height: 15.ph(size),
                  child: const Center(child: Text("Something went wrong!"))));
        } else if (!bookingsNotifier.hasFetchedInitialData ||
            bookingsNotifier.isLoading) {
          sliverContent = const SliverToBoxAdapter(
            child: SizedBox(
                height: 100, child: Center(child: CircularProgressIndicator())),
          );
          if (!bookingsNotifier.hasFetchedInitialData) {
            bookingsNotifier.fetchData();
          }
        } else {
          sliverContent = SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return BookingContainer(
                size: size, booking: bookingsNotifier.bookings[index]);
          }, childCount: bookingsNotifier.bookings.length));
        }

        return CustomScrollView(
          slivers: <Widget>[
            CustomAppBar(),
            if (bookingsNotifier.searchQuery?.isNotEmpty ?? false)
              SliverToBoxAdapter(
                  child: Container(
                margin: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                        child: Text(
                      "Search results for ${bookingsNotifier.searchQuery}",
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    )),
                  ],
                ),
              )),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Wrap(spacing: 25, runSpacing: 25, children: [
                    for (var status in BookingsNotifier.statuses)
                      ChoiceChip(
                        elevation: 2,
                        padding: const EdgeInsets.all(5),
                        label: Text(status),
                        selected:
                            BookingsNotifier.selectedBookingStatus == status,
                        onSelected: (isSelected) {
                          bookingsNotifier.setStatus(status);
                        },
                      ),
                  ]),
                ),
              ),
            ),
            sliverContent,
            if (bookingsNotifier.hasFetchedInitialData)
              SliverToBoxAdapter(
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: buildNumberPagination(bookingsNotifier),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  /// Returns a state cleared widget if [needRebuilt] is true.
  NumberPaginator buildNumberPagination(BookingsNotifier bookingsNotifier) {
    return bookingsNotifier.needRebuilt
        ? NumberPaginator(
            key: UniqueKey(),
            config: const NumberPaginatorUIConfig(
                buttonSelectedBackgroundColor: Colors.green),
            //buttonSelectedBackgroundColor: Colors.green,
            numberPages: bookingsNotifier.maxPageCount,
            onPageChange: (int index) {
              bookingsNotifier.fetchData(pageNumber: index + 1);
            },
          )
        : NumberPaginator(
            config: const NumberPaginatorUIConfig(
                buttonSelectedBackgroundColor: Colors.green),
            //buttonSelectedBackgroundColor: Colors.green,
            numberPages: bookingsNotifier.maxPageCount,
            onPageChange: (int index) {
              bookingsNotifier.fetchData(pageNumber: index + 1);
            },
          );
  }
}

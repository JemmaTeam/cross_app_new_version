import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jemma/enums/booking_status.dart';
import 'package:jemma/enums/sort_order.dart';
import 'package:jemma/models/booking.dart';
import 'package:jemma/models/pagination_data.dart';
import 'package:jemma/models/user.dart';
import 'package:jemma/models/util.dart';
import 'package:jemma/providers/util.dart';
import 'package:jemma/repository.dart';
import 'package:jemma/screens/util.dart';
import 'package:recase/recase.dart';

import '../main.dart';

/// Observable which handles the logic for all Bookings screen.
class BookingsNotifier extends ChangeNotifier with PaginationSupport{

  final List<Booking> _bookings = [];
  final List<SortField> _sortOrders =[];
  bool hasError = false;
  bool isEmpty = false;
  late String url;
  String? searchQuery;

  // For number pagination ui out of order bug
  bool needRebuilt = false;

  static final UnmodifiableListView<String> sortingFields  = UnmodifiableListView(["none","quote__price","time_stamp"]);
  static final UnmodifiableListView<String> statuses = UnmodifiableListView(["All"]+BookingStatus.values.map((status) => status.toStyledString()).toList());

  static  late String selectedBookingStatus = statuses.first;
  SortField? currentSortField;

  UnmodifiableListView<SortField>  get sortOrders => UnmodifiableListView(_sortOrders);
  UnmodifiableListView<Booking> get bookings => UnmodifiableListView(_bookings);

  @override
  fetchData( {String? url,int? pageNumber, Duration delay = const Duration(seconds: 2),String? sortOrderQuery }) {

    logger.d("fetching");

    if(!isLoading){
      isLoading = true;
      notifyListeners();
    }
    if(paginationData != null) {
      if (pageNumber!= null) {
        assert(pageNumber<=maxPageCount,"Implementation asks for page content which does not exist!");
      }
    }


    url = Repository().getListUrl(pageNumber: pageNumber,
        searchQuery: searchQuery,sortOrderFieldQuery: currentSortField,
        bookingStatus: parseBookingStatusString(selectedBookingStatus.constantCase),
        screen: ListScreen.bookings);
    logger.d(url);
    Future.delayed(delay, () => _getAllBookings(url!))
        .then((fetchedBookings) {
      _bookings.clear();
      _bookings.addAll(fetchedBookings);
      isLoading = false;

    }).catchError((onError) {
      isLoading = false;
      hasError = true;
    }).whenComplete(() {
      isEmpty = _bookings.isEmpty;
      isLoading = false;
      hasFetchedInitialData = true;
      notifyListeners();
      needRebuilt = false;
    });
  }

  /// Returns all bookings associated with user.
  Future<List<Booking>> _getAllBookings(String url) async {
    // TODO need to insert tokens and create an appropriate URL
    final response = await Repository().getResponse(url);

    if (response.statusCode == 200) {
      if(response.body.isNotEmpty) {
        paginationData =  PaginationData.fromJson(jsonDecode(response.body));

        var responseData = paginationData?.results ?? [];
        List<Booking> bookings = [];
        for (var data in responseData){
          bookings.add(Booking.fromJson(data));
        }

        return bookings;
      }
    }

    paginationData = PaginationData.empty();
    return [];

  }


  void search(String summary) {
    needRebuilt = true;
    searchQuery = summary;
    fetchData();
  }

  void setStatus(String status) {
    needRebuilt = true;
    assert(statuses.contains(status),"Wrong status");
    selectedBookingStatus = status;
    notifyListeners();
    fetchData();
  }

  void clearSearch() {
    needRebuilt = true;
    searchQuery = null;
    notifyListeners();
    fetchData();
  }

  void setSortingData(SortOrder? sortOrder, String? sortingField){
    needRebuilt = true;
    assert(sortingFields.contains(sortingField),"Wrong sortingField");

    currentSortField =  (sortingField == BookingsNotifier.sortingFields.first ||
        sortingField == null) && sortOrder== null ?  SortField.none() :SortField(sortingField!,sortOrder!);

    notifyListeners();
    fetchData();

  }

}
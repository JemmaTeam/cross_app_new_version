import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jemma/enums/booking_status.dart';
import 'package:jemma/enums/quote_status.dart';
import 'package:jemma/enums/sort_order.dart';
import 'package:jemma/models/pagination_data.dart';
import 'package:jemma/models/quote.dart';
import 'package:jemma/models/user.dart';
import 'package:jemma/models/util.dart';
import 'package:jemma/providers/util.dart';
import 'package:jemma/repository.dart';
import 'package:jemma/screens/util.dart';
import 'package:recase/recase.dart';

import '../main.dart';

/// Observable which handles the logic for all Bookings screen.
class QuotesNotifier extends ChangeNotifier with PaginationSupport{

  final List<Quote> _quotes = [];
  final List<SortField> _sortOrders =[];
  bool hasError = false;
  bool isEmpty = false;
  late String url;
  User? user;
  String? searchQuery;

  // For number pagination ui out of order bug
  bool needRebuilt = false;

  static final UnmodifiableListView<String> sortingFields  = UnmodifiableListView(["none","quote__price","time_stamp"]);
  static final  UnmodifiableListView<String> statuses = UnmodifiableListView(["All"]+QuoteStatus.values.map((status) => status.toStyledString()).toList());

  static  late String selectedQuoteStatus = statuses.first;
  SortField? currentSortField;

  UnmodifiableListView<SortField>  get sortOrders => UnmodifiableListView(_sortOrders);
  UnmodifiableListView<Quote> get quotes => UnmodifiableListView(_quotes);

  @override
  fetchData( {String? url,int? pageNumber, Duration delay = const Duration(seconds: 2),String? sortOrderQuery }) {

    user ??= Repository().user.value;

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

    url = Repository().getListUrl(
        pageNumber: pageNumber,
        searchQuery: searchQuery,sortOrderFieldQuery: currentSortField,
        quoteStatus: parseQuoteStatusString(selectedQuoteStatus.constantCase),
        screen: ListScreen.quotes);
    logger.d("Quote list");
    logger.d(url);
    logger.d(selectedQuoteStatus.constantCase);
    logger.d(parseBookingStatusString(selectedQuoteStatus.constantCase));

    Future.delayed(delay, () => _getAllQuotes(url!))
        .then((fetchedQuotes) {
      _quotes.clear();
      _quotes.addAll(fetchedQuotes);
      isLoading = false;

    }).catchError((onError) {
      isLoading = false;
      hasError = true;
      logger.e(onError);
    }).whenComplete(() {
      isEmpty = _quotes.isEmpty;
      isLoading = false;
      hasFetchedInitialData = true;
      notifyListeners();
      needRebuilt = false;
    });
  }

  /// Returns all bookings associated with user.
  Future<List<Quote>> _getAllQuotes(String url) async {
    // TODO need to insert tokens and create an appropriate URL
    final response = await Repository().getResponse(url);

    if (response.statusCode == 200) {
      if(response.body.isNotEmpty) {
        paginationData =  PaginationData.fromJson(jsonDecode(response.body));

        var responseData = paginationData?.results ?? [];
        List<Quote> quotes = [];
        for (var data in responseData){
          quotes.add(Quote.fromJson(data));
        }

        return quotes;
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
    selectedQuoteStatus = status;
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

    currentSortField =  (sortingField == QuotesNotifier.sortingFields.first ||
        sortingField == null) && sortOrder== null ?  SortField.none() :SortField(sortingField!,sortOrder!);

    notifyListeners();
    fetchData();

  }

}
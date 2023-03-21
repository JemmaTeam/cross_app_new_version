import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class QuoteFormNotifier extends ChangeNotifier {
  // TODO: To change local static IP to REST-ful API hosting server's IP.
  final baseURL = 'http://127.0.0.1:8000/';

  // TODO: Add response logger

  final List<String> _jobTypes = [];
  UnmodifiableListView<String> get jobTypes => UnmodifiableListView(_jobTypes);

  /// Returns { jobType: price } associated with a tradie
  // @override
  // void getTypes(String tradie) async{
    // String url = baseURL + 'listed-jobs/get-types/' + tradie
    // final url = Uri.parse(baseURL + 'listed-jobs/get-types/' + tradie);
    // await http.get(url,
    //     headers: {'content-type': 'application/json'},
    // ).then((response) {
    //   if (response.statusCode == 200) {jobTypes = jsonDecode(response.body);}
    // }).catchError((onError) {
    // }).whenComplete(() {
    //   notifyListeners();
    // });
  // }
  //
  // Future<List<String>> _getTypes(string url) async {
  //   final response = await http.get();
  // }

  /// Post and create a new code using [tradie] tradie's id and [customer] customer's id
  void postQuote(String tradie, String customer, String category,
      String summary, String description,
      void Function(String resultMessage) resultHandler) async {
    var resultMessage = '';
    final url = Uri.parse(baseURL + 'quotes/create-quote/');
    await http.post(url,
      headers: {'content-type': 'application/json'},
      body: jsonEncode({
        'tradie': tradie, 'customer': customer, 'category': category,
        'customer_summary': summary, 'customer_description': description
      })
    ).then((response) {
      if (response.statusCode == 200) {resultMessage = 'Quote submitted';}
      else {resultMessage = 'Invalid submission';}
    }).catchError((onError) {
      resultMessage = 'Error during submission';
    }).whenComplete(() {
      notifyListeners();
      resultHandler(resultMessage);
    });
  }

}
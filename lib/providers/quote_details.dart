import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:jemma/enums/quote_status.dart';
import 'package:jemma/enums/user_type.dart';
import 'package:jemma/models/quote.dart';
import 'package:jemma/screens/util.dart';

import '../main.dart';
import '../repository.dart';

/// Observable which handles logic of the booking screen.
class QuoteDetailsNotifier extends ChangeNotifier{

  bool isLoading = true;
  Quote? quote;
  bool isLoaded = false;
  bool isError = false;
  String? reason;
  void setQuote(Quote quote) {
    if(!isLoaded) {
      this.quote = quote;
      _fetchQuoteDetail();
    }
  }

  /// Returns all bookings associated with user.
  _fetchQuoteDetail() async {
    if(quote != null && !isLoaded) {
      var quoteId = quote!.id.toString();
      final url = Repository().getDetailUrl(screen: DetailScreen.quotes, id: quoteId);
      logger.d(url);
      final response = await Repository().getResponse(url);

      if(response.statusCode == 200 && response.body.isNotEmpty) {
        quote = Quote.fromJson(jsonDecode(response.body));
        isLoading = false;
        isLoaded = true;
        notifyListeners();
      }
      else{
        //TODO
        isError = true;
        notifyListeners();
      }
    }
  }


  /// Declines a given quote, given that the quote is not null and details of the quote has been already loaded.
  decline(String reason, void Function(String resultMessage) resultHandler) async{
    logger.d("Called");
    if(quote != null && isLoaded) {
      var quoteId = quote!.id.toString();
      this.reason = reason;
      String resultMessage = "";
      final url = Repository().getDetailUrl(
          screen: DetailScreen.quotes, id: quoteId) + "decline/";
      await http.Client().post(
          Uri.parse(url), headers: Repository().getHeader(),
          body: jsonEncode({"reason": reason})).then((response)
      {
        if (response.statusCode == 200){
          // TODO show notification
          if(Repository().user.value!.userType == UserType.customer){
            quote?.status = QuoteStatus.customerDeclined;
          }
          else{
            quote?.status = QuoteStatus.tradieDeclined;
          }
          logger.d(reason);
          quote?.declineReason = reason;
        }
        else
        {
          resultMessage = "Oops, something went wrong!";
        }
      }).catchError((onError) {
        resultMessage = "Oops, something went wrong!";
      }).whenComplete(() {
        logger.d("Done");
        resultMessage = "Successfully declined";
        notifyListeners();
        resultHandler(resultMessage);

      });
    }
  }


  /// Returns if the quote is declined or not.
  bool isDeclined(){
    return quote?.status == QuoteStatus.tradieDeclined || quote?.status == QuoteStatus.customerDeclined;
  }
}



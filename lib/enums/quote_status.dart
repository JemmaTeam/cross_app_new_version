import 'package:recase/recase.dart';

/// Status of a [Quote].
enum QuoteStatus{
  given,
  tradieDeclined,
  customerDeclined,
  inPersonCheckNeeded,
  pending
}

QuoteStatus? parseQuoteStatusString(String status){
  for (var quoteStatus in QuoteStatus.values){
    if(quoteStatus.toSimpleString().constantCase == status.constantCase){
      return quoteStatus;
    }
  }
  return null;
}


extension QuoteStatusUtil on QuoteStatus{
  String toSimpleString() => toString().split('.').last.constantCase;
  String toStyledString() => toSimpleString().sentenceCase;
}
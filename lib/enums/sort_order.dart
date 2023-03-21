import 'package:recase/recase.dart';

/// Sorting order related utilities
enum SortOrder{
  ascending,
  descending,
  none
}

extension SortOrderStringUtil on String{
  SortOrder toSortOrder() {
    if (this == '+' || toUpperCase() == "ASCENDING"){
      return SortOrder.ascending;
    }
    else if( this == '-'|| toUpperCase() == "DESCENDING"){
      return SortOrder.descending;
    }
    return SortOrder.none;

  }
}

extension SortOrderUtil on SortOrder{
  toSimpleString() => toString().split('.').last.constantCase;

  toStyledString() => toString().split('.').last.sentenceCase;

  toUrlString(){
    switch(this){
      case SortOrder.ascending:
        return '';

      case SortOrder.descending:
        return '-';

      case SortOrder.none:
        return '';
    }
  }
}
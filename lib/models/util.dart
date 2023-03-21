import 'package:flutter/material.dart';
import 'package:jemma/enums/sort_order.dart';
import 'package:recase/recase.dart';


/// Sorting  related utilities
class SortField{

  String field;
  SortOrder order;
  SortField(this.field,[this.order = SortOrder.descending]);

  SortField.none({this.field = "",this.order = SortOrder.none});

 static Map<SortOrder,IconData> defaultSortOrderIcon = {SortOrder.ascending:Icons.arrow_upward,SortOrder.descending:Icons.arrow_downward};


}

extension SortFieldUtil on SortField{
  String toUrlString() => order.toUrlString() + field;
}

extension SortFieldStringUtil on String{
  /// Note: Query URL fields which are foreign key are have __. Example:
  /// For a job; quote__price is an order by url query param.
  String toSortFieldStyledString() => split('__').last.sentenceCase;

}
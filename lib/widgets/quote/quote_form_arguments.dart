import 'package:flutter/material.dart';

/// from search result,
/// pass [tradieId] and [customerId] arguments to quote form
class QuoteFormArguments {
  final String tradieId;
  final String customerId;

  QuoteFormArguments(this.tradieId, this.customerId);
}
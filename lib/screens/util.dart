import 'package:recase/recase.dart';

enum ListScreen {
  bookings,
  appointment_details,
  quotes
}


extension DetailScreenUtil on DetailScreen{
  String toSimpleString() => toString().split('.').last.constantCase;
  String toStyledString() => toSimpleString().sentenceCase;
}

enum DetailScreen {
  bookings,
  appointment_details,
  quotes
}
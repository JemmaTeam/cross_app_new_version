import 'package:flutter/cupertino.dart';
import 'package:jemma/providers/booking_details.dart';
import 'package:jemma/providers/bookings.dart';
import 'package:jemma/providers/login.dart';
import 'package:jemma/providers/quotes.dart';
import 'package:jemma/providers/quote_details.dart';
import 'package:jemma/providers/result.dart';
import 'package:jemma/screens/booking_details.dart';
import 'package:jemma/screens/bookings.dart';
import 'package:jemma/screens/calendar.dart';
import 'package:jemma/screens/chat_home_page.dart';
import 'package:jemma/screens/contact_us.dart';
import 'package:jemma/screens/dashboard.dart';
import 'package:jemma/screens/help.dart';
import 'package:jemma/screens/home.dart';
import 'package:jemma/screens/login.dart';
import 'package:jemma/screens/profile.dart';

import 'package:jemma/screens/quote_form.dart';
import 'package:jemma/screens/quotes.dart';
import 'package:jemma/screens/quote_details.dart';
import 'package:jemma/screens/result.dart';
import 'package:jemma/screens/signup.dart';
import 'package:provider/provider.dart';

/// Jemma app screens.
enum Screen {
  home,
  login,
  profile,
  quotes,
  quoteDetails,
  quoteForm,
  dashboard,
  bookings,
  result,
  signup,
  signup_customer,
  signup_tradesperson,
  bookingDetails,
  contactUs,
  help,
  calendar,
  chat_home_page,
}

extension ScreenUtil on Screen {
  /// Given a Screen, returns an appropriate URL;
  ///
  /// Example: bookingsDetail -> /bookings-details.
  /// Regex from: https://stackoverflow.com/a/53719052/11200630
  String getURL() {
    if (this == Screen.home) {
      return "/";
    }
    return toSimpleString()
        .split(RegExp(r"(?=[A-Z])"))
        .reduce((value, element) => "/" + value + "-" + element.toLowerCase());
  }

  /// Returns the Screen widget when a Screen is given.
  ///
  /// Note: Since enum type is used, switch case detects missing cases.
  Widget getScreenWidget() {
    switch (this) {
      case Screen.login:
        return ChangeNotifierProvider(
            create: (context) => LoginNotifier(), child: Login());
      case Screen.profile:
        return Profile();
      case Screen.quotes:
        return ChangeNotifierProvider(
            create: (context) => QuotesNotifier(), child: Quotes());
      case Screen.quoteDetails:
        return ChangeNotifierProvider(
            create: (context) => QuoteDetailsNotifier(), child: QuoteDetails());
      case Screen.bookingDetails:
        return ChangeNotifierProvider(
            create: (context) => BookingDetailsNotifier(),
            child: BookingDetails());
      case Screen.quoteForm:
        return ChangeNotifierProvider(
            create: (context) => ResultNotifier(), child: QuoteForm());
      case Screen.dashboard:
        return Dashboard();
      case Screen.bookings:
        return ChangeNotifierProvider(
            create: (context) => BookingsNotifier(), child: Bookings());
      case Screen.result:
        return ChangeNotifierProvider(
            create: (context) => ResultNotifier(), child: Result());
      case Screen.contactUs:
        return ContactUs();
      case Screen.help:
        return Help();
      case Screen.home:
        return Home();
      case Screen.calendar:
        return Calendar();
      case Screen.signup:
        return Signup();
      case Screen.signup_customer:
        return SignupStage2(signupOf: SignupOf.customer);
      case Screen.signup_tradesperson:
        return SignupStage2(signupOf: SignupOf.tradesperson);
      case Screen.chat_home_page:
        return ChatHomePage();
    }
  }

  /// Converts default enum string to a simpler version.
  ///
  /// Example: Screen.home -> home
  String toSimpleString() {
    return toString().split('.').last;
  }

  /// Converts a default enum string to a app suitable name.
  ///
  /// Example: Screen.home -> Home
  String toStyledString() {
    var styledString = toSimpleString()
        .split(RegExp(r"(?=[A-Z])"))
        .reduce((value, element) => value + " " + element);
    return styledString[0].toUpperCase() + styledString.substring(1);
  }
}

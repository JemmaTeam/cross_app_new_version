


import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:jemma/enums/booking_status.dart';
import 'package:jemma/screens/util.dart';
import 'enums/quote_status.dart';
import 'enums/user_type.dart';
import 'main.dart';
import 'models/user.dart';
import 'models/util.dart';
import 'package:recase/recase.dart';


/// Single source of truth.
///
/// Idea of using factory constructor from this SO answer:
/// https://stackoverflow.com/a/55348216/11200630
class Repository{

  // Persistent storage related
  static const String hiveEncryptedBoxName = "appEncryptedBox";
  static const String hiveSecureKey = "secureKey";
  static const String hiveUserBox = "user";

  // Local host URL
  static const baseUrl = "http://127.0.0.1:8000";
  // Deploy dev URL
  //static const baseUrl = "https://jemma-dev-backend.herokuapp.com";

  // Android emulator URL
  // static const baseUrl = "http://10.0.2.2:8000";

  /// Strings which are part of URLs
  static const pageUrlQueryParameter = "page=";
  static const searchUrlQueryParameter = "search=";
  static const sortingOrderUrlQueryParameter = "ordering=";
  static const statusUrlQueryParameter = "status=";
  static const String tradieBookingName = "jobs";
  static const String customerBookingName = "orders";
  static const String quoteName = "quotes";


  ValueNotifier<User?> user = ValueNotifier(null);

  bool get isLoggedIn  => user.value != null;

  Repository._privateConstructor();

  /// Returns a user centric booking name.
  ///
  /// i.e, orders for customer and jobs for tradie
  /// Setting [isStyled] to true will give outputs like "Job" and "Order".
  String getBookingName({bool? isStyled }) {
    String? userCentricBookingName;

    if (user.value?.userType != null) {
      userCentricBookingName = user.value?.userType == UserType.tradie
          ? tradieBookingName
          : customerBookingName;
    }
    if (isStyled == true && userCentricBookingName != null){
      userCentricBookingName = userCentricBookingName.substring(0,userCentricBookingName.length-1).titleCase;
    }

    if(userCentricBookingName == null){
      userCentricBookingName = "booking";
      userCentricBookingName = isStyled == true ? userCentricBookingName.titleCase : userCentricBookingName+ 's';
    }

    logger.d(userCentricBookingName);
    return  userCentricBookingName;
  }

  static final Repository _instance = Repository._privateConstructor();

  factory Repository() => _instance;

  String getQueryOperator(String queryParameter) => queryParameter.isEmpty ? '?':'&';

  String getDetailUrl({required DetailScreen screen, required String id}) {
    // TODO Need to differentiate user type and allocate separate urls for it in the backend.
    return "$baseUrl/${screen.toSimpleString().toLowerCase()}/$id/";
  }

  /// Returns a suitable list backend url which considers pagination, search and order based filtering.
  ///
  /// Note: Only supports those which are declared as a [ListScreen] enum value.
  String getListUrl( {required ListScreen screen,String? searchQuery, int? pageNumber,QuoteStatus? quoteStatus, BookingStatus? bookingStatus, SortField? sortOrderFieldQuery} ){

    if (user.value !=null) {
      int? userId = user.value?.id;
      String? userType = user.value?.userType.toSimpleString().toLowerCase();

      String queryParameters = "";
      String url = "";

      queryParameters = getQueryParamUrl(searchQuery, pageNumber, sortOrderFieldQuery);

      if(screen == ListScreen.bookings) {
        if (bookingStatus != null) {
          queryParameters += getQueryOperator(queryParameters) + statusUrlQueryParameter + bookingStatus.toSimpleString();
        }

        url = "$baseUrl/${userType}s/$userId/${getBookingName()}/$queryParameters";
      }

      if (screen == ListScreen.quotes) {
        if(quoteStatus!=null) {
          queryParameters += getQueryOperator(queryParameters) + statusUrlQueryParameter + quoteStatus.toSimpleString();
        }
        url = "$baseUrl/${userType}s/$userId/$quoteName/$queryParameters";
      }

      logger.d(url);
      return url;
    }
    return "";
  }


  /// Returns a suitable query parameter string, which can be used as part of the url.
  ///
  /// Given the [searchQuery], [pageNumber] and [sortOrderFieldQuery], if null then they would not be included.
  String getQueryParamUrl(String? searchQuery, int? pageNumber,SortField? sortOrderFieldQuery){
    String queryParameters = "";

    if (searchQuery != null) {
      queryParameters+= getQueryOperator(queryParameters) + searchUrlQueryParameter+searchQuery;
    }
    if (sortOrderFieldQuery != null){
      logger.d(sortOrderFieldQuery.toUrlString());
      queryParameters+= getQueryOperator(queryParameters)  + sortingOrderUrlQueryParameter + sortOrderFieldQuery.toUrlString();
    }
    if( pageNumber !=null){
      queryParameters+= getQueryOperator(queryParameters)  + pageUrlQueryParameter + pageNumber.toString();
    }
    return queryParameters;
  }

  /// Assumes that user is logged in already .
  Map<String,String> getHeader() =>
      {"Content-type":"application/json","Authorization":"Token ${user.value!.token}"};

  /// Assumes that user is logged in already .
  Future<Response> getResponse(String url) => http.get(
      Uri.parse(url),
      headers: {"Authorization":"Token ${user.value!.token}"});


  /// Initialises persistently stored [User] instance, which is used to identify user.
  /// Some boilerplate code from the official Hive docs and the idea to use flutter_secure_storage is from there as well.
  /// https://docs.hivedb.dev/#/advanced/encrypted_box?id=encrypted-box
  void init() async {
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(UserTypeAdapter());

    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    var containsEncryptionKey = await secureStorage.containsKey(key: hiveSecureKey);
    if (!containsEncryptionKey) {
      var key = Hive.generateSecureKey();
      await secureStorage.write(key: hiveSecureKey, value: base64UrlEncode(key));
    }
    String encryptedKey = await secureStorage.read(key: hiveSecureKey) ??"";
    assert (encryptedKey.isNotEmpty , "Something wrong with hive/flutter_secure_storage!");
    var encryptionKey = base64Url.decode(encryptedKey);

    Hive.openBox(hiveEncryptedBoxName,encryptionCipher: HiveAesCipher(encryptionKey)).then((appBox) {
      User? user = appBox.get(hiveUserBox);
      if (user !=null){
        this.user.value = user;
        logger.d(user.toString());
      }
    } ).whenComplete((){
      logger.d("Done");
    }
    );
  }
}

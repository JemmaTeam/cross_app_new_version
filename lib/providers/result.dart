import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jemma/models/tradie.dart';
import 'package:jemma/enums/suburb.dart';
import 'package:jemma/enums/job_type.dart';

class ResultNotifier extends ChangeNotifier {

  //<a href="https://imgbb.com/"><img src="https://i.ibb.co/BNXG7Wt/tradie5.jpg" alt="tradie5" border="0"></a>
  // <a href="https://imgbb.com/"><img src="https://i.ibb.co/RNWGk01/tradie4.jpg" alt="tradie4" border="0"></a>
  // <a href="https://imgbb.com/"><img src="https://i.ibb.co/M1n2Z7H/tradie3.jpg" alt="tradie3" border="0"></a>
  // <a href="https://imgbb.com/"><img src="https://i.ibb.co/r2mm9Kv/tradie2.jpg" alt="tradie2" border="0"></a>
  // <a href="https://imgbb.com/"><img src="https://i.ibb.co/1KMw04W/tradie1.jpg" alt="tradie1" border="0"></a>


  //<a href="https://imgbb.com/"><img src="https://i.ibb.co/SQdtLT1/sadg.jpg" alt="sadg" border="0"></a>
  // <a href="https://imgbb.com/"><img src="https://i.ibb.co/xfRKV5N/download.png" alt="download" border="0"></a>
  // <a href="https://imgbb.com/"><img src="https://i.ibb.co/kMJ6ynD/download.jpg" alt="download" border="0"></a>
  // <a href="https://imgbb.com/"><img src="https://i.ibb.co/h1hRrB8/dg.jpg" alt="dg" border="0"></a>
  // <a href="https://imgbb.com/"><img src="https://i.ibb.co/XLcv6hg/as.jpg" alt="as" border="0"></a>

  List<Tradie> tempTradies = [
    Tradie(0,
        "Patrick",
        "",
        "Fixing electricity related problems since 2001.",
        3.5,"",
        "https://i.ibb.co/BNXG7Wt/tradie5.jpg",
        null, null, null, null, null,null, null, null,[
          "https://i.ibb.co/SQdtLT1/sadg.jpg",
          "https://i.ibb.co/kMJ6ynD/download.jpg",
          "https://i.ibb.co/xfRKV5N/download.png"
        ]),
    Tradie(0,
        "Tyrus",
        "",
        "Always ready to help.",
        3.5,"",
        "https://i.ibb.co/RNWGk01/tradie4.jpg",
        null, null, null, null, null,null, null, null,[
          "https://i.ibb.co/SQdtLT1/sadg.jpg",
          "https://i.ibb.co/h1hRrB8/dg.jpg",
          "https://i.ibb.co/XLcv6hg/as.jpg"
        ]),
    Tradie(0,
        "Oliver",
        "",
        "One of the finest plumber in ACT.",
        3.5,"",
        "https://i.ibb.co/M1n2Z7H/tradie3.jpg",
        null, null, null, null, null,null, null, null,[
          "https://i.ibb.co/h1hRrB8/dg.jpg",
          "https://i.ibb.co/kMJ6ynD/download.jpg",
          "https://i.ibb.co/xfRKV5N/download.png"
        ]),
    Tradie(0,
        "Peter",
        "",
        "Part time tradie, willing to fix people's problems",
        3.5,"",
        "https://i.ibb.co/r2mm9Kv/tradie2.jpg",
        null, null, null, null, null,null, null, null,[
          "https://i.ibb.co/SQdtLT1/sadg.jpg",
          "https://i.ibb.co/XLcv6hg/as.jpg",
          "https://i.ibb.co/xfRKV5N/download.png"
        ]),
    Tradie(0,
        "Stanley",
        "",
        "Fixing electricity related problems since 2001.",
        3.5,"",
        "https://i.ibb.co/1KMw04W/tradie1.jpg",
        null, null, null, null, null,null, null, null,[
          "https://i.ibb.co/SQdtLT1/sadg.jpg",
          "https://i.ibb.co/h1hRrB8/dg.jpg",
          "https://i.ibb.co/XLcv6hg/as.jpg"
        ]),

  ];
  late List<Tradie> tradies = List<Tradie>.generate(20, (int index) {
    if (index <5){
      return tempTradies[index];
    }
    else{
      return tempTradies[Random().nextInt(5)];
    }

  });

  late final List<Tradie> fetchList;

  int getLength() {
    return tradies.length;
  }

  final List<String> imageList = [
    "assets/images/list.png",
    "assets/images/money.png",
    "assets/images/organize.png",
    "assets/images/profile.png",
    "assets/images/review.png",
  ];

  /// TODO Fill in more details, create enums etc, do async (Leo)
  Future<List<Tradie>> fetchTradies(Suburb suburb, JobType jobType) async {
    var fetchTradies = await getFetchList(suburb, jobType);
    notifyListeners();
    return fetchTradies;
  }

  getFetchList(Suburb suburb, JobType jobType) {
    for (var tradie in tradies) {
      fetchList.clear();
      if (tradie.suburb == suburb && tradie.jobType == jobType) {
        fetchList.add(tradie);
      }
      return fetchList;
    }
  }
}

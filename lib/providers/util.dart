import 'package:jemma/models/pagination_data.dart';


/// Mixin which can be inherited most likely by ChangeNotifiers so to avoid boilerplate code.
mixin PaginationSupport{
  bool isLoading = true;
  PaginationData? paginationData;
  int currentPageNumber = 0;
  int get  maxPageCount => paginationData?.pageCount ==0 ? 1 : paginationData?.pageCount  ?? 1;
  fetchData({int pageNumber=0, Duration delay = const Duration(seconds: 2)});
  bool hasFetchedInitialData = false;

}



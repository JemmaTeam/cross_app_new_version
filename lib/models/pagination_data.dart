
/// Data class which holds the relevant pagination data.
class PaginationData{
  int count;
  int pageCount;
  List<dynamic>? results;
  String? nextPageUrl;
  String? previousPageUrl;
  PaginationData(this.count,this.pageCount,[this.results,this.nextPageUrl,this.previousPageUrl]);

  PaginationData.fromJson(Map<String, dynamic> json) :
        count = json["count"],
        results = json["results"],
        nextPageUrl = json["next"],
        previousPageUrl = json["previous"],
        pageCount = json["page_count"];

  @override
  String toString() {
    return 'PaginationData{count: $count, pageCount: $pageCount, results: $results, nextPageUrl: $nextPageUrl, previousPageUrl: $previousPageUrl}';
  }

  PaginationData.empty():
        pageCount=0,
        count=0;
}
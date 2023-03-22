import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:getwidget/components/carousel/gf_carousel.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:jemma/models/searchtradie.dart';
import 'package:jemma/models/tradie.dart';
import 'package:jemma/providers/result.dart';
import 'package:jemma/utils/constants.dart';
import 'package:jemma/utils/decorations.dart';
import 'package:jemma/utils/responsive.dart';
import 'package:jemma/widgets/home/search_bar.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../routes.dart';
import '../widgets/nav_bar.dart';

// TODO docstrings
/// Modified StaggeredGridView configurations based on the example provided in the package's Github repository.
/// https://pub.dev/packages/flutter_staggered_grid_view
class Result extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ResultState();
  }
}

class ResultState extends State<Result> {
  List dataList = <int>[];
  bool isLoading = false;
  int pageCount = 1;
  late ScrollController _scrollController;
  //late int lengthOfResults;// The length of the tradie list

  /// Search button which will be able initiate a search and assist in transitioning the screen to the result.
  Container _buildSearchButton(BuildContext context) {
    return Container(
      child: ElevatedButton.icon(
        onPressed: () {
          // TODO handle new search and add new args form the result screen dropdown container, prevent home screen form appearing.  (Robert)
          //Navigator.of(context).popAndPushNamed(Screen.result.getURL(),arguments: {"location":"Belconnen","job-type":"Electrician"});
          /// change popAndPushNamed to pushNamed, and the home page does not appear.
          ///
          Navigator.of(context).pushNamed(Screen.result.getURL(),
              arguments: {"location": "Belconnen", "job-type": "Electrician"});
        }, // TODO: Replace with search request
        icon: const Icon(
          Icons.search,
          color: Colors.black,
          size: 18,
        ),
        label: const Text(
          'Search',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(primary: kLogoColor, elevation: 2),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  final logger = Logger(
    printer: PrettyPrinter(),
  );

  @override
  Widget build(BuildContext context) {
    /// Receive the data in an Iterable<dynamic> TODO: it needs to retrieve data from search_bar
    Map? t = ModalRoute.of(context)!.settings.arguments as Map?;
    if (t != null) {
      var suburb = t.values;
    }

    final arguments = ModalRoute.of(context)?.settings.arguments as Map;

    logger.d(arguments);
    final size = MediaQuery.of(context).size;
    logger.d(size.width / 300);
    return Scaffold(
      appBar: AppBar(
        title: Text("Result"),
      ),
      drawer: NavBar(),
      body: SingleChildScrollView(
        // TODO ExpansionPanel not expanding problem; Fix widget tree (Rohan)

        child: Column(children: [
          // TODO make it more aligned to the wireframe ()
          Container(
            width: 40.pw(size),
            constraints: const BoxConstraints(minWidth: 275),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 35),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: defaultShadows,
              borderRadius: BorderRadius.circular(35),
            ),

            // Contains dropdownButtons + Search button
            child: OverflowBar(
              overflowAlignment: OverflowBarAlignment.center,
              spacing: 2.5.pw(size),
              overflowSpacing: 1.75.ph(size),
              children: [
                DropDownContainer(
                    topic: "Job type",
                    topicIconData: Icons.handyman,
                    dropDownContent: {}),
                _buildSearchButton(context)
              ],
            ),
          ),

          Center(
            child: Container(
              height: 90.ph(size),
              constraints: const BoxConstraints(maxWidth: 1080),
              child: Consumer<ResultNotifier>(
                  //builder: (context,resultNotifier,child) => StaggeredGrid.count(
                  builder: (context, resultNotifier, child) =>
                      StaggeredGridView.countBuilder(
                        // From Flutter docs: When this is true,the scroll view is scrollable
                        // even if it does not have sufficient content to actually scroll
                        primary: false,
                        controller: _scrollController,
                        itemCount: resultNotifier.tradies.length,
                        crossAxisCount: min((size.width / 300).floor(), 3),
                        crossAxisSpacing: 20,
                        addAutomaticKeepAlives: false,
                        mainAxisSpacing: 20,
                        itemBuilder: (context, index) => TradieContainer(
                            tradie: resultNotifier.tradies[index]),
                        // Something like weights
                        staggeredTileBuilder: (index) =>
                            const StaggeredTile.fit(1),
                      )),
            ),
          ),
        ]),
      ),
    );
  }

// void _scrollListener() {
//   if (_scrollController.offset >=
//       _scrollController.position.maxScrollExtent &&
//       !_scrollController.position.outOfRange) {
//     setState(() {
//       logger.d("comes to bottom $isLoading");
//       isLoading = true;
//
//       if (isLoading) {
//         logger.d("RUNNING LOAD MORE");
//
//         pageCount = pageCount + 1;
//
//         if (pageCount * 9 <= lengthOfResults){
//           addItemIntoLisT(pageCount);
//         }
//         else
//           for (int i= (pageCount * 9) - 9; i < lengthOfResults; i++)
//             dataList.add(i);
//         isLoading = false;
//       }
//     });
//   }
// }
//
// void addItemIntoLisT(var pageCount) {
//   for (int i = (pageCount * 9) - 9; i < pageCount * 9; i++) {
//     dataList.add(i);
//     isLoading = false;
//   }
// }
//
// @override
// void dispose() {
//   _scrollController.dispose();
//   super.dispose();
// }
}

class TradieContainer extends StatefulWidget {
  const TradieContainer({Key? key, required this.tradie}) : super(key: key);
  final Tradie tradie;
  @override
  _TradieContainerState createState() => _TradieContainerState(tradie: tradie);
}

class _TradieContainerState extends State<TradieContainer> {
  // TODO: Remove this once images can be fetched directly.
  late final List<String>? imageList = tradie.certificatesUrl;

  final Tradie tradie;
  _TradieContainerState({required this.tradie});

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    logger.d(tradie.profilePictureUrl);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: defaultShadows,
        color: Colors.white,
      ),
      constraints: const BoxConstraints(minWidth: 200),
      child: ExpansionTile(
        maintainState: true,
        onExpansionChanged: (value) {
          logger.d(value.toString());
          setState(() {
            isExpanded = value;
          });
        },
        title: Row(children: [
          Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    backgroundImage: Image.network(
                      tradie.profilePictureUrl ?? "",
                      loadingBuilder: (_, child, progress) {
                        if (progress == null) {
                          return child;
                        }
                        return const CircularProgressIndicator();
                      },
                    ).image,
                    radius: 25,
                  ),
                  Text(tradie.firstName ?? "First name"),
                  ElevatedButton(
                      onPressed: () {
                        logger.d("Pressed");
                      },
                      child: const Text("Get quote"))
                ]),
          ),
          Expanded(
            child: Column(children: [
              GFRating(
                onChanged: (value) {},
                value: 3.5,
                color: Colors.black,
                size: 22.5,
                borderColor: Colors.black,
              ),
              Text(tradie.description ?? "Description: [To be filled]",
                  style: const TextStyle(fontStyle: FontStyle.italic)),
            ]),
          ),
        ]),
        children: [
          Column(children: [
            // buildCarouselFeedbackRatings(imageList,size,isExpanded),
            const Text("Certificates",
                style: TextStyle(fontWeight: FontWeight.bold)),
            buildCertificatesCarousel(imageList, size, isExpanded),
          ])
        ],
      ),
    );
  }

  // TODO: Link backend image
  Widget buildCertificatesCarousel(
      List<String>? imageList, Size size, bool isExpanded) {
    return isExpanded
        ? GFCarousel(
            height: 10.ph(size),
            viewportFraction: 1,
            items: imageList != null
                ? imageList.map(
                    (url) {
                      logger.d(url.toString());
                      return Container(
                        margin: const EdgeInsets.all(5),
                        child: Image.network(
                          url,
                          loadingBuilder: (_, child, progress) {
                            if (progress == null) {
                              return child;
                            }
                            return const CircularProgressIndicator();
                          },
                        ),
                      );
                    },
                  ).toList()
                : [const Text("No certificates uploaded by tradie.")],
            onPageChanged: (index) {},
          )
        : Container();
  }

  /// Shows feedback and ratings of top jobs done by the tradie
// Widget buildCarouselFeedbackRatings(List<String> imageList, Size size, bool isExpanded) {
//   return isExpanded? GFCarousel(
//     height: 10.ph(size),
//     viewportFraction: 0.65,
//     pagination: true,
//     passiveIndicator: Colors.green,
//     activeIndicator: Colors.black,
//     autoPlay: true,
//     items: imageList.map(
//           (url) {
//         logger.d(url.toString());
//         return Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("Description"),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [Text("3"),Icon(Icons.star) ],
//             )
//           ],
//         );
//       },
//     ).toList(),
//     onPageChanged: (index) {},
//   ) : Container();
// }
}

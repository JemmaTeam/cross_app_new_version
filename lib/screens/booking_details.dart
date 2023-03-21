import 'package:flutter/material.dart';
import 'package:jemma/enums/user_type.dart';
import 'package:jemma/models/booking.dart';
import 'package:jemma/enums/booking_status.dart';
import 'package:jemma/providers/booking_details.dart';
import 'package:jemma/repository.dart';
import 'package:jemma/utils/constants.dart';
import 'package:jemma/utils/decorations.dart';
import 'package:jemma/widgets/image_viewer.dart';
import 'package:jemma/widgets/booking_details/custom_app_bar.dart';
import 'package:provider/provider.dart';
import '../widgets/nav_bar.dart';
import 'package:intl/intl.dart';

/// Shows the details of a selected [Booking]; Note: This screen can be accessed through Quote list page.
/// Expects the [Booking] to be sent as an arg via the Navigator.
class BookingDetails extends StatelessWidget {
  final UserType? userType = Repository().user.value!.userType;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // TODO: Prolly look into better ways of data transmission
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    final Booking initialBooking = arguments["booking"];

    return Scaffold(
      drawer: NavBar(),
      body: Consumer<BookingDetailsNotifier>(
        builder: (context, bookingDetailsNotifier, child) {
          Widget sliverContents;
          DateTime timeStamp =
              bookingDetailsNotifier.booking?.timeStamp ?? DateTime.now();

          bookingDetailsNotifier.setBooking(initialBooking);

          Booking? displayBooking = bookingDetailsNotifier.isLoading
              ? initialBooking
              : bookingDetailsNotifier.booking;

          if (bookingDetailsNotifier.isLoading) {
            sliverContents = SliverToBoxAdapter(
                child: Container(
                    height: size.height - CustomAppBar.height,
                    width: size.width,
                    child: const Center(child: CircularProgressIndicator())));
          } else {
            List<Widget> sliverContentsAsList = [
              Row(
                children: [
                  const Icon(Icons.info_rounded),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    elevation: 2,
                    padding: const EdgeInsets.all(5),
                    label: Text(bookingDetailsNotifier.booking?.status
                            ?.toStyledString() ??
                        "Status not available."),
                    selected: true,
                    onSelected: (isSelected) {},
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.home_repair_service),
                  const SizedBox(width: 10),
                  Text(bookingDetailsNotifier.booking?.quote?.jobType?.name ??
                      "Job type not available."),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.short_text),
                      const SizedBox(width: 5),
                      const Text("Summary",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(bookingDetailsNotifier.booking?.quote?.customerSummary ??
                      "Summary not available."),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.monetization_on),
                  const SizedBox(width: 10),
                  Text(
                      bookingDetailsNotifier.booking?.quote?.price.toString() ??
                          "Price not available."),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_pin),
                      const SizedBox(width: 5),
                      const Text("Address",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(bookingDetailsNotifier.booking?.quote?.address
                          ?.toStyledString() ??
                      "Address not available."),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.alarm),
                  const SizedBox(width: 10),
                  Text(bookingDetailsNotifier.booking?.timeStamp != null
                      ? DateFormat('dd-MM-yyyy hh:mm').format(timeStamp)
                      : "Time not available."),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.receipt_long),
                      const SizedBox(width: 5),
                      const Text("Description",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  buildUserContentWidget(bookingDetailsNotifier
                          .booking?.quote?.customerDescription ??
                      "Description not available."),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.note_add_rounded),
                      const SizedBox(width: 5),
                      const Text("Other notes",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
              Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.image),
                      const SizedBox(width: 5),
                      const Text("Images",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: defaultShadows,
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.all(20),
                    constraints:
                        const BoxConstraints(maxHeight: 200, maxWidth: 500),
                    child: ListView(
                      // TODO: To be filled with images provided in the quote.
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            showDialog<List<dynamic>>(
                                context: context,
                                builder: (_) => const ImageViewer());
                          },
                          child: Container(
                            width: 160.0,
                            child: const Image(
                              image: AssetImage("assets/images/organize.png"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: 20,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {},
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.red.shade400, elevation: 2)),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Finish",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                        primary: kLogoColor, elevation: 2),
                  )
                ],
              )
            ];

            sliverContents = SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Center(
                    child: Container(
                      constraints:
                          const BoxConstraints(maxWidth: 1080, minWidth: 200),
                      margin: const EdgeInsets.all(15),
                      child: sliverContentsAsList[index],
                    ),
                  );
                },
                // Or, uncomment the following line:
                childCount: sliverContentsAsList.length,
              ),
            );
          }
          return CustomScrollView(
            slivers: <Widget>[
              CustomAppBar(displayBooking ?? initialBooking),
              sliverContents,
            ],
          );
        },
      ),
    );
  }

  /// TODO: For future functionalities which wants to allow edits to the detail page.
  Widget buildUserContentWidget(String content,
      {TextEditingController? controller}) {
    if (userType == UserType.tradie) {
      return Text(content);
    }
    if (userType == UserType.customer && controller != null) {
      return TextFormField(
        controller: controller,
        keyboardType: TextInputType.multiline,
        readOnly: true,
        initialValue: content,
      );
    }
    return Text(content);
  }
}

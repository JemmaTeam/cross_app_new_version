import 'dart:math';

import 'package:flutter/material.dart';
import 'package:getwidget/components/carousel/gf_carousel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jemma/screens/home.dart';
import 'package:jemma/utils/decorations.dart';
import 'package:jemma/utils/responsive.dart';

/// Shows the reasons to choose Jemma, which will be part of the [Home] screen.
class WhyJemma extends StatefulWidget {
  WhyJemma({Key? key}) : super(key: key);

  @override
  _WhyJemmaState createState() => _WhyJemmaState();
}

class _WhyJemmaState extends State<WhyJemma> {
  bool _isCustomerSelected = true;

  @override
  Widget build(BuildContext context) {
    void _handleChange(bool newIsCustomerSelected) {
      setState(() {
        _isCustomerSelected = newIsCustomerSelected;
      });
    }

    final size = MediaQuery.of(context).size;

    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: 5.pw(size), vertical: 1.pw(size)),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: defaultShadows,
          borderRadius: BorderRadius.circular(40)),
      child: Column(children: [
        SizedBox(height: 0.75.ph(size)),
        OverflowBar(
          spacing: 25.pw(size),
          overflowSpacing: 1.5.ph(size),
          overflowAlignment: OverflowBarAlignment.center,
          children: [
            Row(mainAxisSize: MainAxisSize.min, children: [
              const Text('Why  ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              Text('Jemma',
                  style: GoogleFonts.parisienne(
                      fontSize: 20, fontWeight: FontWeight.w600)),
              const Text(' ?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600))
            ]),
            UserToggleButton(
                onSelectionChanged: _handleChange,
                isCustomerSelected: _isCustomerSelected)
          ],
        ),
        SizedBox(height: 2.5.ph(size)),
        Carousel(isCustomerSelected: _isCustomerSelected)
      ]),
    );
  }
}

/// Showcases user specific reasons as to why choose Jemma in a carousel.
class Carousel extends StatelessWidget {
  final bool isCustomerSelected;

  const Carousel({Key? key, required this.isCustomerSelected})
      : super(key: key);

  // [customerImageTextMap] and [tradieImageTextMap]
  // contains image path and the relevant text (reason to choose Jemma).
  static const Map<String, String> customerImageTextMap = {
    "assets/images/list.png": "Itemised quotes, invoices and more!",
    "assets/images/money.png": "Financial security through Escrow.",
    "assets/images/organize.png": "Schedule without hassle.",
    "assets/images/profile.png": "Publicly viewable tradie profiles.",
    "assets/images/review.png": "See and give ratings and reviews.",
  };

  static const Map<String, String> tradieImageTextMap = {
    "assets/images/money.png": "Financial security through Escrow.",
    "assets/images/list.png": "Itemised quotes, jobs and more!",
    "assets/images/payment.png": "Receive payments easily.",
    "assets/images/organize.png": "Schedule without hassle.",
    "assets/images/balance.png": "Better work-life balance."
  };

  @override
  Widget build(BuildContext context) {
    var imageTextMap =
        isCustomerSelected ? customerImageTextMap : tradieImageTextMap;
    var size = MediaQuery.of(context).size;
    return GFCarousel(
      // pagination: true,
      hasPagination: true,
      activeIndicator: Colors.green,
      passiveIndicator: Colors.black,
      autoPlay: true,
      height: max(7.5.ph(size), 225),
      viewportFraction: 0.33,
      items: imageTextMap.keys.map(
        (assetLocationString) {
          var text = imageTextMap[assetLocationString] ?? "";

          return Container(
            margin: const EdgeInsets.all(5),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              // Image
              Flexible(
                  child: Image.asset(assetLocationString, fit: BoxFit.contain)),

              // Some description.
              Expanded(
                child: Center(
                    child: Text(
                  text,
                  maxLines: 5,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.clip,
                )),
              ),
            ]),
          );
        },
      ).toList(),
    );
  }
}

/// Toggle Button for users to choose the specific type of user info they need.
class UserToggleButton extends StatelessWidget {
  UserToggleButton({
    Key? key,
    required this.onSelectionChanged,
    required this.isCustomerSelected,
  }) : super(key: key);

  final ValueChanged<bool> onSelectionChanged;
  final bool isCustomerSelected;
  late final List<bool> isSelected;

  @override
  Widget build(BuildContext context) {
    isSelected = [isCustomerSelected, !isCustomerSelected];
    return ToggleButtonsTheme(
        data: ToggleButtonsThemeData(
            borderRadius: BorderRadius.circular(20.0),
            fillColor: Colors.green,
            selectedColor: Colors.white),
        child: ToggleButtons(
          children: [
            _buildToggleButtonContent("Customer", Icons.person_pin),
            _buildToggleButtonContent("Tradie", Icons.person_pin),
          ],
          onPressed: (int index) {
            assert(index < 2, "There are only 2 types of primary users.");

            // Note: First toggle button is for customer.
            onSelectionChanged(index == 0);
          },
          isSelected: isSelected,
        ));
  }

  Container _buildToggleButtonContent(String text, IconData iconData) =>
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 2.5),
          constraints: const BoxConstraints(maxWidth: 100),
          child: Row(children: [
            Icon(iconData),
            Expanded(child: Text(text, overflow: TextOverflow.ellipsis))
          ]));
}

/*import 'dart:math';

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_cross_app/Home Page/home.dart';
import 'package:new_cross_app/Home Page/decorations.dart';
import 'package:new_cross_app/Home Page/responsive.dart';

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
}*/
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_cross_app/Home Page/home.dart';
import 'package:new_cross_app/Home Page/decorations.dart';
import 'package:new_cross_app/Home Page/responsive.dart';

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
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: size.height * 0.01),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: defaultShadows,
          borderRadius: BorderRadius.circular(40)),
      child: Column(children: [
        SizedBox(height: size.height * 0.0075),
        OverflowBar(
          spacing: size.width * 0.25,
          overflowSpacing: size.height * 0.015,
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
        SizedBox(height: size.height * 0.025),
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
    "assets/images/organize.png": "Publicly viewable tradie calendar.",
    "assets/images/profile.png": "Publicly listed profiles.",
    "assets/images/review.png": "Ratings and reviews",
    "assets/images/legalese.png": "No more legalese!",
    "assets/images/mediation.png": "Mediation if needed.",
    "assets/images/customer.png": "Consumer rights.",
    "assets/images/portfolio.png": "Portfolio pictures.",
    "assets/images/experience.png": "Simplified app experience.",
    "assets/images/hiring.png": "Confidence hiring the right person.",
  };

  static const Map<String, String> tradieImageTextMap = {
    "assets/images/money.png": "Financial security through escrow payments.",
    "assets/images/payment.png": "Instant payments upon completion.",
    "assets/images/organize.png": "Public viewable calendar.",
    "assets/images/balance.png": "Better work-life balance.",
    "assets/images/review.png": "Ratings and reviews.",
    "assets/images/legalese.png": "No more legalese!",
    "assets/images/interruption.png": "No more interruptions.",
    "assets/images/profile.png": "Publicly listed profile to showcase your qualifications and experience",
    "assets/images/skills.png": "Pictures of your work for you to showcase your skills.",
    "assets/images/mediation.png": "Mediation if needed.",
  };
  static const Map<String, String> customerBenefitTextMap = {
    "assets/images/list.png": "Everyone needs receipts, even better if they list what you paid for each part of the service. When you book through Jemma you’ll get just that so your records are clean and you can access them again through your profile in case you forget who you hired last time or you deleted that email we sent you.",
    "assets/images/money.png": "Let’s be honest, one major complaint we hear is not knowing that they can trust someone with their money, and renovations can be expensive.\n\nJemma provides an escrow style system where the agreed upon amount is deposited into a trust account held by us. Once the job is completed satisfactorily and you sign off through the service, the tradie gets their money. It’s that simple.\n\nIf they don’t turn up then we return your money, free of charge. No small print. That’s it.\n\nI’m sure you’ve heard the horror stories, but they’re about to be tales from the past.",
    "assets/images/organize.png": "We know you’re busy and sometimes you don’t have the time to phone around and find out when someone can fix or build something for you.\n\nThis is why the tradie calendar system can alleviate your frustrations.\n\nBy being able to see who is available you can book work in with your chosen tradie directly from your computer, phone or tablet.\n\nHave you ever had someone turn up to build something for you and leave halfway through making you wonder when it’s going to be finished?\n\nMany people have, and that’s why we’ve implemented the calendar system. That way you know when they’ll arrive and leave, so you can relax. It’s time things changed so we no longer have to guess.\n\nTo ensure privacy for everyone you won’t be able to see who they’re working for (unless it’s you) however at least you won’t be wondering anymore when they’ll be back.",
    "assets/images/review.png": "Many small businesses rely on ratings and reviews to survive and it’s important to us to include this feature. With Jemma you can browse through the list of tradies and check out what reviews and ratings other people have left for you to read.\n\nOur service also gives you the opportunity after completion and payment for you to let everyone else know what a great job was done for you.\n\nTo ensure that all reviews are legitimate, only the account holder can leave a review for the job they booked, that way you know Jemma won’t have fake reviews leaving you dissatisfied.",
    "assets/images/legalese.png": "When was the last time you read one of those customer agreements? You know the ones, long, boring, and hard to understand.\n\nYou just want to sign up and start using the service, we get it.\n\nThis is why we give you the option of a simplified version that’s quick and easy to read but still informs you of the important stuff, just without the legal jargon.\n\nIf you’re a legal professional or just someone who needs something to read then that option is available too, it’s your choice.\n\n",
    "assets/images/profile.png": "For most of us we don’t know who to call when we need something fixed or built so we usually go with whoever we can find, which means calling around and asking the same questions.\n\nHow do you know they're good at their job though?\n\nWith our transparent profile section you can easily browse the list of tradespeople in your area fully online without having to ring around.\n\nEach profile will detail their experience, portfolio of past work and estimated costs, ratings and reviews and their calendar so you know when they’re available to fit your schedule.",
    "assets/images/mediation.png": "Sometimes we don’t all get along and as much as we try hard to ensure everyone has a great experience, unfortunately there will be the occasional problem or miscommunication.\n\nWe’re here to help with that. If this does arise we can intervene and mediate which removes the customer from any conflict.\n\nWe don’t want you to feel intimidated into paying for something you aren’t satisfied with so let us handle it for you.\n\nAll communications should be carried out through Jemma’s internal messaging system, that way Jemma can easily track who said what and the agreed upon details so there’s no ‘he said, she said’ complications.\n\nWe’re on no-one’s side, we just want everyone to be happy.",
    "assets/images/customer.png": "Our research indicates that a lot of customers do not know their consumer rights and that’s something we want to help fix.\n\nBy providing customers with access to their rights it gives you the confidence that the job will get done to the standard expected in Australia, because that’s what you deserve.",
    "assets/images/portfolio.png": "Have you ever needed something built, a fence for example, but you don’t know what you want? Do you even know whether the tradie could build something you’ve seen before?\n\nThis is why we included a portfolio feature, so now you know.\n\nJemma provides you the opportunity to view examples of other people’s work to get ideas. You can also upload your own pictures with your review so everyone else can see what a good job the tradie did for you, helping others like they did for you.",
    "assets/images/experience.png": "No-one likes complications. Our aim at Jemma is to provide an experience where anyone could tap a few buttons and get what they want. It works for a lot of other things we order online so why not tradies?\n\nFrom browsing to find the right one, to booking and then confirming the job was done and paying for it, you can do it all through the website or app. If you or the tradesperson has any questions or changes, our notifications and messaging system can handle the communications for you.\n\nThat way you can organise everything when you’re in that meeting while you’re supposed to be taking notes, and no-one will ever know!",
    "assets/images/hiring.png": "It’s not easy these days to see how qualified tradespeople are so you know you’re getting the best person for the job. With Jemma you can see their licenses, qualifications such as Master Builders, etc.\n\nThis way you can be confident when perusing their profiles, knowing that we’ve verified all the details for you.",
  };

  static const Map<String, String> tradieBenefitTextMap = {
    "assets/images/money.png": "Most people pay what they owe however we're also aware that some don't.\n\nEven though this is only a small percentage of troublesome customers, it's still a lot of time and money spent chasing up invoices and potential time spent in civil court.\n\nYou don't need that hassle so Jemma provides an escrow service where the agreed upon amount for commissioned work is held upfront in a trust account until the works are completed.Put simply, the customer books you in, you both agree on a set amount and estimated timeframe for the job and the customer deposits that amount in the trust account. This money is held while you complete the job, giving you the confidence that as long as the job is completed satisfactorily, you'll get paid upon completion.\n\nOnce both parties are happy then the customer signs off through the website/app and the amount owed is released to you and an invoice is issued to both parties.\n\nNo more chasing up payments, you've got more important things to do.",
    "assets/images/payment.png": "Payment cycles are a pain, we get it. You did the job so why should you have to wait a few weeks to be paid for it? It's a hassle to keep track of and it makes your bookkeeping more stressful than it should be.\n\nWith Jemma's escrow and instant sign-off features you'll get paid when you complete the work because that's when you deserve to get paid.",
    "assets/images/organize.png": "How many phone calls do you take each day asking you when you're available? How many times do you answer the same questions each day and have to check your calendar?\n\nYour profile will feature your calendar which will show customers when you're available. To ensure confidentiality, only the times and dates will be visible to the public, however as a member of Jemma this is your tool to see the details of upcoming and previous work. Only you can see those details in case you need to check what you're doing later. You can also block out dates and times for those times when you need a holiday, or something else.\n\nJust let Jemma know when you're available and we'll do the rest.",
    "assets/images/balance.png": "Our research indicates that tradies spend too much time filling out paperwork, invoicing and other admin related duties.\n\nIf you're wondering 'why has this not been automated yet?', it has. You're looking at it.\n\nJemma was specifically designed to take the burden from you. Admin, taxes and other paperwork are a hassle that you don't need, but they're necessary for your business to survive. So let us do the hard work for you because that's what we do.\n\nYou're great with the tools and we're great with the computery stuff.\n\nMeanwhile, take that extra time you'll have to spend time with your family, or exercising, or taking on extra work, or maybe just down the pub catching up with mates.\n\nEither way it's more free time for you.",
    "assets/images/review.png": "Customers are relying on ratings and reviews increasingly every day. Whether it be for food, entertainment, electronics, mostly everything. They are quickly becoming a deciding factor on who and what people choose to use and purchase.\n\nThis is your opportunity to let people know how good you are and we want to give you that opportunity by letting the customers tell everyone else why they should hire you.\n\nIn addition to this, our system will only let people give you a rating and review if they actually hired you, which means no fake reviews from people you've never heard of!\n\n(Or that pesky competitor from down the street)",
    "assets/images/legalese.png": "When was the last time you read one of those customer agreements? You know the ones, long, boring, and hard to understand.\n\nYou just want to sign up and start using the service, however you also want to be protested, we get it.\n\nThis is why we give you the option of a simplified version that’s quick and easy to read but still informs you of the important stuff, just without the legal jargon.\n\nIf you’re a lawyer or just someone who needs something to read then that option is available too, it’s your choice.\n\n",
    "assets/images/interruption.png": "Say goodbye to those random phone calls every day while trying to finish work for someone else. When the public has access to your profile, qualifications and skills, you won't need to answer those questions repeatedly.\n\nWith access to your calendar customers can see when you're available and book you within minutes. No more phone calls interrupting you while you work, meaning jobs are completed earlier and you're not answering the same questions over and over and over.\n\nTo ensure privacy for everyone, customers won’t be able to see who you’re working for, just that you’re not available at certain dates and times.\n\nMeanwhile, the details of the jobs that have been booked will be clickable so you can remind yourself of the important details of your upcoming jobs.",
    "assets/images/profile.png": "You're great on the tools, we know that. Let us help you with the online stuff, which is what we're great at.\n\nMore people every day want to easily find and order services online. With your brand and experience freely available to the public we'll give you more exposure for your business through a professionally designed, easy to read profile, ensuring customers know how great you are, without having to contact you and interrupt the job you're on.",
    "assets/images/skills.png": "If your trade involves custom designs and fabrication then you'll have the opportunity to upload pictures of your previous completions. Whether it be a fence, landscaping or any job you'd like to showcase, Jemma will give you the freedom to not only show off your work but also give the customer some ideas as to what they want you to do for them.\n\nFor example, a customer needs a fence but they don’t know what they want? Just wait until they see your portfolio!",
    "assets/images/mediation.png": "Sometimes we don’t all get along and as much as we try hard to ensure everyone has a great experience, unfortunately there will be the occasional problem or miscommunication.\n\nWe’re here to help with that. If this does arise we can intervene and mediate which removes the tradie from any conflict.\n\nWe don’t want you to feel intimidated into not being paid for something you did correctly so let us handle it for you.\n\nAll communications should be carried out through Jemma’s internal messaging system, that way if conflicts do arise Jemma can easily track who said what and the agreed upon details so there’s no ‘he said, she said’ complications.\n\nWe’re on no-one’s side, we just want everyone to be happy.",
  };



  @override
  Widget build(BuildContext context) {
    var imageTextMap =
    isCustomerSelected ? customerImageTextMap : tradieImageTextMap;
    var BenefitTextMap =
    isCustomerSelected ? customerBenefitTextMap : tradieBenefitTextMap;
    var size = MediaQuery.of(context).size;
    return GFCarousel(
      hasPagination: true,
      activeIndicator: Colors.green,
      passiveIndicator: Colors.black,
      autoPlay: true,
      height: max(7.5.ph(size), 225),
      viewportFraction: 0.33,
      items: imageTextMap.keys.map(
            (assetLocationString) {
          var text = imageTextMap[assetLocationString] ?? "";
          var benefit = BenefitTextMap[assetLocationString] ?? "";
          return GestureDetector(
            onTap: () {
              _showImageDescriptionDialog(context, benefit, text);
            },
            child:Container(
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
            ),
          );
        },
      ).toList(),
    );
  }
  void _showImageDescriptionDialog(BuildContext context, String description, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white.withOpacity(0.8),
          title: Text(text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Container(
            width: 600.0,
            child: SingleChildScrollView(
              child: Text(description),
            ),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 30.0),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        );
      },
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



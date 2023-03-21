import 'dart:convert';
import 'dart:math';
import 'dart:js' as js;
import 'package:hive/hive.dart';
import 'package:http/http.dart';

import 'package:flutter/material.dart';
import 'package:jemma/models/user.dart';
import 'package:jemma/repository.dart';

import 'package:jemma/routes.dart';
import 'package:jemma/utils/adaptive.dart';
import 'package:jemma/utils/constants.dart';
import 'package:jemma/utils/responsive.dart';
import 'package:jemma/utils/notification.dart';
import 'package:jemma/widgets/signup/account_details.dart';
import 'package:jemma/widgets/signup/address_details.dart';
import 'package:jemma/widgets/signup/bank_details.dart';
import 'package:jemma/widgets/signup/card_details.dart';
import 'package:jemma/widgets/signup/company_details.dart';
import 'package:jemma/widgets/signup/decoration_image_container.dart';
import 'package:jemma/widgets/signup/personal_details.dart';
import 'package:jemma/widgets/signup/tradesperson_profile_details.dart';

enum SignupOf { customer, tradesperson }

class Signup extends StatelessWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: SafeArea(
            child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: 100.ph(size)),
                child: Stack(children: <Widget>[
                  SingleChildScrollView(
                      child: Form(
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: <
                                  Widget>[
                    /* Title */
                    ConstrainedBox(
                        constraints: BoxConstraints(minHeight: 30.ph(size)),
                        child: Center(
                            child: FittedBox(
                                fit: BoxFit.contain,
                                child: Text("Sign up",
                                    style: TextStyle(fontSize: 50))))),

                    /* Header */
                    ConstrainedBox(
                        constraints: BoxConstraints(minHeight: 10.ph(size)),
                        child: Text("In which way would you like to use Jemma?",
                            style: TextStyle(fontSize: 15))),
                    Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          /* Customer Icon */
                          GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, Screen.signup_customer.getURL());
                              },
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Container(
                                        width:
                                            min(17.5.pw(size), 17.5.ph(size)),
                                        child: Icon(
                                            Icons.account_circle_outlined,
                                            size: 7.pw(size))),
                                    SizedBox(height: 1.pw(size)),
                                    Text("Customer",
                                        style: TextStyle(fontSize: 15))
                                  ])),
                          SizedBox(width: 15.pw(size)),

                          /* Tradesperson Icon */
                          GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context,
                                    Screen.signup_tradesperson.getURL());
                              },
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Container(
                                        width:
                                            min(17.5.pw(size), 17.5.ph(size)),
                                        child: Icon(
                                            Icons.account_circle_outlined,
                                            size: 7.pw(size))),
                                    SizedBox(height: 1.pw(size)),
                                    Text("Tradesperson",
                                        style: TextStyle(fontSize: 15))
                                  ]))
                        ])
                  ]))),

                  /* Decoration Image */
                  Positioned.fill(
                      child: Align(
                          alignment: Alignment(0.7, 1),
                          child: DecorationImageContainer(size: size)))
                ]))),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        /*floatingActionButton: isWeb()
            ? null
            : FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back, color: Colors.black87)));*/
        // TODO: Need to discuss with other guys on this.
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              Navigator.pushNamed(context, Screen.home.getURL());
            },
            child: const Icon(Icons.arrow_back, color: Colors.black87)));
  }
}

class SignupStage2 extends StatefulWidget {
  final SignupOf signupOf;

  SignupStage2({Key? key, required this.signupOf}) : super(key: key);

  @override
  State<SignupStage2> createState() => SignupStage2State();
}

class SignupStage2State extends State<SignupStage2> {
  final List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];

  /*
    NOTE: This manual validation had to stored due to the `formKeyValid`
    function not returning the actual validation when the relevant `Step` is not
    active.
  */
  final List<bool> validations = [false, false, false, false];

  final TextEditingController email = new TextEditingController(),
      password = new TextEditingController(),
      /* Personal Details */
      firstName = new TextEditingController(),
      lastName = new TextEditingController(),
      phone = new TextEditingController(),
      /* Customer */
      cardName = new TextEditingController(),
      cardNumber = new TextEditingController(),
      cardValidDate = new TextEditingController(),
      cardCVV = new TextEditingController(),
      /* Tradesperson */
      companyName = new TextEditingController(),
      companyABN = new TextEditingController(),
      bankName = new TextEditingController(),
      bankNumber = new TextEditingController(),
      bankBSB = new TextEditingController(),
      travelDistance = new TextEditingController();

  final Address primaryAddress = new Address(),
      secondaryAddress = new Address();

  /* Stepper Controllers */
  int index = 0;
  bool newIndexInRange(int i) {
    return (i >= 0) && (i <= ((widget.signupOf == SignupOf.customer) ? 2 : 3));
  }

  bool indexIsLast() {
    return this.index == ((widget.signupOf == SignupOf.customer) ? 2 : 3);
  }

  /* Form Stages Validator */
  bool formKeyValid(int i) {
    if (!this.newIndexInRange(i)) return false;
    if (this.formKeys[i].currentState == null) return false;
    return this.formKeys[i].currentState!.validate();
  }

  bool submit_ALLOW = true;
  void submit() {
    // debugPrint("${!this.validations[0]} | ${!this.validations[1]} | ${!this.validations[2]} | ${!this.validations[3]}");

    if (!this.submit_ALLOW ||
        !this.validations[0] ||
        !this.validations[1] ||
        !this.validations[2] ||
        ((this.widget.signupOf == SignupOf.tradesperson) &&
            !this.validations[3])) return;
    this.submit_ALLOW = false;

    /*
      POST Data Builder
    */
    Map<String, dynamic> data = new Map();
    data["user_type"] =
        (this.widget.signupOf == SignupOf.customer) ? "CUSTOMER" : "TRADIE";
    /* Account details */
    data["email"] = this.email.text;
    data["password"] = this.password.text;
    /* Personal details */
    if (this.firstName.text.length > 0)
      data["first_name"] = this.firstName.text;
    if (this.lastName.text.length > 0) data["last_name"] = this.lastName.text;
    if (this.phone.text.length > 0)
      data["phone_number"] = int.parse(this.phone.text);
    /* Address details */
    data["address_data"] = {"a1": {}};
    if (this.primaryAddress.address_line_one.text.length > 0)
      data["address_data"]["a1"]["address_line_one"] =
          int.parse(this.primaryAddress.address_line_one.text);
    if (this.primaryAddress.address_line_two.text.length > 0)
      data["address_data"]["a1"]["address_line_two"] =
          int.parse(this.primaryAddress.address_line_two.text);
    if (this.primaryAddress.suburb.text.length > 0)
      data["address_data"]["a1"]["suburb"] =
          int.parse(this.primaryAddress.suburb.text);
    if ((this.primaryAddress.state != null) &&
        (this.primaryAddress.state!.length > 0))
      data["address_data"]["a1"]["state"] =
          int.parse(this.primaryAddress.state!);
    if (this.primaryAddress.postcode.text.length > 0)
      data["address_data"]["a1"]["postal_code"] =
          int.parse(this.primaryAddress.postcode.text);
    if (data["address_data"]["a1"].isEmpty) data["address_data"].remove("a1");

    data["address_data"]["a2"] = {};
    if (this.secondaryAddress.address_line_one.text.length > 0)
      data["address_data"]["a2"]["address_line_one"] =
          int.parse(this.secondaryAddress.address_line_one.text);
    if (this.secondaryAddress.address_line_two.text.length > 0)
      data["address_data"]["a2"]["address_line_two"] =
          int.parse(this.secondaryAddress.address_line_two.text);
    if (this.secondaryAddress.suburb.text.length > 0)
      data["address_data"]["a2"]["suburb"] =
          int.parse(this.secondaryAddress.suburb.text);
    if ((this.secondaryAddress.state != null) &&
        (this.secondaryAddress.state!.length > 0))
      data["address_data"]["a2"]["state"] =
          int.parse(this.secondaryAddress.state!);
    if (this.secondaryAddress.postcode.text.length > 0)
      data["address_data"]["a2"]["postal_code"] =
          int.parse(this.secondaryAddress.postcode.text);
    if (data["address_data"]["a2"].isEmpty) data["address_data"].remove("a2");

    if (data["address_data"].isEmpty) data.remove("address_data");

    if (this.widget.signupOf == SignupOf.customer) {
      /* Payment details */
      if (this.cardName.text.length > 0)
        data["bank_card_holder"] = this.cardName.text;
      if (this.cardNumber.text.length > 0)
        data["bank_card_number"] = int.parse(this.cardNumber.text);
      if (this.cardValidDate.text.length > 0)
        data["bank_card_expiry_date"] = int.parse(this.cardValidDate.text);
      if (this.cardCVV.text.length > 0)
        data["bank_card_cvv"] = int.parse(this.cardCVV.text);
    } else if (this.widget.signupOf == SignupOf.tradesperson) {
      /* Company details */
      data["company_name"] = this.companyName.text;
      data["australian_business_number"] = int.parse(this.companyABN.text);
      /* Payment details */
      if (this.bankName.text.length > 0)
        data["bank_account_name"] = this.bankName.text;
      if (this.bankNumber.text.length > 0)
        data["bank_account_number"] = int.parse(this.bankNumber.text);
      if (this.bankBSB.text.length > 0)
        data["bank_state_branch"] = int.parse(this.bankBSB.text);
      /* Tradesperson profile details */
      if (this.travelDistance.text.length > 0)
        data["travel_distance"] = int.parse(this.travelDistance.text);
    }

    debugPrint("\n${jsonEncode(data)}\n");

    /* Submit request and show progress */
    showNotification(context, "Submitting", NotificationType.info);

    // TODO: the url below should be tested
    post(Uri.parse("http://localhost:8000/signup/"),
        body: jsonEncode(data),
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json"
        }).then((Response value) {
      /* Request Success */
      debugPrint("\nThen: ${value.body}\n");
      var response = json.decode(value.body);
      if (response.containsKey("id")) {
        /*showNotification(context, "Account created", NotificationType.success, duration: Duration(seconds: 3))
            .closed
            .then((_) => Navigator.pop(context));*/
        showNotification(context, "Account created", NotificationType.success,
            duration: const Duration(seconds: 3));

        // TODO: fix the 3rd bug. After finishing the sign up, navigate back to the log in page
        Navigator.pushNamed(context, Screen.login.getURL());

        if (response.containsKey("onboarding")) {
          // If user is TRADIE, redirect to Stripe onboarding
          js.context.callMethod('open', [response["onboarding"]]);
        }
      } else {
        showNotification(context, "Failed signing up", NotificationType.error,
            duration: const Duration(seconds: 3));
        Navigator.pushNamed(context, Screen.login.getURL());
      }
    }).catchError((x) {
      /* Request Failed */
      debugPrint("\nError: ${x.toString()}\n");
      showNotification(context, "Failed signing up", NotificationType.error,
          duration: const Duration(seconds: 3));
      Navigator.pushNamed(context, Screen.signup.getURL());
    }).whenComplete(() {
      this.submit_ALLOW = true;
    });
  }

  // TODO: To make the user log in automatically after sign up
  void autoLogin(String username, String password, Client client) async {
    final url = Uri.parse("${Repository.baseUrl}/login/");
    await client
        .post(url,
            headers: {"Content-type": "application/json"},
            body: jsonEncode({"username": username, "password": password}))
        .then((response) {
      if (response.statusCode == 200) {
        var user = User.fromJson(jsonDecode(response.body));
        Repository().user.value = user;
        Hive.box(Repository.hiveEncryptedBoxName).put("user", user);
      }
    });
  }

  @override
  Scaffold build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: SafeArea(
            child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: 100.ph(size)),
                child: Stack(children: <Widget>[
                  SingleChildScrollView(
                      child: Column(mainAxisSize: MainAxisSize.min, children: <
                          ConstrainedBox>[
                    /* Title */
                    ConstrainedBox(
                        constraints: BoxConstraints(minHeight: 18.ph(size)),
                        child: Center(
                            child: FittedBox(
                                fit: BoxFit.contain,
                                child: Column(children: <Widget>[
                                  Text("Sign up",
                                      style: TextStyle(fontSize: 50)),
                                  SizedBox(height: max(2.ph(size), 10)),
                                  Text(
                                      (this.widget.signupOf == SignupOf.customer
                                          ? "Customer"
                                          : "Tradesperson"),
                                      style: TextStyle(fontSize: 20))
                                ])))),
                    ConstrainedBox(
                        constraints: BoxConstraints.tightFor(
                            height: 700.0, width: 150.ph(size)),
                        child: Stepper(
                            type: StepperType.horizontal,
                            currentStep: this.index,
                            onStepTapped: (int index) {
                              this.setState(() {
                                this.index = index;
                              });
                            },
                            controlsBuilder: (BuildContext context,
                                ControlsDetails details) {
                              // {VoidCallback? onStepContinue,
                              // VoidCallback? onStepCancel}) {
                              return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                            primary: kLogoColor, elevation: 1),
                                        icon: Icon(Icons.navigate_before,
                                            color: Colors.black, size: 50),
                                        onPressed: () {
                                          if (this.index > 0) {
                                            this.setState(() {
                                              this.index--;
                                            });
                                          } else {
                                            Navigator.pushNamed(context,
                                                Screen.signup.getURL());
                                          }
                                        },
                                        label: Text("Previous",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 25))),
                                    SizedBox(width: 5.ph(size)),
                                    ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                            primary: kLogoColor, elevation: 1),
                                        icon: Icon(
                                            (this.indexIsLast()
                                                ? Icons.done
                                                : Icons.navigate_next),
                                            color: Colors.black,
                                            size: 50),
                                        onPressed: () {
                                          this.validations[this.index] =
                                              this.formKeyValid(this.index);
                                          if (!this.validations[this.index]) {
                                            showNotification(
                                                context,
                                                "Please properly fill the fields",
                                                NotificationType.error);
                                            return;
                                          }
                                          if (this.indexIsLast())
                                            this.submit();
                                          else if (this
                                              .newIndexInRange(this.index + 1))
                                            this.setState(() {
                                              this.index++;
                                            });
                                        },
                                        label: Text(
                                            (this.indexIsLast()
                                                ? (this.submit_ALLOW
                                                    ? "Submit"
                                                    : "Submitting...")
                                                : "Continue"),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 25)))
                                  ]);
                            },
                            steps: <Step>[
                              Step(
                                  title: new Text(''),
                                  isActive: this.index == 0,
                                  state: !this.validations[0]
                                      ? StepState.editing
                                      : StepState.complete,
                                  content: Form(
                                      key: this.formKeys[0],
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <ConstrainedBox>[
                                            ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    minHeight: 20.ph(size),
                                                    maxWidth: 1000),
                                                child:
                                                    Column(children: <Widget>[
                                                  /* Account Details */
                                                  Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                          "Account details",
                                                          style: TextStyle(
                                                              fontSize: 25))),
                                                  Divider(
                                                      color: Colors.black,
                                                      thickness: 2),
                                                  SizedBox(
                                                      height:
                                                          max(2.ph(size), 10)),
                                                  AccountDetails(
                                                      email: this.email,
                                                      password: this.password),

                                                  /* Personal Details */
                                                  Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                          "Personal details ${this.widget.signupOf == SignupOf.customer ? "(Optional)" : ""}",
                                                          style: TextStyle(
                                                              fontSize: 25))),
                                                  Divider(
                                                      color: Colors.black,
                                                      thickness: 2),
                                                  SizedBox(
                                                      height:
                                                          max(2.ph(size), 10)),
                                                  PersonalDetails(
                                                      signupOf:
                                                          this.widget.signupOf,
                                                      firstName: this.firstName,
                                                      lastName: this.lastName,
                                                      phone: this.phone)
                                                ]))
                                          ]))),
                              Step(
                                  title: new Text(''),
                                  isActive: this.index == 1,
                                  state: !this.validations[1]
                                      ? StepState.editing
                                      : StepState.complete,
                                  content: Form(
                                      key: this.formKeys[1],
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <ConstrainedBox>[
                                            ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    minHeight: 20.ph(size),
                                                    maxWidth: 1000),
                                                child: Center(
                                                    child: Column(children: <
                                                        Widget>[
                                                  /* Primary Address Details */
                                                  Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                          "Primary address details (Optional)",
                                                          style: TextStyle(
                                                              fontSize: 25))),
                                                  Divider(
                                                      color: Colors.black,
                                                      thickness: 2),
                                                  SizedBox(
                                                      height:
                                                          max(2.ph(size), 10)),
                                                  AddressDetails(
                                                      address:
                                                          this.primaryAddress),

                                                  /* Secondary Address Details */
                                                  Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                          "Secondary address details (Optional)",
                                                          style: TextStyle(
                                                              fontSize: 25))),
                                                  Divider(
                                                      color: Colors.black,
                                                      thickness: 2),
                                                  SizedBox(
                                                      height:
                                                          max(2.ph(size), 10)),
                                                  AddressDetails(
                                                      address: this
                                                          .secondaryAddress),
                                                  SizedBox(
                                                      height:
                                                          max(5.ph(size), 10))
                                                ])))
                                          ]))),
                              Step(
                                  title: new Text(''),
                                  isActive: this.index == 2,
                                  state: !this.validations[2]
                                      ? StepState.editing
                                      : StepState.complete,
                                  content: Form(
                                      key: this.formKeys[2],
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <ConstrainedBox>[
                                            ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    minHeight: 20.ph(size),
                                                    maxWidth: 1000),
                                                child: Center(
                                                    child: Column(children: <
                                                        Widget>[
                                                  if (this.widget.signupOf ==
                                                      SignupOf.customer) ...[
                                                    /* Payment Details */
                                                    Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                            "Payment details (Optional)",
                                                            style: TextStyle(
                                                                fontSize: 25))),
                                                    Divider(
                                                        color: Colors.black,
                                                        thickness: 2),
                                                    SizedBox(
                                                        height: max(
                                                            2.ph(size), 10)),
                                                    CardDetails(
                                                        cardName: this.cardName,
                                                        cardNumber:
                                                            this.cardNumber,
                                                        cardValidDate:
                                                            this.cardValidDate,
                                                        cardCVV: this.cardCVV)
                                                  ] else ...[
                                                    /* Company Details */
                                                    Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                            "Company details",
                                                            style: TextStyle(
                                                                fontSize: 25))),
                                                    Divider(
                                                        color: Colors.black,
                                                        thickness: 2),
                                                    SizedBox(
                                                        height: max(
                                                            2.ph(size), 10)),
                                                    CompanyDetails(
                                                        companyName:
                                                            this.companyName,
                                                        companyABN:
                                                            this.companyABN),

                                                    /* Payment Details */
                                                    Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                            "Payment details (Optional)",
                                                            style: TextStyle(
                                                                fontSize: 25))),
                                                    Divider(
                                                        color: Colors.black,
                                                        thickness: 2),
                                                    SizedBox(
                                                        height: max(
                                                            2.ph(size), 10)),
                                                    BankDetails(
                                                        bankName: this.bankName,
                                                        bankNumber:
                                                            this.bankNumber,
                                                        bankBSB: this.bankBSB)
                                                  ],
                                                  SizedBox(
                                                      height:
                                                          max(5.ph(size), 10))
                                                ])))
                                          ]))),
                              if (this.widget.signupOf == SignupOf.tradesperson)
                                (Step(
                                    title: new Text(''),
                                    isActive: this.index == 3,
                                    state: !this.validations[3]
                                        ? StepState.editing
                                        : StepState.complete,
                                    content: Form(
                                        key: this.formKeys[3],
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <ConstrainedBox>[
                                              ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                      minHeight: 20.ph(size),
                                                      maxWidth: 1000),
                                                  child: Center(
                                                      child: Column(children: <
                                                          Widget>[
                                                    /* Tradesperson Profile Details */
                                                    Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                            "Tradesperson profile details (Optional)",
                                                            style: TextStyle(
                                                                fontSize: 25))),
                                                    Divider(
                                                        color: Colors.black,
                                                        thickness: 2),
                                                    SizedBox(
                                                        height: max(
                                                            2.ph(size), 10)),
                                                    TradespersonProfileDetails(
                                                        travelDistance: this
                                                            .travelDistance),
                                                    SizedBox(
                                                        height:
                                                            max(5.ph(size), 10))
                                                  ])))
                                            ]))))
                            ]))
                  ])),

                  /* Decoration Image */
                  Positioned.fill(
                      child: Align(
                          alignment: Alignment(0.7, 1),
                          child: DecorationImageContainer(size: size)))
                ]))),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: isWeb()
            ? null
            : FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back, color: Colors.black87)));
  }
}

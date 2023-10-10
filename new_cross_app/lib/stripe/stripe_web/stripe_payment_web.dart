import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}
late int amount;
//String testPageUrl = 'http://localhost:3000';
//TODO PRICE IS AMOUNT IN CENTS

//
Map<String, String> body = {
  'price': '10000',
  'consumerId': '0eGyXTXhWWeEcqzCoMmHWq0EYsv1',
  'product_name': 'painting',
  'metadata': json.encode({
    'consumerId': '0eGyXTXhWWeEcqzCoMmHWq0EYsv1'
  })
};


Map<String, String> transfer = {
  'accountId': 'acct_1NfzPL2HVWGzklJ4',
  'amount':'500',
};
late String paymentID;
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stripe Connect Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Stripe Connect Demo'),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  //TODO store accountID to firebase (question:hash?)
                  createStripeConnectAccount();
                },
                child: const Text('Stripe Connect Onboarding'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await createPaymentIntent(body);
                },
                child: const Text('Stripe Consumer Payment'),
              ),
              ElevatedButton(
                onPressed: () {
                  //TODO get accountId and amount from firebase
                  confirmWork();

                },
                child: const Text('ConfirmPayment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


Future<void> createStripeConnectAccount() async {
  await http.get(
    Uri.parse('https://us-central1-jemma-b0fcd.cloudfunctions.net/createConnectAccount'),
  ).then((response){
    if (response.statusCode == 200) {
      print('请求成功：${response.body}');
      Map<String, dynamic> responseMap = json.decode(response.body);
      String accountId = responseMap['id']!.toString();
      _launchURL(responseMap['url']!.toString());
    } else {
      print('请求失败：${response.statusCode}');
    }
  }).catchError((error){
    print(error.toString());
  });
}

//TODO: get price, accountID, userID(?)=>use for redirect, BookingID(?)=>use for redirect,product name
//TODO: get amount received-》webhook
Future<String> createPaymentIntent(Map<String,String> body) async{
  await http.post(
    Uri.parse('https://us-central1-jemma-b0fcd.cloudfunctions.net/StripeCheckOut'),
    body:body,
  ).then((res){
    if(res.statusCode == 200){
      print('success');
      Map<String, dynamic> responseMap = json.decode(res.body);
      print('check');
      print(responseMap['consumerId']);
      print(responseMap['tradieId']);
      print(responseMap['consumerName']);
      amount = int.parse(responseMap['amount']!.toString());
      _launchURL(responseMap['url']!.toString());
    }else{
      print('failed: ${res.body}');
    }
  });
  return '';

}

Future<void> confirmWork() async{
  final res =await http.post(
    Uri.parse('https://us-central1-jemma-b0fcd.cloudfunctions.net/Transfer'),
    body:transfer,
  );
  print(res.body);
  if(res.statusCode == 200){
    print(res.body);
    print('success');
  }else if (res.statusCode == 400){
    print('failed: ${res.body}');
  }
}
void _launchURL(String url) async{
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    throw 'could not open $url';
  }

}
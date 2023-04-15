import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';



void main() {
  runApp(StripeApp());
}

class StripeApp extends StatelessWidget{
  const StripeApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'checkout',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home:  MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
class MyHomePage extends StatelessWidget {
  const MyHomePage({key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Check Out"),
      ),
      body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Request Information",style:TextStyle(fontSize: 30.0)),
              Container(
                  color: Colors.lightGreen,
                  height: 200.0,
                  child: Row(children: [
                    Image(
                        image: NetworkImage(
                            'https://www.tradieshirts.com.au/rshared/ssc/i/riq/5717778/1600/1600/t/0/0/Tradie%20Shirts%20Printed%20Sydney1.jpg?1621509120')),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Type of work:"),
                        Text("The number of worker:"),
                        Text("Order time:"),
                        Text("Money:"),
                        Text("Name:")
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Plumber"),
                        Text("Tradie 1"),
                        Text("on 03 March 2020 14:00"),
                        Text("60USD"),
                        Text("Mike")
                      ],
                    ),

                  ])),

              ElevatedButton(
                child: Text("make a payment"),
                onPressed: () {},
              )
            ],

          )

      ),);

  }


}
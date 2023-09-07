import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


import '../../Routes/route_const.dart';

//ignore: must_be_immutable
class TradieDemo extends StatefulWidget {
  String userId;
  TradieDemo({Key? key, required this.userId}) : super(key: key);

  @override
  TradieDemoState createState() => TradieDemoState();
}

class TradieDemoState extends State<TradieDemo> {
  @override
  Widget build(BuildContext context) {
    String consumer = widget.userId;
    print('tradie selection page consumer ');
    print(consumer);
    return Scaffold(
        appBar: AppBar(
          title: Text('Select Tradie'),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Container(
                          width: 150,
                          height: 150,
                          child: Image(
                            image: AssetImage('images/Tom.jpg'),
                          )),
                      TextButton(
                        onPressed: () {
                         GoRouter.of(context).pushNamed(RouterName.Booking,params: {'userId':consumer,'tradieId':'ptdQtAhIIIQvCt41zFuleVwFwe93'});
                        },
                        child: const Text(
                          'Yuchi',
                          textScaleFactor: 5.0,
                          selectionColor: Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          late var room;
                          await createRoom(consumer,'ptdQtAhIIIQvCt41zFuleVwFwe93').then((value){room = value;});
                          GoRouter.of(context).pushNamed(RouterName.chat, params: {
                            'userId': consumer,
                          });
                        },
                        child: const Text(
                          'chat',
                          textScaleFactor: 5.0,
                          selectionColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                          width: 150,
                          height: 150,
                          child: Image(
                            image: AssetImage('images/Tom.jpg'),
                          )),
                      TextButton(
                        onPressed: () {
                          GoRouter.of(context).pushNamed(RouterName.Booking,params: {'userId':consumer,'tradieId':'s8UFSZOeLnYhcdkWiMQCdfpGSpg1'});
                        },
                        child: const Text(
                          'Siyuan',
                          textScaleFactor: 5.0,
                          selectionColor: Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          late var room;
                          await createRoom(consumer,'s8UFSZOeLnYhcdkWiMQCdfpGSpg1').then((value){room = value;});
                          GoRouter.of(context).pushNamed(RouterName.chat, params: {
                            'userId': consumer,
                          });
                        },
                        child: const Text(
                          'chat',
                          textScaleFactor: 5.0,
                          selectionColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                          width: 150,
                          height: 150,
                          child: Image(
                            image: AssetImage('images/Jack.jpg'),
                          )),
                      TextButton(
                        onPressed: () {
                          GoRouter.of(context).pushNamed(RouterName.Booking,params: {'userId':consumer,'tradieId':'ie7Agh2XGfYiLFVfoVx9YRbZaGq2'});
                        },
                        child: const Text(
                          'Ben',
                          textScaleFactor: 5.0,
                          selectionColor: Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          late var room;
                          await createRoom(consumer,'VZY6dgTgGeQKNMm57X67qYV08H02').then((value){room = value;});
                          GoRouter.of(context).pushNamed(RouterName.chat, params: {
                            'userId': consumer,
                          });
                        },
                        child: const Text(
                          'chat',
                          textScaleFactor: 5.0,
                          selectionColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                          width: 150,
                          height: 150,
                          child: Image(
                            image: AssetImage('images/Jack.jpg'),
                          )),
                      TextButton(
                        onPressed: () {
                          GoRouter.of(context).pushNamed(RouterName.Booking,params: {'userId':consumer,'tradieId':'FW2KJk4LWgOsyCa7nqLKrOfjwzm2'});
                        },
                        child: const Text(
                          'Alice',
                          textScaleFactor: 5.0,
                          selectionColor: Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          late var room;
                          await createRoom(consumer,'FW2KJk4LWgOsyCa7nqLKrOfjwzm2').then((value){room = value;});
                          GoRouter.of(context).pushNamed(RouterName.chat, params: {
                            'userId': consumer,
                          });
                        },
                        child: const Text(
                          'chat',
                          textScaleFactor: 5.0,
                          selectionColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
Future<String> createRoom(consumerId, tradieId) async {
  String id='';
  await FirebaseFirestore.instance.collection('chatRoom').where('users', arrayContains: consumerId).get().then((value){
    if (value.docs.isNotEmpty){
      for(var v in value.docs){
        for(var i in v.data()['users']){
          if(i == tradieId){
            print('find existing room');
            id = v.id;
            break;
          }
        }
      }
      if(id==''){
        print('create new room');
        id = consumerId;
        id = id+tradieId;
        print(id);
        FirebaseFirestore.instance.collection('chatRoom').doc(id).set({'users':[consumerId,tradieId]}).onError((error, stackTrace){print(error);});
      }
    }else{
      id = consumerId;
      id = id+tradieId;
      print(id);
      FirebaseFirestore.instance.collection('chatRoom').doc(id).set({'users':[consumerId,tradieId],'chatRoomId':id}).onError((error, stackTrace){print(error);});
      FirebaseFirestore.instance.collection('chatRoom').doc(id).collection('chats');
    }
  });
  return id;
}



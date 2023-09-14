import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:new_cross_app/Login/utils/constants.dart';
import 'package:new_cross_app/helper/constants.dart';
import 'package:new_cross_app/helper/helper_function.dart';
import 'package:new_cross_app/services/auth_service.dart';
import 'package:new_cross_app/services/database_service.dart';
import 'package:new_cross_app/chat/screens/chat_screen.dart';
import 'package:new_cross_app/chat/screens/search_page.dart';
import 'package:flutter/material.dart';
import '../../Routes/route_const.dart';
import '../widgets/my_tab_bar.dart';

//聊天室列表页面

class ChatRoom extends StatefulWidget {
  String userId;
  ChatRoom({super.key, required this.userId}) {
    if (userId == null || userId.isEmpty) {
      throw ArgumentError("userId cannot be null or empty");
    }
  }

  @override
  _ChatRoomState createState() => _ChatRoomState(userId);
}

final chatRef = FirebaseFirestore.instance.collection('chatRoom');

class _ChatRoomState extends State<ChatRoom> with TickerProviderStateMixin {
  String userId = '';
  late Stream<QuerySnapshot> chatRooms;

  // 构造函数
  _ChatRoomState(String id) {
    if (id == null || id.isEmpty) {
      throw ArgumentError("userId cannot be null or empty");
    }
    this.userId = id;
    chatRooms = chatRef.where('users', arrayContains: userId).snapshots();
  }

  late TabController tabController;
  int currentTabIndex = 0;

  void onTabChange() {
    setState(() {
      currentTabIndex = tabController.index;
    });
  }

  // 聊天室列表
  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "You haven't chatted with anyone yet, "
                    "tap on the search icon  to search for the trade person "
                    "you are interested in communicating with.",
                    textAlign: TextAlign.center,
                    selectionColor: Colors.black,
                  )
                ],
              ),
            ),
          );
        } else {
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var ulist = snapshot.data!.docs[index]['users'] ?? [];
                var TalkerId = '';
                for (var u in ulist) {
                  if (u != userId) {
                    TalkerId = u;
                    break;
                  }
                }
                return ChatRoomsTile(
                  TalkerId: TalkerId,
                  chatRoomId: snapshot.data!.docs[index]["chatRoomId"],
                );
              });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    print("聊天室主页当前用户的ID为: ${Constants.MyId}");
    tabController = TabController(length: 1, vsync: this);
    tabController.addListener(() {
      onTabChange();
    });
    //getUserInfogetChats();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  // 获取用户信息和聊天
  getUserInfogetChats() async {
    Constants.MyId = (await HelperFunctions.getUserIdFromSF())!;
    DatabaseService().getUserChats(Constants.MyId).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jemma'),
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).pushNamed(RouterName.homePage, params: {
              'userId': userId,
            });
          },
          icon: const Icon(Icons.arrow_back),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 0,
            child: Container(
              color: kMenuColor,
              child: MyTabBar(tabController: tabController),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )),
              child: TabBarView(
                controller: tabController,
                children: [
                  chatRoomsList(),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
        onPressed: () {
          GoRouter.of(context).pushNamed(RouterName.ChatSearch, params: {
            'userId': userId,
          });
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String TalkerId;
  final String chatRoomId;

  ChatRoomsTile({Key? key, required this.TalkerId, required this.chatRoomId})
      : super(key: key);
  String TalkeruserName = '';

  Stream<Map<String, dynamic>> GetLastMessage() async* {
    final controller = StreamController<Map<String, dynamic>>();
    controller.onListen = () async {
      try {
        // 添加了空值默认处理
        TalkeruserName = (await HelperFunctions.getUserNameFromId(TalkerId)) ??
            'Unknown User';
        print("聊天的对象是");
        print(TalkeruserName);
        await for (var querySnapshot in FirebaseFirestore.instance
            .collection('chatRoom')
            .doc(chatRoomId)
            .collection('chats')
            .orderBy('time', descending: true)
            .limit(1)
            .snapshots()) {
          if (querySnapshot.docs.isNotEmpty) {
            Map<String, dynamic> messageData =
                (querySnapshot.docs[0].data() as Map<String, dynamic>);
            String messageText = messageData['message'];
            String sender = messageData['sendBy'];
            bool Readstatus = messageData['Isread'];
            bool isUnreadAndNotSentByUser =
                Readstatus == false && sender != Constants.MyId;
            controller
                .add({'text': messageText, 'status': isUnreadAndNotSentByUser});
          } else {
            controller.add({'text': "Start your chat!", 'status': false});
          }
        }
      } catch (e) {
        print(e.toString());
        controller.addError(e);
      }
    };
    yield* controller.stream;
    controller.onCancel = () {
      controller.close();
    };
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: GetLastMessage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading..."); // 添加加载状态
        }
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}"); // 添加错误状态
        }

        // 检查 snapshot.data 是否为 null
        if (snapshot.data == null) {
          return Text("Start your chat!"); // 或其他默认文本
        }

        // 使用空安全操作符
        String latestMessage = snapshot.data?['text'] ?? "Start your chat!";
        bool isUnreadAndNotSentByUser = snapshot.data?['status'] ?? false;

        return GestureDetector(
          onTap: () {
            GoRouter.of(context).pushNamed(RouterName.ChatRoom, params: {
              'userId': Constants.MyId,
              'chatRoomId': chatRoomId,
            });

            DatabaseService().updateMessageReadStatus(chatRoomId);
          },
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(
                      //TODO: username
                      TalkeruserName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 87, 87, 87),
                        fontSize: 16,
                        fontFamily: 'OverpassRegular',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            TalkeruserName,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 87, 87, 87),
                              fontSize: 18,
                              fontFamily: 'OverpassRegular',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            latestMessage,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontFamily: 'OverpassRegular',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 16,
                        width: 16,
                        decoration: BoxDecoration(
                          color: isUnreadAndNotSentByUser // 这里是您的条件
                              ? Colors.green
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: isUnreadAndNotSentByUser // 添加这个条件判断
                            ? Icon(
                                Icons.circle,
                                size: 16.0,
                                color: Colors.green,
                              )
                            : null, // 如果不满足条件，则不显示图标
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:go_router/go_router.dart'; // For routing
import 'package:new_cross_app/chat/screens/chat_home_screen.dart'; // Chat home screen
import 'package:new_cross_app/services/database_service.dart'; // Database service
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firebase Firestore
import 'package:flutter/material.dart'; // Flutter Material Design

import '../../Login/utils/constants.dart'; // Constants
import '../../Routes/route_const.dart'; // Route constants
import '../../helper/constants.dart'; // Helper constants

// Search screen for chat application
class Search extends StatefulWidget {
  String userId;
  Search({super.key, required this.userId});
  @override
  _SearchState createState() => _SearchState(userId: userId);
}

class _SearchState extends State<Search> {
  String userId;
  _SearchState({required this.userId});

  // Database service instance
  DatabaseService databaseservice = DatabaseService();

  // Search controller
  TextEditingController searchEditingController = TextEditingController();

  // Query snapshot for search results
  late QuerySnapshot searchResultSnapshot;

  // Loading and search state flags
  bool isLoading = false;
  bool haveUserSearched = false;

  // Initiates the search operation
  initiateSearch() async {
    if (searchEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await databaseservice
          .searchByName(searchEditingController.text)
          .then((snapshot) {
        searchResultSnapshot = snapshot;
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  Widget userList() {
    if (haveUserSearched) {
      if (searchResultSnapshot.docs.length == 0) {
        return Center(
          child: Text(
            "Can't find the tradie! Please check his name.",
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
        );
      }
      return ListView.builder(
        shrinkWrap: true,
        itemCount: searchResultSnapshot.docs.length,
        itemBuilder: (context, index) {
          return userTile(
            searchResultSnapshot.docs[index]['fullName'],
            searchResultSnapshot.docs[index]['email'],
            searchResultSnapshot.docs[index]['uid'],
          );
        },
      );
    }
    return Container();
  }

  /// 1.create a chatroom, send user to the chatroom, other userdetails
  sendMessage(String SearcheduserId) {
    List<String> users = [Constants.MyId, SearcheduserId];

    String chatRoomId = getChatRoomId(Constants.MyId, SearcheduserId);

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId": chatRoomId,
    };

    databaseservice.addChatRoom(chatRoom, chatRoomId);

    GoRouter.of(context).pushNamed(RouterName.ChatRoom, params: {
      'userId': userId,
      'chatRoomId': chatRoomId,
    });
  }

  Widget userTile(String SearcheduserName, String SearcheduserEmail,
      String SearchedUserId) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                SearcheduserName,
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
              Text(
                SearcheduserEmail,
                style: const TextStyle(color: Colors.black, fontSize: 16),
              )
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              sendMessage(SearchedUserId);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.green, borderRadius: BorderRadius.circular(24)),
              child: const Text(
                "Message",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }

  getChatRoomId(String a, String b) {
    // 打印字符串 a 和 b 的长度
    print("Length of string a: ${a.length}");
    print("Length of string b: ${b.length}");
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            //Navigator.pushNamed(context, Screen.home.getURL());
            GoRouter.of(context).pushNamed(RouterName.chat, params: {
              'userId': userId,
            });
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Jemma',
          //style: GoogleFonts.grandHotel(fontSize: 36),
        ),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    color: kMenuColor,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchEditingController,
                            style: const TextStyle(color: Colors.grey),
                            decoration: const InputDecoration(
                                hintText: "search username ...",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                                border: InputBorder.none),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            initiateSearch();
                          },
                          child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                      colors: [
                                        Color(0x36FFFFFF),
                                        Color(0x0FFFFFFF)
                                      ],
                                      begin: FractionalOffset.topLeft,
                                      end: FractionalOffset.bottomRight),
                                  borderRadius: BorderRadius.circular(40)),
                              padding: const EdgeInsets.all(12),
                              child: const Icon(
                                Icons.search,
                                color: Colors.grey,
                              )),
                        )
                      ],
                    ),
                  ),
                  userList()
                ],
              ),
            ),
    );
  }
}

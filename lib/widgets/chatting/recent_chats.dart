import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:jemma/models/message.dart';
import 'package:jemma/screens/chat_room.dart';


class RecentChats extends StatelessWidget {
  const RecentChats({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 30),
          child: Row(
            children: [
              const Text(
                'Recent Chats',
                style: TextStyle(
                  color: Color(0xff686795),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.search,
                color: Color(0xFFDDFFB3),
              )
            ],
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: recentChats.length,
            itemBuilder: (context, int index) {
              final recentChat = recentChats[index];
              return Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: AssetImage(recentChat.avatar!),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              CupertinoPageRoute(builder: (context) {
                                return ChatRoom(
                                  username: recentChat.senderName,
                                  avatar: recentChat.avatar!,
                                );
                              }));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              recentChat.senderName,
                              style: const TextStyle(
                                color: Color(0xff686795),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5,
                              ),
                            ),
                            Text(
                              recentChat.text,
                              style: const TextStyle(
                                color: Color(0xffAEABC9),
                                fontSize: 14,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CircleAvatar(
                            radius: 8,
                            backgroundColor: const Color(0xffEE1D1D),
                            child: Text(
                              recentChat.unreadCount.toString(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            recentChat.time,
                            style: const TextStyle(
                              color: Color(0xffAEABC9),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          )
                        ],
                      ),
                    ],
                  ));
            })
      ],
    );
  }
}

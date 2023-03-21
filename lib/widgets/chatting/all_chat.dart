
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jemma/models/message.dart';
import 'package:jemma/screens/chat_room.dart';


class AllChats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              const Text(
                'All Chats',
                style: TextStyle(
                  color: Color(0xff686795),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: allChats.length,
            itemBuilder: (context, int index) {
              final allChat = allChats[index];
              return Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: AssetImage(allChat.avatar!),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              CupertinoPageRoute(builder: (context) {
                                return ChatRoom(
                                  username: allChat.senderName,
                                  avatar: allChat.avatar!,
                                );
                              }));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              allChat.senderName,
                              style: const TextStyle(
                                color: Color(0xff686795),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5,
                              ),
                            ),
                            Text(
                              allChat.text,
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
                          allChat.unreadCount == 0
                              ? const Icon(
                            Icons.done_all,
                            color: Color(0xffAEABC9),
                          )
                              : CircleAvatar(
                            radius: 8,
                            backgroundColor: const Color(0xffEE1D1D),
                            child: Text(
                              allChat.unreadCount.toString(),
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
                            allChat.time,
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
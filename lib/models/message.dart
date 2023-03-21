import 'package:jemma/models/customer.dart';
import 'package:jemma/models/tradie.dart';

class Message {
  final int senderID;
  final String senderName;
  final String? avatar;
  final String time;
  final int? unreadCount;
  final bool? isRead;
  final String text;

  Message({
    required this.senderID,
    required this.senderName,
    this.avatar,
    required this.time,
    this.unreadCount,
    this.isRead,
    required this.text
  });

  factory Message.fromCustomer({
    required Customer customer,
    String? avatar,
    required String time,
    int? unreadCount,
    bool? isRead,
    required String text,
  }) {
    return Message(
      senderID: customer.id,
      senderName: customer.firstName ?? 'Anonymous',
      time: time,
      unreadCount: unreadCount,
      isRead: isRead,
      text: text
    );
  }

  factory Message.fromTradie({
    required Tradie tradie,
    String? avatar,
    required String time,
    int? unreadCount,
    bool? isRead,
    required String text,
  }) {
    return Message(
        senderID: tradie.id,
        senderName: tradie.firstName ?? 'Anonymous',
        time: time,
        unreadCount: unreadCount,
        isRead: isRead,
        text: text
    );
  }

}


final List<Message> recentChats = [
  Message(
    senderID: 0,
    senderName: 'Addison',
    avatar: 'assets/chatting_avatar/Addison.jpg',
    time: '01:25',
    text: "typing...",
    unreadCount: 1,
  ),
  Message(
    senderID: 1,
    senderName: 'Jason',
    avatar: 'assets/chatting_avatar/Jason.jpg',
    time: '12:46',
    text: "Do you need someone to fix it up?",
    unreadCount: 1,
  ),
  Message(
    senderID: 2,
    senderName: 'Deanna',
    avatar: 'assets/chatting_avatar/Deanna.jpg',
    time: '05:26',
    text: "I'll arrange for you.",
    unreadCount: 3,
  ),
  Message(
      senderID: 3,
      senderName: 'Nathan',
      avatar: 'assets/chatting_avatar/Nathan.jpg',
      time: '12:45',
      text: "Let me see what I can do.",
      unreadCount: 2),
];

final List<Message> allChats = [
  Message(
    senderID: 4,
    senderName: 'Virgil',
    avatar: 'assets/chatting_avatar/Virgil.jpg',
    time: '12:59',
    text: "No! I'm kinda busy right now.",
    unreadCount: 0,
    isRead: true,
  ),
  Message(
    senderID: 5,
    senderName: 'Stanley',
    avatar: 'assets/chatting_avatar/Stanley.jpg',
    time: '10:41',
    text: "Got a tradie already.",
    unreadCount: 1,
    isRead: false,
  ),
  Message(
    senderID: 6,
    senderName: 'Leslie',
    avatar: 'assets/chatting_avatar/Leslie.jpg',
    time: '05:51',
    unreadCount: 0,
    isRead: true,
    text: "just signed up for a customer",
  ),
  Message(
    senderID: 7,
    senderName: 'Judd',
    avatar: 'assets/chatting_avatar/Judd.jpg',
    time: '10:16',
    text: "May I ask you something?",
    unreadCount: 2,
    isRead: false,
  ),
];

final List<Message> messages = [
  Message(
    senderID: 0,
    senderName: 'Addison',
    time: '12:09 AM',
    avatar: 'assets/chatting_avatar/Addison.jpg',
    text: "...",
  ),
  Message(
    senderID: -1,
    senderName: 'Yojer',
    time: '12:05 AM',
    isRead: true,
    text: "I’m going home.",
  ),
  Message(
    senderID: -1,
    senderName: 'Yojer',
    time: '12:05 AM',
    isRead: true,
    text: "See, I was right, this doesn’t interest me.",
  ),
  Message(
    senderID: 0,
    senderName: 'Addison',
    time: '11:58 PM',
    avatar: 'assets/chatting_avatar/Addison.jpg',
    text: "I sign your paychecks.",
  ),
  Message(
    senderID: 0,
    senderName: 'Addison',
    time: '11:58 PM',
    avatar: 'assets/chatting_avatar/Addison.jpg',
    text: "You think we have nothing to talk about?",
  ),
  Message(
    senderID: -1,
    senderName: 'Yojer',
    time: '11:45 PM',
    isRead: true,
    text:
    "Well, because I had no intention of being in your office. 20 minutes ago",
  ),
  Message(
    senderID: 0,
    senderName: 'Addison',
    time: '11:30 PM',
    avatar: 'assets/chatting_avatar/Addison.jpg',
    text: "I was expecting you in my office 20 minutes ago.",
  ),
];
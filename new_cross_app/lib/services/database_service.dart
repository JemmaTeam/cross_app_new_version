import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_cross_app/helper/constants.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // Reference to the user collection
  final CollectionReference UserCollection =
      FirebaseFirestore.instance.collection("users");

  // Reference to the chat list collection
  final CollectionReference ChatListCollection =
      FirebaseFirestore.instance.collection("groups");

  // Save user data
  Future savingCustomerData(String fullName, String email) async {
    return await UserCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "Is_Tradie": false,
      "Phone": "",
      "address": "",
      "Chatlist": [],
      "profilePic": "",
      "uid": uid,
      "NeedEmailInformed": false,
    });
  }

  // Get user data by email
  Future gettingUserData(String email) async {
    try {
      QuerySnapshot snapshotC =
          await UserCollection.where("email", isEqualTo: email).get();
      return snapshotC.docs.isEmpty ? null : snapshotC;
    } catch (e) {
      print("An error occurred: $e");
      return null;
    }
  }

  // Search user by name and Is_Tradie attribute
  Future<QuerySnapshot> searchByName(String searchField) async {
    return await UserCollection.where("fullName", isEqualTo: searchField)
        .where("Is_Tradie", isEqualTo: true)
        .get();
  }

  // Add a new chat room
  Future<bool> addChatRoom(chatRoom, chatRoomId) async {
    try {
      await FirebaseFirestore.instance
          .collection("chatRoom")
          .doc(chatRoomId)
          .set(chatRoom);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // Get chats for a specific chat room
  getChats(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }

  // Add a message to a chat room
  Future<void> addMessage(String chatRoomId, chatMessageData) async {
    try {
      await FirebaseFirestore.instance
          .collection("chatRoom")
          .doc(chatRoomId)
          .collection("chats")
          .add(chatMessageData);
    } catch (e) {
      print(e.toString());
    }
  }

  // Get user chats
  getUserChats(String itIsMyId) async {
    return await FirebaseFirestore.instance
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyId)
        .snapshots();
  }

  // Update the read status of messages in a chat room
  void updateMessageReadStatus(String chatRoomId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(chatRoomId)
          .collection('chats')
          .where('sendBy', isNotEqualTo: Constants.MyId)
          .where('Isread', isEqualTo: false)
          .limit(50)
          .get();

      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        String messageId = documentSnapshot.id;
        DocumentReference messageRef = FirebaseFirestore.instance
            .collection('chatRoom')
            .doc(chatRoomId)
            .collection('chats')
            .doc(messageId);

        batch.update(messageRef, {'Isread': true});
      }

      // Commit the batched write
      await batch.commit();
    } catch (e) {
      print('Error: $e');
    }
  }
}

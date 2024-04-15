import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:go_router/go_router.dart';
//import 'package:image_picker_web/image_picker_web.dart';
import 'package:new_cross_app/chat/screens/chat_home_screen.dart';
import 'package:new_cross_app/helper/constants.dart';
import 'package:new_cross_app/services/database_service.dart';
//import 'package:new_cross_app/chat/chatting/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import '../../Routes/route_const.dart';
import '../../helper/helper_function.dart';
import '../../main.dart';
import 'package:path/path.dart' as Path;
import 'package:file_picker/file_picker.dart';



//Chat类是一个完整的聊天页面，包括显示消息、获取聊天对象的用户名、发送和接收消息等功能

class Chat extends StatefulWidget {
  final String chatRoomId;
  final String userId;

  //存储用户选择的图片
  File? selectedImage;


  Chat({super.key, required this.chatRoomId, required this.userId});

  @override
  _ChatState createState() => _ChatState();
}

final chatRef = FirebaseFirestore.instance.collection('chatRoom');

class _ChatState extends State<Chat> {
  bool showEmojiPicker = false;
  Stream<QuerySnapshot>? chats;
  TextEditingController messageEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController(); // 添加 ScrollController，实现让聊天界面在发送新消息后自动滚动到底部

  String TalkeruserName = '';

  // 存储用户选择的图片
  File? selectedImage;
  // 追踪图片上传状态
  bool isUploading = false;
  // 追踪图片上传的进度
  double uploadProgress = 0.0;

  Widget chatMessages() {
    if (chats == null) {
      return Container();
    }

    return StreamBuilder(
      stream: chats!,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
          reverse: false,
          itemCount: snapshot.data?.docs.length ?? 0,
          itemBuilder: (context, index) {
            final Map<String, dynamic>? messageData =
            snapshot.data?.docs[index].data()
            as Map<String, dynamic>?;
            final DateTime sendTime = DateTime.fromMillisecondsSinceEpoch(
                messageData?['time'] ?? 0);
            final DateFormat formatter = DateFormat('yy/MM/dd  HH:mm');
            final String formattedTime = formatter.format(sendTime);
            final bool Isread = messageData?['Isread'];
            final bool isImage = messageData?['isImage'] ?? false;
            return MessageTile(
              message: messageData?['message'],
              sendByMe: Constants.MyId == messageData?['sendBy'],
              sendTime: formattedTime,
              Isread: Isread,
              chatRoomId: widget.chatRoomId,
              isImage: isImage,  // 传递isImage参数
            );
          },
        )
            : Container();
      },
    );
  }

  void toggleEmojiPicker() {
    setState(() {
      showEmojiPicker = !showEmojiPicker;
    });
  }

  void onEmojiSelected(Category? category, Emoji emoji) {
    setState(() {
      messageEditingController.text += emoji.emoji;
    });
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.MyId,
        "message": messageEditingController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
        'Isread': false,
      };

      DatabaseService().addMessage(widget.chatRoomId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
        //latestMessageId = '';
      });

      // 滚动到底部
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  initState() {
    super.initState();
    print("聊天室内部当前用户的ID为: ${Constants.MyId}");
    DatabaseService().getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
    getTalkerUserName();

    // 在 initState 中监听文本框的编辑完成事件
    messageEditingController.addListener(_onMessageEditComplete);
  }

  // 获取聊天对象的用户名的函数
  void getTalkerUserName() async {
    // 聊天室ID是由两个用户ID组合而成的，例如 "user1_user2"
    List<String> users = widget.chatRoomId.split("_");
    String talkerUserId =
    users.first == Constants.MyId ? users.last : users.first;

    // 从数据库中获取聊天对象的用户名
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(talkerUserId)
        .get();
    setState(() {
      TalkeruserName =
      documentSnapshot['fullName']; // 假设'userName'是数据库中存储用户名的字段
    });
  }

  // 在数据库中插入上传照片的信息
  void addImageMessage(String imageUrl) {
    Map<String, dynamic> chatMessageMap = {
      "sendBy": Constants.MyId,
      "message": imageUrl, // 使用图片的URL作为消息内容
      'time': DateTime.now().millisecondsSinceEpoch,
      'Isread': false,
      'isImage': true, // 添加新的属性，表示这是一张图片
    };
    DatabaseService().addMessage(widget.chatRoomId, chatMessageMap);

    // 重置上传进度
    setState(() {
      uploadProgress = 0.0;
    });

    // 滚动到底部
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose(); // 在组件销毁时释放 ScrollController
    super.dispose();
  }

  void _onMessageEditComplete() {
    if (messageEditingController.text.isNotEmpty &&
        messageEditingController.text.endsWith('\n')) {
      // 如果文本框内容不为空且以换行符结尾，则发送消息
      addMessage();
    }
  }


  @override
  Widget build(BuildContext context) {
    String userId = widget.userId;
    //print("当前用户的id为");
    //print(userId);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).pushNamed(RouterName.chat, params: {
              'userId': userId,
            });
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          TalkeruserName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: StreamBuilder(
              stream: chats, // 使用正确的 chats 流
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // 如果连接状态为等待，显示加载指示器
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  // 如果出现错误，显示错误消息
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return ListView.builder(
                    controller: _scrollController, // 将 ScrollController 分配给 ListView
                    reverse: true, // 设置为 true，以便从底部开始滚动
                    itemCount: snapshot.data?.docs.length ?? 0, // 获取聊天消息文档列表的长度
                    itemBuilder: (context, index) { // 构建每个列表项的回调函数
                      // 计算实际索引，以便正确获取消息数据
                      final int reversedIndex = snapshot.data!.docs.length - index - 1;
                      final Map<String, dynamic>? messageData =
                      snapshot.data?.docs[reversedIndex].data() as Map<String, dynamic>?;

                      final DateTime sendTime = DateTime.fromMillisecondsSinceEpoch( // 解析消息发送时间
                          messageData?['time'] ?? 0
                      );
                      final DateFormat formatter = DateFormat('yy/MM/dd  HH:mm'); // 时间格式化器
                      final String formattedTime = formatter.format(sendTime); // 格式化发送时间
                      final bool Isread = messageData?['Isread']; // 检查消息是否已读
                      final bool isImage = messageData?['isImage'] ?? false; // 检查消息是否为图片

                      return MessageTile( // 返回消息列表项组件
                        message: messageData?['message'], // 消息内容
                        sendByMe: Constants.MyId == messageData?['sendBy'], // 检查消息是否由当前用户发送
                        sendTime: formattedTime, // 格式化后的发送时间
                        Isread: Isread, // 是否已读
                        chatRoomId: widget.chatRoomId, // 聊天室 ID
                        isImage: isImage, // 是否为图片消息
                      );
                    },
                  );
                }
              },
            ),
          ),
          if (uploadProgress > 0.0 && uploadProgress < 1.0) // 当进度在这个范围内时显示
            Column(
              children: [
                LinearProgressIndicator(value: uploadProgress),
                Text("image is uploading..."),
              ],
            ),
          widget.selectedImage == null
              ? Container()
              : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Image.file(widget.selectedImage!),
          ),
          Visibility(
            visible: showEmojiPicker,
            child: SizedBox(
              height: 250, // 降低高度为250
              width: MediaQuery.of(context).size.width, // 设置宽度与屏幕宽度相等
              child: EmojiPicker(
                config: const Config(
                  columns: 7,
                  emojiSizeMax: 24.0,
                  verticalSpacing: 0,
                  horizontalSpacing: 0,
                  gridPadding: EdgeInsets.zero,
                  initCategory: Category.RECENT,
                  bgColor: Color(0xFFF2F2F2),
                  indicatorColor: Colors.blue,
                  iconColor: Colors.grey,
                  iconColorSelected: Colors.blue,
                  backspaceColor: Colors.blue,
                  skinToneDialogBgColor: Colors.white,
                  skinToneIndicatorColor: Colors.grey,
                  enableSkinTones: true,
                  recentTabBehavior: RecentTabBehavior.RECENT,
                  recentsLimit: 28,
                  noRecents: Text(
                    'No Recents',
                    style: TextStyle(fontSize: 20, color: Colors.black26),
                    textAlign: TextAlign.center,
                  ), // Needs to be const Widget
                  loadingIndicator:
                  SizedBox.shrink(), // Needs to be const Widget
                  tabIndicatorAnimDuration: kTabScrollDuration,
                  categoryIcons: CategoryIcons(),
                  buttonMode: ButtonMode.MATERIAL,
                ),
                onEmojiSelected: onEmojiSelected,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: Colors.white,
            height: 100,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.emoji_emotions_outlined,
                            size: 28,
                          ),
                          onPressed: toggleEmojiPicker,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        //上传图片的按钮
                        IconButton(
                          icon: Icon(Icons.photo),
                          onPressed: () async {
                            try {
                              FilePickerResult? result = await FilePicker.platform.pickFiles(
                                type: FileType.image,
                              );

                              if (result != null) {
                                PlatformFile file = result.files.first;
                                Uint8List? imageData = file.bytes;

                                if (imageData != null) {
                                  // 上传到 Firebase
                                  Reference storageReference = FirebaseStorage.instance.ref().child('chat_images/${file.name}');
                                  UploadTask uploadTask = storageReference.putData(imageData);

                                  // 监听上传进度
                                  uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
                                    setState(() {
                                      uploadProgress = snapshot.bytesTransferred.toDouble() / snapshot.totalBytes.toDouble();
                                    });
                                  });

                                  // 等待上传完成并获取下载URL
                                  TaskSnapshot snapshot = await uploadTask.whenComplete(() => {});
                                  String imageUrl = await snapshot.ref.getDownloadURL();

                                  // 保存图片URL到聊天数据库
                                  addImageMessage(imageUrl);

                                  // 重置上传进度
                                  setState(() {
                                    uploadProgress = 0.0;
                                  });
                                }
                              }
                            } catch (error) {
                              print("An error occurred: $error");
                              // 显示上传失败的提示
                              final failSnackBar = SnackBar(content: Text('Image upload failed!'));
                              ScaffoldMessenger.of(context).showSnackBar(failSnackBar);
                            }
                          },
                        ),

                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            controller: messageEditingController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Type your message ...',
                              hintStyle: TextStyle(color: Colors.grey[500]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                GestureDetector(
                  onTap: () {
                    // Do something when the CircleAvatar is tapped
                    addMessage();
                    //print('CircleAvatar tapped!');
                  },
                  child: const CircleAvatar(
                    backgroundColor: Color(0xFF4CAF50),
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final String sendTime;
  final bool Isread;
  final String chatRoomId;
  final bool isImage;  // 新增属性

  const MessageTile({
    Key? key,
    required this.message,
    required this.sendByMe,
    required this.sendTime,
    required this.Isread,
    required this.chatRoomId,
    this.isImage = false,  // 默认值为 false
  }) : super(key: key);

  void _viewImage(BuildContext context) {
    if (isImage) {
      // 如果是图片消息，则打开放大图片的页面或对话框
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Container(
            child: Image.network(
              message,
              fit: BoxFit.contain, // 使图片适应对话框
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: GestureDetector(
        onTap: () => _viewImage(context), // 添加点击事件
        child: Column(
          crossAxisAlignment:
          sendByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: sendByMe
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Text(
                  sendTime,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.done_all,
                  size: 16,
                  color: sendByMe
                      ? (Isread ? Colors.green : Colors.grey[600])
                      : Colors.white,
                )
              ],
            ),
            Container(
              padding: EdgeInsets.only(
                top: 8,
                bottom: 8,
                left: sendByMe ? 0 : 24,
                right: sendByMe ? 24 : 0,
              ),
              alignment:
              sendByMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: sendByMe
                    ? const EdgeInsets.only(left: 30)
                    : const EdgeInsets.only(right: 30),
                padding: const EdgeInsets.symmetric(
                  vertical: 17,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  borderRadius: sendByMe
                      ? const BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23),
                  )
                      : const BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23),
                  ),
                  color: sendByMe ? const Color(0xFF4CAF50) : Colors.grey[200],
                ),
                child: isImage
                    ? Container(
                  width: MediaQuery.of(context).size.width /
                      4, // 设置宽度为屏幕的四分之一
                  height: MediaQuery.of(context).size.height /
                      4, // 设置高度为屏幕的四分之一
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      message,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
                    : Text(
                  message,
                  textAlign: sendByMe ? TextAlign.right : TextAlign.left,
                  style: TextStyle(
                    color: sendByMe ? Colors.white : Colors.black,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
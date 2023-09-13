import 'package:flutter/material.dart';
//import 'package:new_cross_app/chat/screens/chat_screen.dart';

//定义了一个名为 buildChatComposer 的函数，该函数返回一个 Container 组件，用于构建聊天应用中的消息输入区域。
//没有产生实际功能，作为一个模板或示例

Container buildChatComposer() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    color: Colors.white,
    height: 100,
    child: Row(
      children: [
        //输入框的容器
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
                //表情图标按钮 (IconButton): 用于打开表情选择器或其他功能，但目前点击它不会做任何事情。
                IconButton(
                  icon: const Icon(
                    Icons.emoji_emotions_outlined,
                    size: 28,
                  ),
                  onPressed: () {},
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  //文本输入框 (TextField): 允许用户输入消息。它的边框被移除了，而且有一个灰色的提示文本“Type your message ...”。
                  child: TextField(
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
        //发送按钮: 使用GestureDetector包裹CircleAvatar，这样当用户点击这个圆形头像时，会触发onTap回调函数
        GestureDetector(
          onTap: () {
            // Do something when the CircleAvatar is tapped
            //addMessage();
            print('CircleAvatar tapped!');
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
  );
}

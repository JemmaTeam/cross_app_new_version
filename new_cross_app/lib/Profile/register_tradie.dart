import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_cross_app/Login/utils/constants.dart';
import 'package:new_cross_app/Login/utils/responsive.dart';
import 'package:logger/logger.dart';
import 'package:new_cross_app/Profile/profile_home.dart';
import 'package:new_cross_app/services/auth_service.dart';
import 'package:sizer/sizer.dart';
import '../main.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class RegisterTradiePage extends StatefulWidget { // 定义一个新的有状态小部件RegisterTradiePage
  final String uid;
  RegisterTradiePage({Key? key, required this.uid}) : super(key: key);
  @override
  State<RegisterTradiePage> createState() => _RegisterTradiePage(); // 创建一个_State
}

class _RegisterTradiePage extends State<RegisterTradiePage> { // 实现_State

  final TextEditingController licenseController = TextEditingController(); // 创建一个控制器用于输入框
  AuthService authService = AuthService(); // AuthService是一个未定义的服务，用于进行身份验证

  final logger = Logger(
    printer: PrettyPrinter(),
  ); // 初始化日志记录器

  final jemmaTitle = Center( // 定义中心标题
    child: FittedBox(
        fit: BoxFit.contain,
        child: Text("Jemma", style: GoogleFonts.parisienne(fontSize: 40.sp))),
  );

  final _formKey = GlobalKey<FormState>(); // 创建一个全局键，用于后续验证表单，**这个暂时没有用

  final TextEditingController postcodeController = TextEditingController(); // 创建一个新的控制器用于postcode的输入框

  String? selectedWorkingType; //定义一个String变量以保存选定的“working type
  File? _imageFile;//添加一个File对象，用于存储选择的图片


  @override
  Widget build(BuildContext context) { // build函数，用于构建界面
    var size = MediaQuery.of(context).size; // 获取当前媒体查询数据，例如屏幕尺寸
    return Scaffold( // 使用脚手架构建基础结构
        body: SafeArea( // 安全区域，避免穿越通知栏等
          child: ConstrainedBox( // 约束框
            constraints: BoxConstraints(minHeight: 100.ph(size)), // 最小高度约束
            child: Stack( // 使用堆栈布局
              children: [
                SingleChildScrollView( // 允许垂直滚动
                  child: Form( // 表单
                    key: _formKey, // 指定全局键，**这个暂时没有用
                    child: Column( // 列布局
                        mainAxisSize: MainAxisSize.min, // 最小主轴尺寸
                        children: [
                          ConstrainedBox( // 约束框
                              constraints: BoxConstraints(minHeight: 30.ph(size)), // 最小高度约束
                              child: jemmaTitle), // 插入之前定义的标题
                          SizedBox(height: max(2.ph(size), 20)), // 空间填充，垂直间距

                          Center(
                            child: Container(
                              width: 300, // 设置宽度为200
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: 'Working Type',
                                  hintText: 'Select your working type',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                  ),
                                ),
                                value: selectedWorkingType,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedWorkingType = newValue;
                                  });
                                },
                                items: <String>[
                                  'AirconMechanic',
                                  'BrickLayer',
                                  'Carpenter',
                                  'CarpetLayer',
                                  'Decking',
                                  'Electrcian',
                                  'Fencing',
                                  'GasPlumber',
                                  'Glazier',
                                  'HairAndMakeUp',
                                  'HomeRenovation',
                                  'Insulation'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          SizedBox(height: max(2.ph(size), 20)),
                          //
                          // Text('UID: ${widget.uid}'), // 添加这行代码来显示uid
                          // SizedBox(height: max(2.ph(size), 20)),

                          // 添加一个新的输入框用于postcode
                          Center(
                            child: Container(
                              width: 300,
                              child: TextField(
                                controller: postcodeController, // 使用新的控制器
                                decoration: InputDecoration(
                                  labelText: 'Enter Postcode',
                                  hintText: 'Input your postcode here',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: max(2.ph(size), 20)), // 添加垂直间距

                          Column(
                            children: [
                              Container(
                                width: 300,
                                child: TextField(
                                  controller: licenseController,
                                  decoration: InputDecoration(
                                    labelText: 'Enter tradie license',
                                    hintText: 'Input your tradie license here',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10), // 空间填充，垂直间距
                              // ElevatedButton(
                              //   onPressed: () async {
                              //     // 定义一个异步的onPressed函数，这个函数在按钮被点击后触发
                              //
                              //     try {
                              //       FilePickerResult? result = await FilePicker.platform.pickFiles(
                              //         type: FileType.custom,
                              //         allowedExtensions: ['jpg', 'png', 'jpeg'],
                              //       );
                              //
                              //     print("Result: $result");
                              //     print("Path: ${result?.files.single.path}");
                              //
                              //     if (result != null && result.files.single.path != null) {  // 如果用户成功选取了一个文件
                              //
                              //       print("Result: $result");
                              //       print("Path: ${result?.files.single.path}");
                              //
                              //       File file = File(result.files.single.path!);  // 从选取结果中获取文件
                              //       String fileName = DateTime.now().millisecondsSinceEpoch.toString();  // 创建一个基于当前时间的文件名
                              //
                              //       FirebaseStorage storage = FirebaseStorage.instance;  // 获取FirebaseStorage的实例
                              //       // 在Firebase Storage引用路径中包括userId，这样每个用户都将在其自己的文件夹中有文件。
                              //       UploadTask task = storage.ref('users/${widget.uid}/$fileName').putFile(file);
                              //
                              //       task.snapshotEvents.listen((TaskSnapshot snapshot) {
                              //         double progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
                              //         print('Upload progress: $progress%');
                              //         // You can update UI with progress here if needed
                              //       }, onError: (Object e) {
                              //         // Handle error during upload
                              //         ScaffoldMessenger.of(context).showSnackBar(
                              //           SnackBar(
                              //             content: Text("图片上传失败"),
                              //           ),
                              //         );
                              //       });
                              //
                              //       try {
                              //         await task;  // 等待任务完成
                              //         final String downloadUrl = await task.snapshot.ref.getDownloadURL();
                              //         await FirebaseFirestore.instance
                              //             .collection('users')
                              //             .doc(widget.uid)
                              //             .update({'lincensePic': downloadUrl});
                              //
                              //         ScaffoldMessenger.of(context).showSnackBar(
                              //           SnackBar(
                              //             content: Text("图片上传成功"),
                              //           ),
                              //         );
                              //       } catch (error) {
                              //         ScaffoldMessenger.of(context).showSnackBar(
                              //           SnackBar(
                              //             content: Text("图片上传失败"),
                              //           ),
                              //         );
                              //       }
                              //     } else {
                              //       print("FilePickerResult is null or path is null");
                              //       ScaffoldMessenger.of(context).showSnackBar(
                              //         SnackBar(
                              //           content: Text("没有选取文件"),
                              //         ),
                              //       );
                              //     }
                              //   }
                              //     catch (e) {
                              //     print("Error picking file: $e");
                              //     ScaffoldMessenger.of(context).showSnackBar(
                              //     SnackBar(
                              //     content: Text("文件选择出错"),
                              //     ),
                              //     );
                              //     }
                              //   },
                              //   style: ElevatedButton.styleFrom(
                              //     backgroundColor: kLogoColor,
                              //     minimumSize: Size(300, 60), // 调整按钮尺寸
                              //   ),
                              //   child: Row(
                              //     mainAxisSize: MainAxisSize.min, // 水平方向上尽可能小的尺寸
                              //     children: [
                              //       Icon(Icons.upload),
                              //       SizedBox(width: 5),
                              //       Text("Upload License Picture"), // 添加按钮的提示
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                          SizedBox(height: max(2.ph(size), 20)), // 空间填充，垂直间距


                          SizedBox( // 注册按钮的约束框
                              // constraints: const BoxConstraints(maxWidth: 100), // 按钮的最大宽度约束
                              // child: SizedBox( // 固定尺寸的空间填充
                                width: 100, // 宽度
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: const StadiumBorder(),
                                      padding: const EdgeInsets.all(20),
                                      backgroundColor: kLogoColor),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      // 验证表单字段

                                      // 从输入框获取值
                                      String workingType = selectedWorkingType ?? '';
                                      String postcode = postcodeController.text;
                                      String tradieLicense = licenseController.text;

                                      try {
                                        // 更新用户的 Firestore 文档
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(widget.uid)
                                            .update({
                                          'workType': workingType,
                                          'postcode': postcode,
                                          'licenseNumber': tradieLicense,
                                          'Is_Tradie': true,
                                          'stripeId' : "",
                                          'workTitle' : "",
                                          'workStart' : 0,
                                          'workEnd' : 0,
                                          'workWeekend' : false,
                                          'rate' : 0,
                                          'workDescription' : "",
                                          'tOrders' : 0,
                                        });

                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text("注册成功"),
                                          ),
                                        );
                                        Navigator.pop(context, 'update');
                                      } catch (error) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text("注册失败"),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  child: const Text(
                                    "Register",
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              ),
                          SizedBox(height: max(1.75.ph(size), 10)), // 空间填充，垂直间距
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat, // 悬浮按钮位置
        floatingActionButton: FloatingActionButton( // 悬浮按钮
          backgroundColor: Colors.white, // 背景颜色
          onPressed: () { // 点击事件
            Navigator.pop(context, 'notupdate');
          },
          child: const Icon(Icons.arrow_back, color: Colors.black87), // 按钮图标
        ));
  }
}


import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_cross_app/Login/utils/constants.dart';
import 'package:new_cross_app/Login/utils/responsive.dart';
import 'package:logger/logger.dart';
import 'package:new_cross_app/Profile/profile_home.dart';
import 'package:new_cross_app/services/auth_service.dart';
import 'package:sizer/sizer.dart';
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

  final jemmaTitle = Center(
    child: FittedBox(
      fit: BoxFit.contain,
      child: Text("Jemma", style: GoogleFonts.parisienne(fontSize: 50.0)),
    ),
  );


  final _formKey = GlobalKey<FormState>(); // 创建一个全局键，用于后续验证表单，**这个暂时没有用

  final TextEditingController postcodeController = TextEditingController(); // 创建一个新的控制器用于postcode的输入框

  String? selectedWorkingType; //定义一个String变量以保存选定的“working type

  double? uploadProgress;  // 添加一个新的状态变量来存储上传进度

  bool isUploading = false;  // 是否正在上传

  bool isImageUploaded = false;  // 是否已经上传了

  // 澳大利亚邮政编码的正则表达式（4 位数字） Regular expression for Australian postal codes (4 digits)
  RegExp australiaPostcodeRegExp = RegExp(r'^\d{4}$');

 // 添加一个布尔变量来跟踪邮政编码是否有效Add a boolean variable to track if the postal code is valid
  bool isPostcodeValid = false;

  bool isValidAustralianPostcode(String postcode) {
    RegExp australiaPostcodeRegExp = RegExp(r'^\d{4}$');
    return australiaPostcodeRegExp.hasMatch(postcode);
  }
  Future<bool> isLicenseNumberUnique(String licenseNumber) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      final querySnapshot = await firestore
          .collection('users') // 假设你的用户数据存储在 'users' 集合中
          .where('licenseNumber', isEqualTo: licenseNumber)
          .get();

      // 如果查询结果为空，说明没有找到相同的执照号码，返回 true
      if (querySnapshot.docs.isEmpty) {
        return true;
      }
    } catch (e) {
      print('Error checking license number: $e');
    }
    // 否则返回 false，说明执照号码已经存在
    return false;
  }

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
                          ConstrainedBox(
                            constraints: BoxConstraints(minHeight: size.height * 0.30), // 使用MediaQuery的结果直接计算高度
                            child: jemmaTitle, // 使用之前定义的标题
                          ),
                          SizedBox(height: max(size.height * 0.02, 20)), // 使用MediaQuery的结果直接计算高度，并确保最小值为20


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
                                  'Aircon Mechanic',
                                  'Brick Layer',
                                  'Carpenter',
                                  'Carpet Layer',
                                  'Decking',
                                  'Electrcian',
                                  'Fencing',
                                  'Gas Plumber',
                                  'Glazier',
                                  'Hair AndM akeUp',
                                  'Home Renovation',
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
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                          //
                          // Text('UID: ${widget.uid}'), // 添加这行代码来显示uid
                          // SizedBox(height: max(2.ph(size), 20)),

                          // 添加一个新的输入框用于postcode
                          Center(
                            child: Container(
                              width: 300,
                              child: TextField(
                                controller: postcodeController,
                                decoration: InputDecoration(
                                  labelText: 'Enter Postcode',
                                  hintText: 'Input your postcode here',
                                  errorText: isPostcodeValid ? null : 'Please enter a valid Australian postcode',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    // Check if the input matches the pattern
                                    isPostcodeValid = australiaPostcodeRegExp.hasMatch(value);
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),// 添加垂直间距

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
                                  onSubmitted: (String value) async {
                                    bool isUnique = await isLicenseNumberUnique(value);
                                    if (!isUnique) {
                                      // 显示错误消息或处理执照号码冲突的逻辑
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('License number already in use. Please use a different license number.'))
                                      );
                                    } else {
                                      // 执行其他操作，例如启用注册按钮或保存数据
                                      print("License number is unique, you can proceed.");
                                    }
                                  },
                                ),
                              ),
                              SizedBox(height: 10), // 空间填充，垂直间距


                              // 如果上传进度不为 null，显示进度条
                              if (isUploading) ...[  // 如果正在上传，显示进度条
                                SizedBox(
                                  width: 290,  // 与按钮的宽度相同
                                  child: LinearProgressIndicator(
                                    value: uploadProgress,  // 设置进度值
                                    color: Color.lerp(Colors.red, Colors.green, uploadProgress ?? 0),  // 进度条的颜色
                                  ),
                                ),
                                SizedBox(height: 2),  // 为了视觉效果，提供一些间距
                              ],
                              ElevatedButton(
                                onPressed: isUploading ? null : () async { // 如果正在上传，则禁用按钮
                                  if (isImageUploaded) {
                                    // 如果图片已经上传，我们可以允许用户点击按钮进行新的上传
                                    isImageUploaded = false;
                                    setState(() {}); // 更新UI
                                  }
                                  // 定义一个异步的onPressed函数，这个函数在按钮被点击后触发

                                  try {
                                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: ['jpg', 'png', 'jpeg'],
                                    );
                                    if (result != null) {
                                      Uint8List? fileBytes;
                                      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
                                      FirebaseStorage storage = FirebaseStorage.instance;

                                      if (kIsWeb) {  // 检查是否在Web平台上
                                        fileBytes = result.files.single.bytes;
                                      } else {
                                        // 在非Web平台上，我们可以尝试访问path
                                        if (result.files.single.path != null) {
                                          File file = File(result.files.single.path!);
                                          fileBytes = await file.readAsBytes();
                                        }
                                      }

                                      if (fileBytes != null) {

                                        setState(() {
                                          isUploading = true;  // 设置为正在上传
                                        });

                                        UploadTask task = storage.ref('users/${widget.uid}/$fileName').putData(fileBytes);
                                        //为上传任务创建了一个监听器。监听器的作用是监视上传过程的每一个阶段，并为每个阶段提供反馈
                                        task.snapshotEvents.listen((TaskSnapshot snapshot) {
                                          double progress = (snapshot.bytesTransferred / snapshot.totalBytes);
                                          setState(() {
                                            uploadProgress = progress;  // 更新状态变量
                                          });
                                          print('Upload progress: ${progress * 100}%');
                                        }, onError: (Object e) {
                                          setState(() {
                                            isUploading = false;  // 设置为不再上传
                                          });
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text("Image upload failed"),
                                            ),
                                          );
                                        });

                                        try {
                                          await task;  // 等待任务完成
                                          final String downloadUrl = await task.snapshot.ref.getDownloadURL();
                                          print('Download URL: $downloadUrl');
                                          //如果上传成功，会获取文件的下载链接，更新 Firestore 数据库
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget.uid)
                                              .update({'lincensePic': downloadUrl});

                                          setState(() {   // <--- 添加这里
                                            isImageUploaded = true;
                                          });

                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text("Image uploaded successfully"),
                                            ),
                                          );

                                          setState(() {   // <--- 添加这里
                                            isImageUploaded = true;
                                            isUploading = false; // 这里也应该设置 isUploading 为 false
                                          });

                                        } catch (error) {
                                          setState(() {
                                            isUploading = false;  // 设置为不再上传
                                          });
                                          print("Error during upload: $error");
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text("Image upload failed"),
                                            ),
                                          );
                                        }
                                      } else {
                                        print("File bytes are null");
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text("File selection error1"),
                                          ),
                                        );
                                      }
                                    } else {
                                      print("FilePickerResult is null");
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("No file selected"),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    print("Error picking file: $e");
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("File selection error2"),
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isImageUploaded ? Colors.grey : (isUploading
                                      ? Color.lerp(Colors.red, Colors.green, uploadProgress ?? 0)
                                      : kLogoColor),
                                  minimumSize: Size(300, 60),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.upload, color:Colors.black),
                                    SizedBox(width: 5),
                                    Text(isImageUploaded ? "License Uploaded" : (isUploading ? "Uploading..." : "Upload License Picture"),
                                      style: TextStyle(color: Colors.black),)
                                  ],
                                ),
                              ),

                            ],
                          ),

                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                          // 空间填充，垂直间距


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
                                    if (!isPostcodeValid) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("Please enter a valid Australian postcode"),
                                        ),
                                      );
                                      return;
                                    }
                                    String tradieLicense = licenseController.text;
                                    if (_formKey.currentState!.validate()) {

                                      bool isUnique = await isLicenseNumberUnique(tradieLicense);
                                      if (!isUnique) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text("License number already in use. Please use a different license number.")),
                                        );
                                        return; // 如果执照号码不唯一，停止执行后续代码
                                      }
                                      // 验证表单字段

                                      // 从输入框获取值
                                      String workingType = selectedWorkingType ?? '';
                                      String postcode = postcodeController.text;


                                      try {
                                        DocumentSnapshot docSnapshot = await colRef.doc(widget.uid).get();
                                        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
                                        // 判断该用户是否已经注册过，如果未注册过，则更新全部tradie字段
                                        if (!data.containsKey('workType')) {
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
                                        }
                                        // 如果已经注册过，则只更新tradie的worktype,postcode和licenseNumber
                                        else {
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget.uid)
                                              .update({
                                            'workType': workingType,
                                            'postcode': postcode,
                                            'licenseNumber': tradieLicense,
                                          });
                                        }

                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text("Register Successed"),
                                          ),
                                        );
                                        Navigator.pop(context, 'update');
                                      } catch (error) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text("Register Failed"),
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
                          SizedBox(height: max(size.height * 0.0175, 10)), // 空间填充，垂直间距
                        ]),
                  ),
                ),
            ]),
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


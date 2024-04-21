import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_cross_app/Home%20Page/responsive.dart';
import '../Home Page/constants.dart';
import '../services/auth_service.dart';

class CustomerInfoEdit extends StatefulWidget {
  final String userID;
  CustomerInfoEdit({required this.userID});

  @override
  _CustomerInfoEditState createState() => _CustomerInfoEditState();
}

final databaseReference = FirebaseFirestore.instance;
final CollectionReference colRef = databaseReference.collection('users');

class _CustomerInfoEditState extends State<CustomerInfoEdit> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    addressController.dispose();
    super.dispose();
  }

  _getUserData() async {
    DocumentSnapshot docSnapshot = await colRef.doc(widget.userID).get();
    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

    if (data != null) {
      nameController.text = data['fullName'] ?? '';
      phoneController.text = data['Phone'] ?? '';
      passwordController.text = '';
      confirmPasswordController.text = '';
      addressController.text = data['address'] ?? '';
    }
  }

  _updateData() async {
    String name = nameController.text;
    String phone = phoneController.text;
    String password = passwordController.text;
    String address = addressController.text;

    Map<String, String> updatedInfo = {
      'fullName': name,
      'Phone': phone,
      'address': address,
    };

    try {
      await colRef.doc(widget.userID).update(updatedInfo);
    } catch (e) {
      print("Error updating document: $e");
    }

    if (password != '') {
      bool result = await AuthService().updatePassword(password);
      if (result) {
        print("Password updated successfully");
      } else {
        print("Failed to update password");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            attributeEdit(size, nameController, 'Name', 'Enter your new name here', false),
            SizedBox(height: size.height * 0.025),
            attributeEdit(size, phoneController, 'Phone', 'Enter your new phone number here', false),
            SizedBox(height: size.height * 0.025),
            attributeEdit(size, passwordController, 'New Password', 'Enter your new password here. Leave it empty if not changing.', true),
            SizedBox(height: size.height * 0.025),
            attributeEdit(size, confirmPasswordController, 'Confirm New Password', 'Confirm your new password. Leave it empty if not changing.', true),
            SizedBox(height: size.height * 0.025),
            attributeEdit(size, addressController, 'Address', 'Put your new address here', false),
            SizedBox(height: size.height * 0.025),
            ElevatedButton(
              onPressed: () async {
                if (passwordController.text == confirmPasswordController.text) {
                  await _updateData();
                  Navigator.pop(context, 'update');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Passwords do not match'),
                    ),
                  );
                }
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  Container attributeEdit(Size size, TextEditingController controller, String labelText, String hintText, bool obscure) {
    return Container(
      width: size.width * 0.50,
      constraints: const BoxConstraints(minWidth: 400),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: kLogoColor, width: 1.0),
          ),
        ),
        obscureText: obscure,
      ),
    );
  }
}

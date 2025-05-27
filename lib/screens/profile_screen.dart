import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noob_chat/services/database_services.dart';
import 'package:noob_chat/utils/app_colors.dart';
import 'package:noob_chat/widget/custom_texts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    getData();
  }

  ///______________________ Function to fetch user data ____________________________///
  void getData() async {
    final fetchData = await DatabaseServices()
        .getUserData(user!.uid);
    setState(() {
      userData = fetchData;
      nameController.text = userData?['name'] ?? "";
      emailController.text = userData?['email'] ?? "";
    });
  }

  ///______________________ Function to handle logout ____________________________///
  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  ///______________________ Function to upload profile picture ____________________________///
  Future<void> _pickAndUploadImage() async{
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if(pickedImage!= null){
      File imageFile = File(pickedImage.path);
      
      final getImageUrl = await DatabaseServices().uploadImage(imageFile, user!.uid);
      DatabaseServices().updatePhotoUrl(user!.uid, getImageUrl!);

      getData();
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: Text("My Profile"),
          centerTitle: true,
        ),
        body: user == null
            ? Center(
                child: Text("No User Found"),
              )
            : SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(height: screenHeight * 0.02),
                        GestureDetector(
                          onTap: _pickAndUploadImage,
                          child: CircleAvatar(
                            radius: screenHeight * 0.1,
                            backgroundImage:
                                NetworkImage(userData?['photoUrl'] ?? ''),
                            child: userData?['photoUrl'] == ''
                                ? Icon(
                                    Icons.person,
                                    size: screenHeight * 0.1,
                                  )
                                : null,
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.05,
                        ),
                        _inputCard(nameController, "Please fill the name", true),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        _inputCard(emailController, "Please fill the email", false),
                        SizedBox(
                          height: screenHeight * 0.2,
                        ),
                        SizedBox(
                          height: screenHeight * 0.07,
                          width: screenWidth,
                          child: ElevatedButton.icon(
                              onPressed: () => _logout(context),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                backgroundColor: Colors.red.shade400.withAlpha(450),
                                iconColor: Colors.white,
                              ),
                              icon: Icon(Icons.logout, size: 25,),
                              label: Text(
                                "Logout",
                                style: TextStyle(color: Colors.white, fontSize: 22),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
            ));
  }

  Container _inputCard(TextEditingController controller, String validationMessage, bool isName) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 3)
          ]
      ),
      child: Padding(padding: EdgeInsets.symmetric(horizontal: 12),
        child: TextFormField(
          controller: controller,
          validator: (val) => val != null && val.isNotEmpty ? null : validationMessage,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onEditingComplete: () {  // Fires only when user stops typing
            if (controller.text.isNotEmpty) {
              isName
                  ? DatabaseServices().updateName(user!.uid, controller.text)
                  : DatabaseServices().updateEmail(user!.uid, controller.text);
            }
          },
          decoration: InputDecoration(
              labelText: isName ? "Username" : "Email",
              border: InputBorder.none,
              labelStyle: TextStyle(fontSize: 18, color: Colors.black45),
              prefixIcon: Icon(isName ? Icons.person : Icons.email, color: AppColors.primaryColor,)
          ),
        ),),
    );
  }

}

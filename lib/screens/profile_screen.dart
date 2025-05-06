import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:noob_chat/services/database_services.dart';
import 'package:noob_chat/utils/app_colors.dart';
import 'package:noob_chat/widget/custom_texts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
    });
  }

  ///______________________ Function to handle logout ____________________________///
  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
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
            : Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.02),
                      CircleAvatar(
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
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      CustomText.labelText(
                          text: userData?['name'] ?? 'No Name',
                          color: Colors.black,
                          fontSize: 28),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      CustomText.paragraph(text: userData?['email'] ?? ''),
                      SizedBox(
                        height: screenHeight * 0.03,
                      ),
                      ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.edit),
                          label: Text("Edit Profile")),
                      SizedBox(
                        height: screenHeight * 0.3,
                      ),
                      SizedBox(
                        height: screenHeight * 0.05,
                        width: screenWidth * 0.4,
                        child: ElevatedButton.icon(
                            onPressed: () => _logout(context),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: Colors.red,
                              iconColor: Colors.white,
                            ),
                            icon: Icon(Icons.logout),
                            label: Text(
                              "Logout",
                              style: TextStyle(color: Colors.white),
                            )),
                      )
                    ],
                  ),
                ),
              ));
  }
}

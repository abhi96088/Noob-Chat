import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noob_chat/services/auth_service.dart';
import 'package:noob_chat/utils/app_colors.dart';
import 'package:noob_chat/widget/custom_texts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Noob Chat',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ))
        ],
        backgroundColor: AppColors.primaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/chatBot');
              },
              child:  ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage("assets/images/chatbot.png"),
                ),
                title:
                CustomText.labelText(text: "Noob AI", color: Colors.black),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('recentChats')
                  .doc(currentUser!.uid)
                  .collection('chats')
                  .orderBy('timeStamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: Text("No recent chats found."));
                }

                final chats = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    final otherUserId = chat['uid'];

                    return StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(otherUserId)
                          .snapshots(),
                      builder: (context, userSnap) {
                        if (!userSnap.hasData || !userSnap.data!.exists) {
                          return SizedBox();
                        }

                        final user = userSnap.data!;
                        final name = user['name'] ?? 'No Name';
                        final photoUrl = user['photoUrl'] ?? '';

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                          child: Column(
                            children: [
                              Divider(color: Colors.grey.shade300,),
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                  photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
                                  child: photoUrl.isEmpty ? Icon(Icons.person) : null,
                                ),
                                title: Text(name),
                                subtitle: Text(chat['lastMessage'] ?? ''),
                                trailing: Text(
                                  chat['timeStamp'] != null
                                      ? _formatTimestamp(chat['timeStamp'].toDate())
                                      : '',
                                  style: TextStyle(fontSize: 12),
                                ),
                                onTap: () {
                                  Navigator.pushNamed(context, '/chat', arguments: {
                                    'uid': otherUserId,
                                    'name': name,
                                    'photoUrl': photoUrl,
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          )

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/search');
        },
        child: Icon(Icons.message),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      return "${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}";
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else {
      return "${timestamp.day}/${timestamp.month}/${timestamp.year}";
    }
  }

}

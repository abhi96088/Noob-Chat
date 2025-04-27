import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noob_chat/services/auth_service.dart';
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
      appBar: AppBar(title: Text(
        'Noob Chat',
        style: GoogleFonts.montserrat(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),),
      body: StreamBuilder(stream: FirebaseFirestore.instance.collectionGroup('messages').where('senderId', isEqualTo: currentUser).orderBy('timestamp', descending: true).snapshots(), builder: (context, snapshot){
        if(!snapshot.hasData)return Center(child: CustomText.labelText(text: "No Chats Found!", color: Colors.grey),);

        final messages = snapshot.data!.docs;

        Map<String, Map<String, dynamic>> recentChats = {};

        for(var msg in messages){
          final recieverId = msg['recieverId'];
          final chatId = _getChatId(currentUser!.uid, recieverId);

          if(!recentChats.containsKey(chatId)){
            recentChats[chatId] = {
              'lastMessage': msg['text'],
              'timestamp': msg['timestamp'],
              'uid': recieverId
            };
          }
        }

        final chatList = recentChats.values.toList();

        return ListView.builder(
            itemCount: chatList.length,
            itemBuilder: (context, index){
              final chat = chatList[index];
              
              return FutureBuilder<DocumentSnapshot>(future: FirebaseFirestore.instance.collection('users').doc(chat['uid']).get(), builder: (context, userSnap){
                if(!userSnap.hasData) return SizedBox();

                final user = userSnap.data!;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user['photoUrl'].isNotEmpty ? NetworkImage(user['photoUrl']) : null,
                    child: user['photoUrl'].isEmpty ? const Icon(Icons.person) : null,
                  ),
                  title: Text(user['name']),
                  trailing: Text(chat['timestamp'] != null ? _formatTimestamp(chat['timestamp'].toDate()) : '', style: TextStyle(fontSize: 12),),
                  onTap: (){
                    Navigator.pushNamed(context, '/chat', arguments: {
                      'uid': user.id,
                      'name': user['name'],
                      'photoUrl': user['photoUrl'] ?? ''
                    });
                  },
                );
              });
            });
      }),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.pushNamed(context, '/search');
      }, child: Icon(Icons.message),),
    );
  }

  String _getChatId(String uid1, String uid2) {
    return uid1.hashCode <= uid2.hashCode ? '${uid1}_$uid2' : '${uid2}_$uid1';
  }

  String _formatTimestamp(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

}

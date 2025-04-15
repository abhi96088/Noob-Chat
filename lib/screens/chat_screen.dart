import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noob_chat/utils/app_colors.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;

  late String receiverId;
  late String chatId;
  late String receiverName;
  late String receiverPhoto;


  ///______________________ This function is called after initState and before first build of widget. here using because context is not ready in initState and we are using context in our function ____________________________///
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // get arguments passed by previous screen as map
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    // separating arguments from map using key
    receiverId = args['uid'] as String? ?? '';
    receiverName = args['name'] as String? ?? 'Unknown';
    receiverPhoto = args['photoUrl'] as String? ?? '';
    chatId = _getChatId(currentUser!.uid, receiverId);
  }

  ///______________________ Function to generate chat id ____________________________///
  String _getChatId(String uid1, String uid2) {
    return uid1.hashCode <= uid2.hashCode ? '${uid1}_$uid2' : '${uid2}_$uid1';  // generate chat a common chat id for both user based on hashcode
  }

  ///______________________ Function to handle send message ____________________________///
  void _sendMessage() {
    // get text from text field
    final text = _messageController.text.trim();
    if (text.isEmpty) return;   // do nothing if empty

    // store in database where chat id matches
    FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'senderId': currentUser!.uid,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _messageController.clear();   // clear text field
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage:
              receiverPhoto.isNotEmpty ? NetworkImage(receiverPhoto) : null,  // set background image if image available
              child: receiverPhoto.isEmpty ? const Icon(Icons.person) : null, // set emoji if image not found
            ),
            const SizedBox(width: 8),
            Text(receiverName), // set receiver name
          ],
        ),
        backgroundColor: const Color(0xFF2E8BFF),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),   // show messages in descending order by time
              builder: (context, snapshot) {
                // check if there is some messages
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,  // reverse scroll direction. starts from bottom
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {

                    final msg = messages[index];    // store single message
                    final isMe = msg['senderId'] == currentUser!.uid; // check if sender id matches to current user

                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,   // align right if message is send and left if message is received
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isMe
                              ? AppColors.primaryColor
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          msg['text'] ?? '',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send, color: Color(0xFF2E8BFF)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

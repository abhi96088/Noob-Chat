import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices{
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  ///___________________ Function to add user details to database ______________________///
  Future<void> createUserProfile(Map<String, dynamic> user) async {
    final userRef = _fireStore.collection('users').doc(user['uid']);

    final snapshot = await userRef.get();

    if(!snapshot.exists){
      await userRef.set({
        'uid': user['uid'],
        'name' : user['name'] ?? '',
        'email' : user['email'] ?? '',
        'photoUrl' : user['photoUrl'] ?? '',
        'createdAt' : FieldValue.serverTimestamp()
      });
    }
  }

  ///___________________ Function to add a single chat to database ______________________///
  Future<void> addChatMessage({required String senderId, required String text, required String chatId}) async{
    await _fireStore.collection('chats').doc(chatId).collection('messages').add({
      'senderId': senderId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp()
    });
  }
}
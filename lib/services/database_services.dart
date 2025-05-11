import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseServices{
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

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
  Future<void> addChatMessage({required String senderId, required String receiverId, required String text, required String chatId}) async{
    await _fireStore.collection('chats').doc(chatId).collection('messages').add({
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp()
    });
  }

  ///______________________ Function to update recent message ____________________________///
  Future<void> updateRecentMessage({required String chatId,
    required String currentUserId,
    required String otherUserId,
    required String message,
  })async {
    final messageRef  = _fireStore.collection('recentChats').doc(currentUserId).collection('chats').doc(otherUserId);

    await messageRef.set({
      'chatId': chatId,
      'uid': otherUserId,
      'lastMessage': message,
      'timeStamp': FieldValue.serverTimestamp()
    }, SetOptions(merge: true));
  }

  ///___________________ Function to fetch an user details from database ______________________///
  Future<Map<String, dynamic>?> getUserData(String uid) async{
    final DocumentSnapshot snapshot = await _fireStore.collection('users').doc(uid).get();

    if(snapshot.exists){
      return snapshot.data() as Map<String, dynamic>;
    }else{
      return null;
    }
  }

  ///___________________ Function to upload image to the database ______________________///
  Future<String?> uploadImage(File imageFile, String uid) async{
    final ref = _storage.ref().child('profile_pictures').child('$uid.jpg');
    
    await ref.putFile(imageFile);
    final imageUrl = await ref.getDownloadURL();

    if(imageUrl.isNotEmpty){
      return imageUrl;
    }

    return null;
  }

  ///___________________ Function to update image URL ______________________///
  void updatePhotoUrl(String uid, String imageUrl) async{
    await _fireStore.collection('users').doc(uid).update({'photoUrl' : imageUrl});
  }

}
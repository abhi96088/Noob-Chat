import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUserProfile(Map<String, dynamic> user) async {
    final userRef = _firestore.collection('users').doc(user['uid']);

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
}
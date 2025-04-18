import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:noob_chat/services/database_services.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  ///___________________ Function to handle signIn ______________________///
  Future<User?> signIn(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print('Sign in error: $e');
      return null;
    }
  }

  ///___________________ Function to handle user registration ______________________///
  Future<User?> register(String email, String password, String name) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        // create and store user details on database
        DatabaseServices().createUserProfile({
          'uid': user.uid,
          'name': name,
          'email': user.email ?? '',
          'photoUrl': user.photoURL ?? '',
          'createdAt': FieldValue.serverTimestamp()
        });
      }

      return user;
    } catch (e) {
      print("Register error: $e");
      return null;
    }
  }

  ///___________________ Function to handle signIn with google ______________________///
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        // create and store user details on database
        DatabaseServices().createUserProfile({
          'uid': user.uid,
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'photoUrl': user.photoURL ?? '',
          'createdAt': FieldValue.serverTimestamp()
        });
      }

      return user;
    } catch (e) {
      print("Google Sign-In error: $e");
      return null;
    }
  }

  ///___________________ Function to handle signOut ______________________///
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class AuthService {
  final _googleSignIn = GoogleSignIn();
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  // Firebase user one-time fetch
  Future<User> get getUser async => _auth.currentUser;

  Stream<User> get user => _auth.authStateChanges();

  // Google Sign In
  Future<User> googleSignIn() async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      User user = result.user;

      // Update user data
      updateUserData(user);

      return user;
    } catch (error) {
      print(error);
      return null;
    }
  }

  // Anonymous Log In
  Future<User> anonLogin() async {
    UserCredential result = await _auth.signInAnonymously();
    User user = result.user;

    updateUserData(user);
    return user;
  }

  // update on new log
  Future<void> updateUserData(User user) {
    DocumentReference reportRef = _db.collection('reports').doc(user.uid);

    return reportRef.set({
      'uid': user.uid,
      'lastActivity': DateTime.now(),
    }, SetOptions(merge: true));
  }

  // Sign out
  Future<void> signOut() {
    return _auth.signOut();
  }
}

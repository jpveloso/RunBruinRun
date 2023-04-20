import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  Future<void> createUser(String email, String userName) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'email': email,
      'userName': userName,
      'friends': [],
    });
    await FirebaseFirestore.instance.collection('scores').doc(uid).set({
      'highScores': [0],
    });
  }
}

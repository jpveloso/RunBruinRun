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
    await FirebaseFirestore.instance.collection('highScores').doc(uid).collection('scores').doc().set({
      'score': 0,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}

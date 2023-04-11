import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  // final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Future<void> addUser() async {
  //   User? user = _firebaseAuth.currentUser;
  //   if (user != null) {
  //     String uid = user.uid;
  //     String email = user.email ?? '';
  //
  //     // Create a new document in the users collection with the UID as the document ID
  //     await usersCollection.doc(uid).set({
  //       'email': email,
  //       'displayName': '',
  //       'highScores': 0,
  //     });
  //   }
  // }

  Future<void> createUser(String email, String userName) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'email': email,
      'userName': userName,
      'friends': [],
    },);
  }
}



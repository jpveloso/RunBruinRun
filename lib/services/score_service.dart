import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _scoreCollection = _firestore.collection('scores');

Future<void> saveHighScore(int highScore) async {
  final DocumentReference document = _scoreCollection.doc();
  await document.set({'scores': highScore});
}
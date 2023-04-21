import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'package:firebase_auth/firebase_auth.dart' as fa;

Future<void> BBsaveHighScore(int highScore) async {
  final userId = fa.FirebaseAuth.instance.currentUser?.uid;
  if (userId != null) {
    cf.FirebaseFirestore.instance
        .collection('BBhighScores')
        .doc(userId)
        .collection('scores')
        .add({
      'score': highScore,
      'timestamp': cf.FieldValue.serverTimestamp(),
    });
  }
}

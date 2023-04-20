import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'package:firebase_auth/firebase_auth.dart' as fa;

Future<void> saveHighScore(int highScore) async {
  final userId = fa.FirebaseAuth.instance.currentUser?.uid;
  if (userId != null) {
    cf.FirebaseFirestore.instance
        .collection('highScores')
        .doc(userId)
        .collection('scores')
        .add({
      'score': highScore,
      'timestamp': cf.FieldValue.serverTimestamp(),
    });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/friend.dart';

class FriendsService {
  final String? currentUserId;

  FriendsService({required this.currentUserId});

  Future<List<Friend>> getFriends() async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .get();

    if (!userSnapshot.exists) {
      return [];
    }

    List<String> friendUids = List<String>.from(userSnapshot['friends'] ?? []);

    if (friendUids.isEmpty) {
      return [];
    } else {
      List<Friend> friends = [];
      for (String friendUid in friendUids) {
        DocumentSnapshot friendSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(friendUid)
            .get();
        int highScore = 0;
        QuerySnapshot scoresSnapshot = await FirebaseFirestore.instance
            .collection('highScores')
            .doc(friendUid)
            .collection('scores')
            .orderBy('score', descending: true)
            .limit(1)
            .get();
        if (scoresSnapshot.docs.isNotEmpty) {
          highScore = scoresSnapshot.docs.first.get('score');
        }
        friends.add(Friend(
          email: friendSnapshot['email'] ?? '',
          userName: friendSnapshot['userName'] ?? '',
          highScore: highScore,
        ));
      }
      friends.sort((a, b) => b.highScore.compareTo(a.highScore));
      return friends;
    }
  }

  Future<void> addFriend(String friendUid) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'friends': FieldValue.arrayUnion([friendUid]),
    });
  }

  Future<void> removeFriend(String friendUid) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'friends': FieldValue.arrayRemove([friendUid]),
    });
  }
}

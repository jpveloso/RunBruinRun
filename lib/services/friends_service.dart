import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/friend.dart';

class FriendsService {
  final String? currentUserId;

  FriendsService({required this.currentUserId});

  Future<List<Friend>> getFriends() async {
    DocumentSnapshot userSnapshot =
    await FirebaseFirestore.instance.collection('users').doc(currentUserId).get();

    if (!userSnapshot.exists) {
      return [];
    }

    List<String> friendUids = List<String>.from(userSnapshot['friends'] ?? []);

    if (friendUids.isEmpty) {
      return [];
    } else {
      List<Friend> friends = [];
      for (String friendUid in friendUids) {
        DocumentSnapshot friendSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(friendUid).get();
        int highScore = 0;
        if (await FirebaseFirestore.instance.collection('scores').doc(friendUid).get().then((value) => value.exists)) {
          highScore = (await FirebaseFirestore.instance.collection('scores').doc(friendUid).get())['score'] ?? 0;
        }
        friends.add(Friend(
          email: friendSnapshot['email'] ?? '',
          userName: friendSnapshot['userName'] ?? '',
          highScore: highScore,
        ));
      }
      return friends;
    }
  }





  // Future<void> addFriend(String friendUid) async {
  //   // Check if the friend exists
  //   DocumentSnapshot friendSnapshot = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(friendUid)
  //       .get();
  //   if (!friendSnapshot.exists) {
  //     throw Exception('User not found');
  //   }
  //
  //   // Add the friend's UID to the current user's friends array
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(currentUserId)
  //       .update({
  //     'friends': FieldValue.arrayUnion([friendUid])
  //   });
  // }

  Future<void> addFriend(String friendUid) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'friends': FieldValue.arrayUnion([friendUid]),
    });
  }

  // Future<void> removeFriend(String friendUid) async {
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(currentUserId)
  //       .update({
  //     'friends': FieldValue.arrayRemove([friendUid])
  //   });
  // }

  Future<void> removeFriend(String friendUid) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'friends': FieldValue.arrayRemove([friendUid]),
    });
  }
}

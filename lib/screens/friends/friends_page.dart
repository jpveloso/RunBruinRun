import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/friend.dart';
import '../../services/friends_service.dart';

class FriendsPage extends StatefulWidget {
  final FriendsService friendsService;

  const FriendsPage({Key? key, required this.friendsService}) : super(key: key);

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final TextEditingController _addFriendController = TextEditingController();
  List<Friend> _friends = [];


  Future<String?> _getFriendUid(String friendEmail) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: friendEmail)
        .limit(1)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  void _loadFriends() async {
    List<Friend> friends = await widget.friendsService.getFriends();
    setState(() {
      _friends = friends;
    });
  }

  void _addFriend() async {
    String email = _addFriendController.text.trim();
    String? friendUid = await _getFriendUid(email);
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (email.isNotEmpty && friendUid != null && friendUid != currentUserId) {
      try {
        await widget.friendsService.addFriend(friendUid);
        _addFriendController.clear();
        _loadFriends(); // call _loadFriends() after friend is added
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Cannot add yourself as a friend :(')));
    }
  }

  void _removeFriend(String friendId) async {
    await widget.friendsService.removeFriend(friendId);
    _loadFriends();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _addFriendController,
                    decoration: const InputDecoration(
                      hintText: 'Add friend by email',
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: _addFriend,
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _friends.length,
              itemBuilder: (BuildContext context, int index) {
                Friend friend = _friends[index];
                return ListTile(
                  title: Text(friend.userName),
                  subtitle: Text('High score: ${friend.highScore}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle),
                    onPressed: () async {
                      // if (_showConfirmationDialog(friend)) {
                      _showConfirmationDialog(friend);
                        String friendUid = _getFriendUid(friend.email) as String;
                        if (friendUid != null) {
                          _removeFriend(friendUid);
                          setState(() {
                            _friends.remove(friend);
                          });
                        }
                      // }
                    },
                  ),

                );
              },
            ),
          )
        ],
      ),
    );
  }

  void _showConfirmationDialog(Friend friend) async {
    String? friendUid = await _getFriendUid(friend.email);
    if (friendUid != null) {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Remove Friend'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Are you sure you want to remove ${friend.userName} from your friends list?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Remove'),
                onPressed: () {
                  _removeFriend(friendUid!);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}

// Future<void> _removeFriend(String friendUid) async {
//   String? uid = FirebaseAuth.instance.currentUser?.uid;
//   await FirebaseFirestore.instance.collection('users').doc(uid).update({
//     'friends': FieldValue.arrayRemove([{'uid': friendUid}]),
//   });
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:run_bruin_run/styles/snackbar_styles.dart';

import '../../models/friend.dart';
import '../../services/friends_service.dart';
import '../../styles/colours.dart';
import '../../styles/input_field_styles.dart';

class FriendsPage extends StatefulWidget {
  final FriendsService friendsService;

  const FriendsPage({Key? key, required this.friendsService}) : super(key: key);

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  bool _isSubmitted = false;
  final TextEditingController _addFriendController = TextEditingController();
  List<Friend> _friends = [];
  late final GlobalKey<ScaffoldMessengerState> _friendScaffoldMessengerKey;
  late final GlobalKey<FormState> _friendFormKey;

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
    _friendScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
    _friendFormKey = GlobalKey<FormState>();
    _loadFriends();
  }

  void _loadFriends() async {
    List<Friend> friends = await widget.friendsService.getFriends();
    setState(() {
      _friends = friends;
    });
  }

  void _addFriend() async {
    String email = _addFriendController.text;
    String? friendUid = await _getFriendUid(email);
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (email.isNotEmpty && friendUid != null && friendUid != currentUserId) {
      // check if friend is already added
      bool isFriendAlreadyAdded =
      _friends.any((friend) => friend.email == email);
      if (!isFriendAlreadyAdded) {
        try {
          await widget.friendsService.addFriend(friendUid);
          _addFriendController.clear();
          _loadFriends();
          setState(() {
            _isSubmitted = false;
          });
          return;
        } catch (e) {
          _friendScaffoldMessengerKey.currentState!
              .showSnackBar(showShortLengthSnackbar(e.toString()));
        }
      } else {
        _friendScaffoldMessengerKey.currentState!.showSnackBar(
            showShortLengthSnackbar('This friend is already added'));
      }
    } else if (friendUid == null) {
      _friendScaffoldMessengerKey.currentState!.showSnackBar(
          showShortLengthSnackbar('No account with that email address found!'));
    } else {
      _friendScaffoldMessengerKey.currentState!.showSnackBar(
          showShortLengthSnackbar('Cannot add yourself as a friend :('));
    }
  }


  void _removeFriend(String friendId) async {
    // final context = _scaffoldMessengerKey.currentContext;
    await widget.friendsService.removeFriend(friendId);
    _loadFriends();
    _friendScaffoldMessengerKey.currentState!
        .showSnackBar(showShortLengthSnackbar('Friend removed :('));
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _friendScaffoldMessengerKey,
      child: Scaffold(
        backgroundColor: lightBruinBlue,
        appBar: AppBar(
          backgroundColor: darkBruinBlue,
          title: const FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              'FRIENDS LIST',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontFamily: 'PressStart2P',
              ),
            ),
          ),
          titleSpacing: 5,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Form(
            key: _friendFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 30),
                        child: addFriendTextFormFieldStyle(
                            "Enter friends email",
                            _addFriendController,
                            false,
                            _isSubmitted),
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 25, right: 15),
                        decoration: BoxDecoration(
                          color: darkBruinBlue,
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            if (_friendFormKey.currentState!.validate()) {
                              _addFriend();
                              setState(() {
                                _isSubmitted = true;
                              });
                            }
                          },
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _friends.length,
                    itemBuilder: (BuildContext context, int index) {
                      Friend friend = _friends[index];
                      return ListTile(
                        title: Text(
                          friend.userName,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontFamily: 'PressStart2P',
                          ),
                        ),
                        subtitle: Text(
                          'High score: ${friend.highScore}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: darkBruinBlue,
                            fontFamily: 'PressStart2P',
                          ),
                        ),
                        trailing: Container(
                          // margin: const EdgeInsets.only(right: 0),
                          decoration: const BoxDecoration(
                            color: darkBruinBlue,
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Material(
                              color: Colors.white,
                              child: InkWell(
                                splashColor: darkBruinBlue,
                                highlightColor: Colors.white38,
                                child: const SizedBox(
                                  width: 45,
                                  height: 45,
                                  child: Icon(
                                    Icons.remove_circle,
                                    color: darkBruinBlue,
                                    size: 45.0,
                                  ),
                                ),
                                onTap: () async {
                                  _showConfirmationDialog(friend);
                                  String friendUid =
                                      _getFriendUid(friend.email) as String;
                                  _removeFriend(friendUid);
                                  setState(() {
                                    _friends.remove(friend);
                                  });
                                  // }
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog(Friend friend) async {
    String? friendUid = await _getFriendUid(friend.email);
    if (friendUid != null) {
      BuildContext dialogContext = context;
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('Remove Friend',
                style: TextStyle(
                  fontSize: 15,
                  color: darkBruinBlue,
                  fontFamily: 'PressStart2P',
                )),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    'Are you sure you want to remove ${friend.userName} from your friends list?',
                    style: const TextStyle(
                      fontSize: 18,
                      color: darkBruinBlue,
                      // fontFamily: 'PressStart2P',
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(darkBruinBlue),
                ),
                child: const Text('Cancel',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontFamily: 'PressStart2P',
                    )),
              ),
              TextButton(
                onPressed: () {
                  _removeFriend(friendUid);
                  Navigator.of(dialogContext).pop();
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(darkBruinBlue),
                ),
                child: const Text('Remove',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontFamily: 'PressStart2P',
                    )),
              ),
            ],
          );
        },
      );
    }
  }
}

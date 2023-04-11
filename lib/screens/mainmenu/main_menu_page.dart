import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:run_bruin_run/screens/friends/friends_page.dart';
import 'package:run_bruin_run/screens/homepage/home_page.dart';
import 'package:run_bruin_run/screens/hurdle/game.dart';
import 'package:run_bruin_run/screens/sessionpages/join_session_page.dart';
import 'package:run_bruin_run/services/friends_service.dart';

import '../../styles/button_styles.dart';
import '../../styles/colours.dart';
import '../../styles/loading_style.dart';

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({Key? key}) : super(key: key);

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  late final FriendsService _friendsService;
  User? authenticatedUser = FirebaseAuth.instance.currentUser;
  final bool? _signedInAnon = FirebaseAuth.instance.currentUser?.isAnonymous;
  String? _userName;
  String? _email;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Make this display the scaffold first then the other if not a guest
    if (_signedInAnon == true) {
      _userName = "Guest";
      return mainMenuScaffold(context, _userName);
    } else {
      return FutureBuilder<QueryDocumentSnapshot<Object?>>(
        future: getUserNameByEmail(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              Map<String, dynamic> data =
                  snapshot.data.data() as Map<String, dynamic>;
              _userName = data['userName'];
              return mainMenuScaffold(context, _userName);
            }
          }
          return loadingScreen();
        },
      );
    }
  }

  Future<QueryDocumentSnapshot<Object?>> getUserNameByEmail() async {
    _email = authenticatedUser?.email;
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: _email)
        .get();
    return snapshot.docs[0];
  }
}

Future<void> _signOutUser() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user?.isAnonymous == true) {
    user?.delete();
  }
  await FirebaseAuth.instance.signOut();
}

Scaffold mainMenuScaffold(BuildContext context, String? userName) {
  String? currentUserID = FirebaseAuth.instance.currentUser?.uid;
  return Scaffold(
      backgroundColor: lightBruinBlue,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                'RUN BRUIN RUN',
                style: TextStyle(
                  fontSize: 24,
                  color: darkBruinBlue,
                  fontFamily: 'PressStart2P',
                ),
              ),
            ),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                'Welcome \n$userName',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontFamily: 'PressStart2P',
                ),
              ),
            ),
            Wrap(
              direction: Axis.horizontal,
              runAlignment: WrapAlignment.center,
              alignment: WrapAlignment.center,
              spacing: 35,
              runSpacing: 30,
              children: <Widget>[
                const FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    'SINGLE PLAYER',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontFamily: 'PressStart2P',
                    ),
                  ),
                ),
                ElevatedButton(
                    style: getSmallButtonStyle(),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyGame()));
                    },
                    child: const Text('Hurdles')),
                ElevatedButton(
                    style: getSmallButtonStyle(),
                    onPressed: () {},
                    child: const Text('Basketball')),
                const FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    'MULTIPLAYER',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontFamily: 'PressStart2P',
                    ),
                  ),
                ),
                ElevatedButton(
                    style: getSmallButtonStyle(),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FriendsPage(friendsService: FriendsService(currentUserId: currentUserID),)));
                    },
                    child: const Text('Friends List')),
                ElevatedButton(
                    style: getSmallButtonStyle(),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const JoinSessionPage()));
                    },
                    child: const Text('Join Session')),
                const FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    'SCOREBOARD',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontFamily: 'PressStart2P',
                    ),
                  ),
                ),
                ElevatedButton(
                    style: getSmallButtonStyle(),
                    onPressed: () {},
                    child: const Text('Hurdles')),
                ElevatedButton(
                    style: getSmallButtonStyle(),
                    onPressed: () {},
                    child: const Text('Basketball')),
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: ElevatedButton(
                      style: getButtonStyle(),
                      onPressed: () async {
                        _signOutUser();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()));
                      },
                      child: const FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          'Logout',
                          style: TextStyle(fontSize: 25),
                        ),
                      )),
                )
              ],
            ),
          ],
        ),
      ));
}

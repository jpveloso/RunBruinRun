import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:run_bruin_run/screens/friends/friends_page.dart';
import 'package:run_bruin_run/screens/homepage/home_page.dart';
import 'package:run_bruin_run/screens/scoreboard/hurdle_scores.dart';
import 'package:run_bruin_run/services/friends_service.dart';

import '../../styles/button_styles.dart';
import '../../styles/colours.dart';
import '../../styles/snackbar_styles.dart';
import '../basketball/basketBallGameScreen.dart';
import '../basketball/game.dart';
import '../loading_screens/loading_screen.dart';
import '../loading_screens/my_game_loading_screen.dart';

bool _isShowingSnackBar = false;

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({Key? key}) : super(key: key);

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  User? authenticatedUser = FirebaseAuth.instance.currentUser;
  final bool? _signedInAnon = FirebaseAuth.instance.currentUser?.isAnonymous;
  late final GlobalKey<ScaffoldMessengerState> _mainMenuGuestFormKey;

  String? _userName;
  String? _email;

  @override
  void initState() {
    super.initState();
    _mainMenuGuestFormKey = GlobalKey<ScaffoldMessengerState>();
  }

  @override
  Widget build(BuildContext context) {
    //Make this display the scaffold first then the other if an authenticated user
    if (_signedInAnon == true) {
      _userName = "Guest";
      return ScaffoldMessenger(
        child: WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: mainMenuScaffold(context, _userName, _mainMenuGuestFormKey)),
      );
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
              return ScaffoldMessenger(
                child: WillPopScope(
                    onWillPop: () async {
                      return false;
                    },
                    child: mainMenuScaffold(
                        context, _userName, _mainMenuGuestFormKey)),
              );
            }
          }
          return const LoadingScreen();
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
  user?.isAnonymous ?? false ? user?.delete() : null;
  await FirebaseAuth.instance.signOut();
}

ScaffoldMessenger mainMenuScaffold(BuildContext context, String? userName,
    GlobalKey<ScaffoldMessengerState> key) {
  String? currentUserID = FirebaseAuth.instance.currentUser?.uid;
  return ScaffoldMessenger(
    key: key,
    child: Scaffold(
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
                    fontSize: 25,
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
                runSpacing: 22,
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
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const GameLoadingScreen()));
                      },
                      child: const Text('Hurdles')),
                  ElevatedButton(
                      style: getSmallButtonStyle(),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GameScreen()));
                      },
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
                      onPressed: () async {
                        if (FirebaseAuth.instance.currentUser?.isAnonymous ==
                            true) {
                          final snackBar = showShortLengthSnackbar(
                              "Guests cannot add friends :/");
                          if (!_isShowingSnackBar) {
                            _isShowingSnackBar = true;
                            key.currentState
                                ?.showSnackBar(snackBar)
                                .closed
                                .then((value) => _isShowingSnackBar = false);
                          }
                        } else if (FirebaseAuth
                                .instance.currentUser?.isAnonymous ==
                            false) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FriendsPage(
                                        friendsService: FriendsService(
                                            currentUserId: currentUserID),
                                      )));
                        } else {
                          final snackBar = showShortLengthSnackbar(
                              "Something went wrong :/");
                          key.currentState?.showSnackBar(snackBar);
                        }
                      },
                      child: const Text('Friends List')),
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
                      onPressed: () async {
                        if (FirebaseAuth.instance.currentUser?.isAnonymous ==
                            true) {
                          final snackBar = showShortLengthSnackbar(
                              "Guests cannot view scores :/");
                          if (!_isShowingSnackBar) {
                            _isShowingSnackBar = true;
                            key.currentState
                                ?.showSnackBar(snackBar)
                                .closed
                                .then((value) => _isShowingSnackBar = false);
                          }
                        } else if (FirebaseAuth
                                .instance.currentUser?.isAnonymous ==
                            false) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HurdleScoresPage(),
                              ));
                        } else {
                          final snackBar = showShortLengthSnackbar(
                              "Something went wrong :/");
                          key.currentState?.showSnackBar(snackBar);
                        }
                      },
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
                          await _signOutUser();
                          Navigator.pushReplacement(
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
        )),
  );
}

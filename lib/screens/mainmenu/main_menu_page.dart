import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:run_bruin_run/screens/homepage/home_page.dart';
import 'package:run_bruin_run/screens/sessionpages/create_session_page.dart';
import 'package:run_bruin_run/screens/sessionpages/join_session_page.dart';

import '../../styles/button_styles.dart';
import '../../styles/colours.dart';
import '../../styles/loading_style.dart';

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({Key? key}) : super(key: key);

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  User? authenticatedUser = FirebaseAuth.instance.currentUser;
  bool? signedInAnon = FirebaseAuth.instance.currentUser?.isAnonymous;
  String? _userName;
  String? _email;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Make this display the scaffold first then the other if not a guest
    if (signedInAnon == true) {
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
              signedInAnon = false;
              Map<String, dynamic> data =
                  snapshot.data.data() as Map<String, dynamic>;
              _userName = data['userName'];
              mainMenuScaffold(context, _userName);
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

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}

Scaffold mainMenuScaffold(BuildContext context, String? userName) {
  return Scaffold(
      backgroundColor: lightBruinBlue,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              'RUN BRUIN RUN',
              style: TextStyle(
                fontSize: 28,
                color: darkBruinBlue,
                fontFamily: 'PressStart2P',
              ),
            ),
            Text(
              'Welcome \n$userName',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontFamily: 'PressStart2P',
              ),
            ),
            Wrap(
              direction: Axis.horizontal,
              runAlignment: WrapAlignment.center,
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 30,
              children: <Widget>[
                const Text(
                  'SINGLE PLAYER',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontFamily: 'PressStart2P',
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
                const Text(
                  'MULTIPLAYER',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontFamily: 'PressStart2P',
                  ),
                ),
                ElevatedButton(
                    style: getSmallButtonStyle(),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CreateSessionPage()));
                    },
                    child: const Text('Create Session')),
                ElevatedButton(
                    style: getSmallButtonStyle(),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const JoinSessionPage()));
                    },
                    child: const Text('Join Session')),
                const Text(
                  'SCOREBOARD',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontFamily: 'PressStart2P',
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
                SizedBox(
                  height: 80,
                  width: 250,
                  child: ElevatedButton(
                      style: getButtonStyle(),
                      onPressed: () {
                        _signOut();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()));
                      },
                      child: const Text(
                        'Logout',
                        style: TextStyle(fontSize: 20),
                      )),
                )
              ],
            ),
          ],
        ),
      ));
}

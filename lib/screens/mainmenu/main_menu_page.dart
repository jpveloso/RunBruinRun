import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:run_bruin_run/screens/homepage/home_page.dart';
import 'package:run_bruin_run/screens/sessionpages/create_session_page.dart';
import 'package:run_bruin_run/screens/sessionpages/join_session_page.dart';
import 'package:run_bruin_run/screens/usercredentialpages/login_page.dart';

import '../../styles/button_styles.dart';
import '../../styles/colours.dart';

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({Key? key}) : super(key: key);

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  final User? authenticatedUser = FirebaseAuth.instance.currentUser;
  String username = "Guest";
  String? _email;
  String? _userName;
  FirebaseFirestore db = FirebaseFirestore.instance;

  // final TextEditingController _userEmail =
  //     emailFieldController;

  // User? user = FirebaseAuth.instance.currentUser;

  // getCurrentUserData() async {
  //   final User? user = FirebaseAuth.instance.currentUser;
  //   _email = user?.email;
  // }





  @override
  void initState() {
    super.initState();
    _email = authenticatedUser?.email;
    final docRef = db.collection("users").where('email', isEqualTo: _email);
  }




  // Future<void> getUser() async {
  //   FirebaseFirestore.instance.collection('users')
  //       .where('email', isEqualTo: _userEmail)
  //       .get()
  //       .then((value) {
  //         setState(() {
  //           _userEmail =
  //         });
  //   });
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: lightBruinBlue,
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // crossAxisAlignment: CrossAxisAlignment.center,
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
                'Welcome \n$username',
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
                                builder: (
                                    context) => const CreateSessionPage()));
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()));
                        },
                        child: const Text(
                          'Logout', style: TextStyle(fontSize: 20),)),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}

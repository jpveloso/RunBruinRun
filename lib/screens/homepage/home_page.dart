import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:run_bruin_run/screens/mainmenu/main_menu_page.dart';
import 'package:run_bruin_run/screens/usercredentialpages/signup_page.dart';

import '../../styles/button_styles.dart';
import '../../styles/colours.dart';
import '../usercredentialpages/login_page.dart';

//dart fix --apply

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: lightBruinBlue,
        resizeToAvoidBottomInset: false,
        // appBar: AppBar(
        //   backgroundColor: darkBruinBlue,
        //   title: Text('Run Bruin Run'),
        // ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/images/Sheridan_Bruins_Logo.png',
              ),
              const SizedBox(height: 50),
              const FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  'RUN BRUIN RUN',
                  style: TextStyle(
                    fontSize: 22,
                    color: darkBruinBlue,
                    fontFamily: 'PressStart2P',
                  ),
                ),
              ),
              const SizedBox(height: 120),
              Wrap(
                direction: Axis.vertical,
                // crossAxisAlignment: WrapCrossAlignment.center,
                // alignment: WrapAlignment.center,
                spacing: 20,
                children: [
                  ElevatedButton(
                      style: getButtonStyle(),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(),
                      )),
                  ElevatedButton(
                      style: getButtonStyle(),
                      onPressed: () async {
                        try {
                          final userCredential =
                              await FirebaseAuth.instance.signInAnonymously();
                          print("Signed in with temporary account.");
                        } on FirebaseAuthException catch (e) {
                          switch (e.code) {
                            case "operation-not-allowed":
                              print(
                                  "Anonymous auth hasn't been enabled for this project.");
                              break;
                            default:
                              print("Unknown error.");
                          }
                        }
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainMenuPage()));
                      },
                      child: const Text('Guest')),
                  ElevatedButton(
                      style: getButtonStyle(),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpPage()));
                      },
                      child: const Text('Sign Up')),
                ],
              ),
            ],
          ),
        ));
  }
}

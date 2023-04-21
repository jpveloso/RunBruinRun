import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:run_bruin_run/screens/loading_screens/loading_screen.dart';
import 'package:run_bruin_run/screens/mainmenu/main_menu_page.dart';
import 'package:run_bruin_run/screens/usercredentialpages/signup_page.dart';

import '../../styles/button_styles.dart';
import '../../styles/colours.dart';
import '../usercredentialpages/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    precacheImage(
        const AssetImage('assets/images/Sheridan_Bruins_Logo_Border.png'),
        context);
    ImageCache? imageCache = PaintingBinding.instance.imageCache;
    imageCache.clear();
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          backgroundColor: lightBruinBlue,
          resizeToAvoidBottomInset: false,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Sheridan_Bruins_Logo_Border.png',
                ),
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
                const SizedBox(height: 80),
                Wrap(
                  direction: Axis.vertical,
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
                          navigator.pushReplacement(MaterialPageRoute(
                              builder: (context) => const LoadingScreen()));
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
                        navigator.pushReplacement(MaterialPageRoute(
                            builder: (context) => const MainMenuPage()));
                      },
                      child: const Text('Guest'),
                    ),
                    ElevatedButton(
                      style: getButtonStyle(),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpPage()));
                      },
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}

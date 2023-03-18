import 'package:flutter/material.dart';
import 'package:run_bruin_run/screens/create_session_page.dart';
import 'package:run_bruin_run/screens/home_page.dart';
import 'package:run_bruin_run/screens/join_session_page.dart';
import 'package:run_bruin_run/styles.dart';

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({Key? key}) : super(key: key);

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  String username = "Guest";

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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()));
                        },
                        child: const Text('Logout', style: TextStyle(fontSize: 20),)),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}

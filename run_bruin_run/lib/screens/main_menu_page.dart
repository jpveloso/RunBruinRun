import 'package:flutter/material.dart';
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
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
                  const Text(
                    'RUN BRUIN RUN',
                    style: TextStyle(
                      fontSize: 28,
                      color: darkBruinBlue,
                      fontFamily: 'PressStart2P',
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Welcome',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontFamily: 'PressStart2P',
                    ),
                  ),
              const SizedBox(height: 10),
              Text(
                username,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontFamily: 'PressStart2P',
                ),
              ),
              const SizedBox(height: 50),
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
                      onPressed: () {},
                      child: const Text('Create Session')),
                  ElevatedButton(
                      style: getSmallButtonStyle(),
                      onPressed: () {},
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
                ],
              ),
            ],
          ),
        ));
  }
}

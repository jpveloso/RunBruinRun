import 'package:flutter/material.dart';

import '../../styles/button_styles.dart';
import '../../styles/colours.dart';
import '../loading_screens/basketball_game_loading_screen.dart';
import '../mainmenu/main_menu_page.dart';

class BasketBallGameOverScreen extends StatefulWidget {
  bool gameOver;

  BasketBallGameOverScreen({Key? key, required this.gameOver})
      : super(key: key);

  @override
  BasketBallGameOverScreenState createState() =>
      BasketBallGameOverScreenState();
}

class BasketBallGameOverScreenState extends State<BasketBallGameOverScreen> {
  @override
  void initState() {
    super.initState();
  }

  void onPlayAgain() {
    setState(() {
      widget.gameOver = false;
    });
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => const BasketBallGameLoadingScreen()));
   }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.longestSide,
      color: darkBruinBlue.withOpacity(0.8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const FittedBox(
            fit: BoxFit.fitWidth,
            alignment: Alignment.center,
            child: Text(
              'Game Over',
              style: TextStyle(
                  fontSize: 34,
                  color: Colors.white,
                  fontFamily: 'PressStart2P',
                  decoration: TextDecoration.none),
            ),
          ),
          const SizedBox(height: 50),
          ElevatedButton(
            style: getButtonStyle(),
            onPressed: () {
              onPlayAgain();
            },
            child: const Text(
              'Play Again?',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontFamily: 'PressStart2P',
                  decoration: TextDecoration.none),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: getButtonStyle(),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MainMenuPage()));
            },
            child: const Text(
              'Quit',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontFamily: 'PressStart2P',
                  decoration: TextDecoration.none),
            ),
          ),
        ],
      ),
    );
  }
}

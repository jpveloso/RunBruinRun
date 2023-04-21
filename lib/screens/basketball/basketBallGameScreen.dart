import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../styles/colours.dart';
import '../mainmenu/main_menu_page.dart';
import 'basketball_game_over_screen.dart';
import 'game.dart';

class BasketballGameScreen extends StatefulWidget {
  const BasketballGameScreen({Key? key}) : super(key: key);

  @override
  State<BasketballGameScreen> createState() => _BasketballGameScreenState();
}

class _BasketballGameScreenState extends State<BasketballGameScreen> {
  bool _gameOver = false;
  bool _isTapped = false;

  void updateGameOver(bool gameOver) {
    setState(() {
      _gameOver = gameOver;
    });
  }

  void _handleTap() {
    setState(() {
      _isTapped = true;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _gameOver = false;
      _isTapped = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final game = BasketballGame(updateGameOver,
        _gameOver); // pass _gameOver variable to BasketballGame constructor
    final dragger = Dragger(game);
    Size screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        Scaffold(
          body: Stack(
            children: [
              if (_isTapped)
                GestureDetector(
                  onPanStart: dragger.onDragStart,
                  onPanUpdate: dragger.onDragUpdate,
                  onPanEnd: dragger.onDragEnd,
                  child: GameWidget(game: game),
                ),
              if (!_isTapped)
                GestureDetector(
                  onTap: () {
                    _handleTap();
                  },
                  child: Scaffold(
                    backgroundColor: lightBruinBlue,
                    resizeToAvoidBottomInset: false,
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Text(
                            'Tap to Play!',
                            style: TextStyle(
                              fontSize: 28,
                              color: darkBruinBlue,
                              fontFamily: 'PressStart2P',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: 30,
                right: 20,
                child: SizedBox(
                  width: 42,
                  height: 42,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 1),
                      shape: BoxShape.circle,
                      color: lightBruinBlue,
                    ),
                    child: IconButton(
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainMenuPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.clear),
                    ),
                  ),
                ),
              ),
              if (_gameOver)
                BasketBallGameOverScreen(gameOver: _gameOver)
            ],
          ),
        ),
      ],
    );
  }
}

class Dragger {
  final BasketballGame game;

  Dragger(this.game);

  void onDragStart(DragStartDetails details) {
    game.activeBall.onDragStart(details);
  }

  void onDragUpdate(DragUpdateDetails details) {
    game.activeBall.onDragUpdate(details);
  }

  void onDragEnd(DragEndDetails details) {
    game.activeBall.onDragEnd(details);
  }
}

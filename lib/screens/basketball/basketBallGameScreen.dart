import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'game.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _gameOver = false;

  void _updateGameOver(bool gameOver) {
    setState(() {
      _gameOver = gameOver;
    });
  }

  @override
  Widget build(BuildContext context) {
    final game = BasketballGame();
    final dragger = Dragger(game);

    return Stack(
      children: [
        Scaffold(
          body: GestureDetector(
            onPanStart: dragger.onDragStart,
            onPanUpdate: dragger.onDragUpdate,
            onPanEnd: dragger.onDragEnd,
            child: GameWidget(game: game),
          ),
        ),
        if (_gameOver)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.7),
              child: const Center(
                child: Text(
                  'Game Over',
                  style: TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                  ),
                ),
              ),
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

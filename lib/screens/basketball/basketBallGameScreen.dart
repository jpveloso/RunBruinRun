import 'dart:math';

import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../mainmenu/main_menu_page.dart';
import 'game.dart';

class GameScreen extends StatelessWidget {
  final VoidCallback onQuit;

  const GameScreen({Key? key, required this.onQuit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final game = BasketballGame(
      onQuit: () {
        // Implement the navigation to MainMenuPage here
        // This is just an example, you might need to modify it depending on your implementation
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => MainMenuPage()));
      },
    );
    final dragger = Dragger(game);

    return MaterialApp(
      title: 'Flutter Bruin BB',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GestureDetector(
          onPanStart: dragger.onDragStart,
          onPanUpdate: dragger.onDragUpdate,
          onPanEnd: dragger.onDragEnd,
          child: GameWidget(game: game),
        ),
      ),
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
    Vector2 dragVector = game.activeBall.dragStartPosition! - details.globalPosition.toVector2();
  }
  void onDragEnd(DragEndDetails details) {
    game.activeBall.onDragEnd(details);
  }
}

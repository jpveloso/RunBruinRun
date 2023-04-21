import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
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
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const MainMenuPage()));
      },
    );;
    final dragger = Dragger(game);

    return MaterialApp(
      title: 'Flutter Bruin BB',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            GestureDetector(
              onPanStart: dragger.onDragStart,
              onPanUpdate: dragger.onDragUpdate,
              onPanEnd: dragger.onDragEnd,
              child: GameWidget(game: game),
            ),
            Positioned(
              right: 20,
              top: 20,
              child: Wrap(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              const MainMenuPage()));
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ],
              ),
            ),
          ],
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
    if (game.activeBall.dragStartPosition != null) {
      Vector2 dragVector = game.activeBall.dragStartPosition! - details.globalPosition.toVector2();
    }
  }

  void onDragEnd(DragEndDetails details) {
    game.activeBall.onDragEnd(details);
  }
}

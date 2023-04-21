import 'package:flame/components.dart';
import 'package:flutter/material.dart' show Canvas, Colors, TextDirection, TextPainter, TextSpan, TextStyle, VoidCallback;
import 'package:flame/extensions.dart';
import 'package:run_bruin_run/screens/basketball/textButtonComponent.dart';

class GameOverOverlay extends Component {
  final int finalScore;
  final Sprite bearSprite;
  final Vector2 screenSize;
  final VoidCallback onPlayAgain;
  final VoidCallback onQuit;
  late TextButtonComponent playAgainButton;
  late TextButtonComponent quitButton;

  GameOverOverlay({
    required this.finalScore,
    required this.bearSprite,
    required this.screenSize,
    required this.onPlayAgain,
    required this.onQuit,
  }) {
    // playAgainButton = TextButtonComponent(
    //   text: 'Play Again',
    //   textStyle: const TextStyle(color: Colors.white, fontSize: 24),
    //   onPressed: onPlayAgain,
    // );
    // playAgainButton.position = screenSize / 2 - Vector2(playAgainButton.textPainter.width / 2, 50);
    //
    // quitButton = TextButtonComponent(
    //   text: 'Quit',
    //   textStyle: const TextStyle(color: Colors.white, fontSize: 24),
    //   onPressed: onQuit,
    // );
    // quitButton.position = screenSize / 2 - Vector2(quitButton.textPainter.width / 2, -50);
  }

  @override
  void render(Canvas canvas) {
    // Render the bearSprite sprite at the center of the screen
    bearSprite.render(
      canvas,
      position: screenSize / 2 - Vector2(100, 150),
      size: Vector2(200, 300),
    );

    // Render the score in a smaller font above the bearSprite sprite
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Score: $finalScore',
        style: const TextStyle(color: Colors.black, fontSize: 40.0),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(screenSize.x / 2 - textPainter.width / 2, screenSize.y / 2 - 200));

    playAgainButton.render(canvas);
    quitButton.render(canvas);
  }

  @override
  bool isHud() => true;
}

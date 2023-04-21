import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/extensions.dart';

class GameOverOverlay extends Component {
  final int finalScore;
  final Sprite bearSprite;
  final Vector2 screenSize;
  final VoidCallback onPlayAgain;
  final VoidCallback onQuit;

  GameOverOverlay({
    required this.finalScore,
    required this.bearSprite,
    required this.screenSize,
    required this.onPlayAgain,
    required this.onQuit,
  });

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
        style: const TextStyle(color: Colors.white, fontSize: 40.0),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(screenSize.x / 2 - textPainter.width / 2, screenSize.y / 2 - 200));

    // Render Play Again button
    final playAgainPainter = TextPainter(
      text: const TextSpan(
        text: 'Play Again',
        style: TextStyle(color: Colors.white, fontSize: 24.0),
      ),
      textDirection: TextDirection.ltr,
    );
    playAgainPainter.layout();
    playAgainPainter.paint(canvas, Offset(screenSize.x / 2 - playAgainPainter.width / 2, screenSize.y / 2 + 50));

    // Render Quit button
    final quitPainter = TextPainter(
      text: const TextSpan(
        text: 'Quit',
        style: TextStyle(color: Colors.white, fontSize: 24.0),
      ),
      textDirection: TextDirection.ltr,
    );
    quitPainter.layout();
    quitPainter.paint(canvas, Offset(screenSize.x / 2 - quitPainter.width / 2, screenSize.y / 2 + 100));
  }

  @override
  bool isHud() => true;

  @override
  bool onTapDown(Vector2 eventPosition) {
    final playAgainRect = Rect.fromLTWH(screenSize.x / 2 - 50, screenSize.y / 2 + 50, 100, 30);
    final quitRect = Rect.fromLTWH(screenSize.x / 2 - 50, screenSize.y / 2 + 100, 100, 30);

    if (playAgainRect.contains(eventPosition.toOffset())) {
      onPlayAgain();
      return true;
    } else if (quitRect.contains(eventPosition.toOffset())) {
      onQuit();
      return true;
    }

    return false;
  }
}

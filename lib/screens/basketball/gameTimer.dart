import 'dart:async';
import 'package:flutter/material.dart' show Canvas, Colors, Offset, TextDirection, TextPainter, TextSpan, TextStyle;

class GameTimer {
  double countdownTimer;
  bool gameOver;
  final Function onGameOver;
  late TextPainter textPainter;
  final double xPosition;
  final double yPosition;
  Timer? _timer;

  GameTimer({
    required this.countdownTimer,
    required this.onGameOver,
    required this.xPosition,
    required this.yPosition,
  }) : gameOver = false {
    textPainter = TextPainter(textDirection: TextDirection.ltr);
  }

  void startTimer() {
    _timer ??= Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        if (countdownTimer > 0) {
          countdownTimer--;
        } else {
          timer.cancel();
          gameOver = true;
          onGameOver(); // Call onGameOver() when the timer runs out
        }
      });
  }
  void cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }
  void reset() {
    cancelTimer();
    countdownTimer = 30;
    gameOver = false;
  }
  void render(Canvas canvas) {
    textPainter.text = TextSpan(
      text: 'Time: $countdownTimer',
      style: TextStyle(color: Colors.blue.shade300, fontSize: 20.0),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(xPosition/2, 20));

  }
}

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors, TextPainter, TextAlign;
import 'ball.dart';
import 'floor.dart';
import 'gameOverOverlay.dart';
import 'gameTimer.dart';
import 'hoop.dart';
bool _gameOver = false;
class BasketballGame extends FlameGame with TapDetector {
  late Ball ball;
  late Vector2 screenSize;
  late Floor floor, rimFront, rimBack,backBoard;
  late Hoop hoop;
  GameOverOverlay? gameOverOverlay; // Add this line to store the game over overlay
   // Add this line to track the game over state
  late Sprite gameOverBearSprite; // Declare the gameOverBearSprite sprite

  int score = 0;
  late TextPainter textPainter;
  List<Ball> balls = [];
  Ball get activeBall => balls.last;
  late GameTimer gameTimer; // Add this line to declare the GameTimer variable

  void increaseScore() {
    score++;
  }

  void addNewBall() async {
    final ballSprite = await Sprite.load('BBall.png');
    final newBall = Ball(
      size: Vector2(50, 50),
      position: ball.initialPosition,
      sprite: ballSprite,
      gameRef: this,
    );
    add(newBall);
    balls.add(newBall);
  }

  void renderScore(Canvas canvas) {
    textPainter.text = TextSpan(
      text: '$score',
      style: TextStyle(color: Colors.green.shade300, fontSize: 70.0),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(screenSize.x / 6 - textPainter.width / 6, 40));
  }

  @override
  Future<void> onLoad() async {
    textPainter = TextPainter(textDirection: TextDirection.ltr);
    final backgroundSprite = await Sprite.load('BBBackground.png');
    final playerSprite = await Sprite.load('BBPlayer.png');
    final ballSprite = await Sprite.load('BBall.png');
    final hoopSprite = await Sprite.load('BBHoop.png');
    gameOverBearSprite = await Sprite.load('BBGameOverBear.png'); // Load the gameOverBearSprite sprite

    final background = SpriteComponent(
      size: size,
      sprite: backgroundSprite,
    );

    final player = SpriteComponent(
      size: Vector2(115, 170),
      position: Vector2(20, 550),
      sprite: playerSprite,
    );

    ball = Ball(
      size: Vector2(50, 50),
      position: Vector2(90, 670),
      sprite: ballSprite,
      gameRef: this,
    );
    balls.add(ball);
    rimFront = Floor(
      position: Vector2(230, 260),
      size: Vector2(10, 10),
      gameRef: this,
    );
    rimBack = Floor(
      position: Vector2(330, 260),
      size: Vector2(10, 10),
      gameRef: this,
    );
    backBoard = Floor(
      position: Vector2(360, 100),
      size: Vector2(10, 130),
      gameRef: this,
    );
    // Create Hoop after initializing rimFront and rimBack
    hoop = Hoop(
      rimFront: rimFront,
      rimBack: rimBack,
      backBoard: 150.0 + 30, // Add backBoard parameter
      gameRef: this,
      hoopSprite: hoopSprite,
    );
    gameTimer = GameTimer(
      countdownTimer: 30,
      onGameOver: () {
        _gameOver = true;
        gameOverOverlay = GameOverOverlay(
          finalScore: score,
          bearSprite: gameOverBearSprite,
          screenSize: screenSize,
          onPlayAgain: () {
            _gameOver = false;
            score = 0;
            addGameTimer();
            createNewBall();
          },
          onQuit: () {
            // Implement the quit functionality here.
          },
        );
      },
      xPosition: screenSize.x / 1.5,
      yPosition: 20,
    );
    add(background);
    add(player);
    add(ball);
    add(rimFront);
    add(rimBack);
    add(backBoard);
    hoop.addToGame(this);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    screenSize = size;
  }

  void onTapDown(TapDownInfo info) {
    if (_gameOver) {
      gameOverOverlay?.playAgainButton.onTapDown(info);
      gameOverOverlay?.quitButton.onTapDown(info);
    } else {
      ball.onTapDown(info.eventPosition.global);
    }
  }
  void removeBall(Ball ball) {
    remove(ball);
    balls.remove(ball);
  }

  Future<void> createNewBall() async {
    final ballSprite = await Sprite.load('BBall.png');
    final newBall = Ball(
      size: Vector2(50, 50),
      position: ball.initialPosition,
      sprite: ballSprite,
      gameRef: this,
    );
    add(newBall);
    balls.add(newBall);
  }
  @override
  void update(double dt) {
    if (!_gameOver) {
      super.update(dt);
    }
  }
  void addGameTimer() {
    gameTimer = GameTimer(
      countdownTimer: 30,
      onGameOver: () {
        _gameOver = true;
        gameOverOverlay = GameOverOverlay(
          finalScore: score,
          bearSprite: gameOverBearSprite,
          screenSize: screenSize,
          onPlayAgain: () {
            _gameOver = false;
            score = 0;
            addGameTimer(); // Add a new instance of GameTimer
            createNewBall();
          },
          onQuit: () {
            // Implement the quit functionality here.
          },
        );      },
      xPosition: screenSize.x / 1.5,
      yPosition: 20,
    );
  }
  @override
  void render(Canvas canvas) {
    if (_gameOver) {
      canvas.drawColor(Colors.white, BlendMode.srcOver); // Clear canvas with white color
      gameOverOverlay?.render(canvas);

    } else {
      super.render(canvas);
      renderScore(canvas);
      gameTimer.render(canvas); // Render the game timer
    }
  }
}

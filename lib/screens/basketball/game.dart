import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors, TextPainter;
import '../../services/BBscore_service.dart';
import 'ball.dart';
import 'floor.dart';
import 'gameOverOverlay.dart';
import 'gameTimer.dart';
import 'hoop.dart';
class BasketballGame extends FlameGame with TapDetector {
  late Ball ball;
  late Vector2 screenSize;
  late Floor floor, rimFront, rimBack,backBoard;
  late Hoop hoop;
  final bool _timerIsActive = false;
  GameOverOverlay? gameOverOverlay; // Add this line to store the game over overlay
  late Sprite gameOverBearSprite; // Declare the gameOverBearSprite sprite
  bool _gameOver = false; // Move the _gameOver variable inside the class
  final VoidCallback onQuit;
  BasketballGame({required this.onQuit});

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
    screenSize = size; // Initialize screenSize with a non-null value
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
      position: Vector2(220, 310),
      size: Vector2(10, 10),
      gameRef: this,
    );
    rimBack = Floor(
      position: Vector2(320, 310),
      size: Vector2(10, 10),
      gameRef: this,
    );
    backBoard = Floor(
      position: Vector2(360, 150),
      size: Vector2(10, 180),
      gameRef: this,
    );
    // Create Hoop after initializing rimFront and rimBack
    hoop = Hoop(
      rimFront: rimFront,
      rimBack: rimBack,
      backBoard: 200.0 + 30, // Add backBoard parameter
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
            gameTimer.reset(); // Reset the game timer
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

  @override
  void onTapDown(TapDownInfo info) {
    if (_gameOver) {
      if (_isTapWithinQuitButton(info.eventPosition.global)) {
        onQuit();
      } else if (_isTapWithinPlayAgainButton(info.eventPosition.global)) {
        _gameOver = false;
        score = 0;
        gameTimer.reset();
        createNewBall();

      }
    } else {
      if (!_timerIsActive) {
        gameTimer.startTimer();
      }
      ball.onTapDown(info.eventPosition.global);
    }
  }

  void saveScoreToFirebase(int score) {

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
      countdownTimer: 10,
      onGameOver: () {
        _gameOver = true;
        gameOverOverlay = GameOverOverlay(
          finalScore: score,
          bearSprite: gameOverBearSprite,
          screenSize: screenSize,
          onPlayAgain: () {
            _gameOver = false;
            score = 0;
            gameTimer.reset(); // Reset the game timer
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
  void renderGameTimer(Canvas canvas) {
    gameTimer.textPainter.text = TextSpan(
      text: 'Time: ${gameTimer.countdownTimer}',
      style: TextStyle(color: Colors.blue.shade300, fontSize: 20.0),
    );
    gameTimer.textPainter.layout();
    gameTimer.textPainter.paint(canvas, Offset(gameTimer.xPosition / 2, 20));
  }
  bool _isTapWithinQuitButton(Vector2 tapPosition) {
    double quitTextX = screenSize.x / 2;
    double quitTextY = screenSize.y / 2 + 100;
    double quitTextWidth = 100; // You can adjust this value according to the actual width of the text
    double quitTextHeight = 24; // You can adjust this value according to the actual height of the text

    return tapPosition.x >= quitTextX &&
        tapPosition.x <= quitTextX + quitTextWidth &&
        tapPosition.y >= quitTextY &&
        tapPosition.y <= quitTextY + quitTextHeight;
  }
  bool _isTapWithinPlayAgainButton(Vector2 tapPosition) {
    double playAgainTextX = screenSize.x / 2;
    double playAgainTextY = screenSize.y / 2 + 60; // Adjust the Y position accordingly
    double playAgainTextWidth = 150; // You can adjust this value according to the actual width of the text
    double playAgainTextHeight = 24; // You can adjust this value according to the actual height of the text

    return tapPosition.x >= playAgainTextX &&
        tapPosition.x <= playAgainTextX + playAgainTextWidth &&
        tapPosition.y >= playAgainTextY &&
        tapPosition.y <= playAgainTextY + playAgainTextHeight;
  }
  bool _scoreSaved = false;

  @override
  void render(Canvas canvas) {
    if (_gameOver) {
      if (!_scoreSaved) {
        BBsaveHighScore(score);
        _scoreSaved = true;
      }
      canvas.drawColor(Colors.black, BlendMode.srcOver); // Clear canvas with white color
      gameOverOverlay?.render(canvas);

    } else {
      super.render(canvas);
      renderScore(canvas);
      renderGameTimer(canvas); // Call the new renderGameTimer method
    }
  }
}

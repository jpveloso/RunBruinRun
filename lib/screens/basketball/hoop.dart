import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'ball.dart';
import 'floor.dart';
import 'game.dart';

class Hoop {
  late SpriteComponent hoopSpriteComponent;
  late BasketballGame gameRef;
  late Floor rimFront, rimBack;
  double backBoard;

  Hoop({
    required this.rimFront,
    required this.rimBack,
    required this.backBoard,
    required this.gameRef,
    required Sprite hoopSprite,
  }) {
    hoopSpriteComponent = SpriteComponent(
      size: Vector2(250, 700),
      position: Vector2(rimFront.position.x - 9, backBoard-120),
      sprite: hoopSprite,
    );
  }

  void addToGame(BasketballGame game) {
    game.add(hoopSpriteComponent);
  }

  bool isBallInsideRim(Ball ball) {
    return ball.position.x >= rimFront.position.x && ball.position.x <= rimBack.position.x;
  }
}

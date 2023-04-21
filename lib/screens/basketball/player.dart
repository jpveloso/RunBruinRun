import 'package:flame/components.dart';

class Player extends SpriteComponent {
  Player()
      : super(
    size: Vector2(150, 150),
    position: Vector2(50, 300),
//    sprite: Sprite('BBPlayer.png'),
  );

  @override
  void update(double t) {}
}
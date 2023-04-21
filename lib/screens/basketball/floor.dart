import 'dart:ui';

import 'package:flame/components.dart';

import 'game.dart';

class Floor extends PositionComponent {
  late BasketballGame gameRef;

  Floor({
    required Vector2 position,
    required Vector2 size,
    required this.gameRef,
  }) {
    this.position = position;
    this.size = size;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = Color(0xFF000000);
    canvas.drawRect(size.toRect(), paint);
  }
}
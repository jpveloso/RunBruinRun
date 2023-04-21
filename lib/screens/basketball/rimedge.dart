import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

class RimEdge extends PositionComponent {
  RimEdge({
    required Vector2 position,
    required Vector2 size,
    required Color color,
  }) {
    this.position = position;
    this.size = size;
    this.color = color;
  }

  late Color color;

  @override
  void render(Canvas canvas) {
    final rect = toRect();
    final paint = Paint()..color = color;
    canvas.drawRect(rect, paint);
  }
}

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class TextButtonComponent extends PositionComponent with Tappable {
  final String text;
  final TextStyle textStyle;
  final VoidCallback onPressed;
  late TextPainter textPainter;

  TextButtonComponent({required this.text, required this.textStyle, required this.onPressed}) {
    textPainter = TextPainter(textDirection: TextDirection.ltr);
  }

  @override
  void render(Canvas canvas) {
    textPainter.text = TextSpan(text: text, style: textStyle);
    textPainter.layout(); // Call textPainter.layout() here
    textPainter.paint(canvas, position.toOffset());
  }

  @override
  bool onTap() {
    onPressed();
    return true;
  }
}

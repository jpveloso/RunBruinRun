import 'package:flutter/widgets.dart';

import 'constants.dart';
import 'game_object.dart';
import 'sprite.dart';

List<Sprite> cacti = [
  Sprite()
    ..imagePath = "lib/images/hurdle.png"
    ..imageWidth = 40
    ..imageHeight = 60,
];

class Hurdle extends GameObject {
  final Sprite sprite;
  final Offset worldLocation;

  Hurdle({required this.worldLocation}) : sprite = cacti[0]; // Select the only sprite available.

  @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
      (worldLocation.dx - runDistance) * worlToPixelRatio,
      screenSize.height / 1.2 - sprite.imageHeight,
      sprite.imageWidth.toDouble(),
      sprite.imageHeight.toDouble(),
    );
  }

  @override
  Widget render() {
    return Image.asset(sprite.imagePath);
  }
}
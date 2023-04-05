import 'dart:math';

import 'package:flutter/widgets.dart';

import 'constants.dart';
import 'game_object.dart';
import 'sprite.dart';

List<Sprite> cacti = [
  Sprite()
    ..imagePath = "images/hurdle.png"
    ..imageWidth = 104
    ..imageHeight = 100,
  Sprite()
    ..imagePath = "images/hurdle.png"
    ..imageWidth = 50
    ..imageHeight = 100,
  Sprite()
    ..imagePath = "images/hurdle.png"
    ..imageWidth = 98
    ..imageHeight = 100,
  Sprite()
    ..imagePath = "images/hurdle.png"
    ..imageWidth = 34
    ..imageHeight = 70,
  Sprite()
    ..imagePath = "images/hurdle.png"
    ..imageWidth = 68
    ..imageHeight = 70,
  Sprite()
    ..imagePath = "images/hurdle.png"
    ..imageWidth = 107
    ..imageHeight = 70,
];

class Hurdle extends GameObject {
  final Sprite sprite;
  final Offset worldLocation;

  Hurdle({required this.worldLocation}) : sprite = cacti[Random().nextInt(cacti.length)];

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
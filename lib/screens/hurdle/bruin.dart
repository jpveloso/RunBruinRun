import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'constants.dart';
import 'game_object.dart';
import 'sprite.dart';

List<Sprite> bruin = [
  Sprite()
    ..imagePath = "images/bear/player_bear.png"
    ..imageWidth = 88
    ..imageHeight = 94,
  Sprite()
    ..imagePath = "images/bear/player_bear.png"
    ..imageWidth = 88
    ..imageHeight = 94,
  Sprite()
    ..imagePath = "images/bear/player_bear.png"
    ..imageWidth = 88
    ..imageHeight = 94,
  Sprite()
    ..imagePath = "images/bear/player_bear.png"
    ..imageWidth = 88
    ..imageHeight = 94,
  Sprite()
    ..imagePath = "images/bear/player_bear.png"
    ..imageWidth = 88
    ..imageHeight = 94,
  Sprite()
    ..imagePath = "images/bear/player_bear.png"
    ..imageWidth = 88
    ..imageHeight = 94,
];

enum BruinState {
  jumping,
  running,
  dead,
}

class Bruin extends GameObject {
  Sprite currentSprite = bruin[0];
  double dispY = 0;
  double velY = 0;
  BruinState state = BruinState.running;

  @override
  Widget render() {
    return Image.asset(currentSprite.imagePath);
  }

  @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
      screenSize.width / 10,
      screenSize.height / 1.2 - currentSprite.imageHeight - dispY,
      currentSprite.imageWidth.toDouble(),
      currentSprite.imageHeight.toDouble(),
    );
  }

  @override
  void update(Duration lastUpdate, Duration? elapsedTime) {
    double elapsedTimeSeconds;
    try {
      currentSprite = bruin[(elapsedTime!.inMilliseconds / 100).floor() % 2 + 2];
    } catch (_) {
      currentSprite = bruin[0];
    }
    try{
      elapsedTimeSeconds = (elapsedTime! - lastUpdate).inMilliseconds / 1000;
    }
    catch(_){
      elapsedTimeSeconds = 0;
    }


    dispY += velY * elapsedTimeSeconds;
    if (dispY <= 0) {
      dispY = 0;
      velY = 0;
      state = BruinState.running;
    } else {
      velY -= gravity * elapsedTimeSeconds;
    }
  }

  void jump() {
    if (state != BruinState.jumping) {
      state = BruinState.jumping;
      velY = jumpVelocity;
    }
  }

  void die() {
    currentSprite = bruin[5];
    state = BruinState.dead;
  }
}

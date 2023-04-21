import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/cupertino.dart';

import 'floor.dart';
import 'game.dart';

class Ball extends SpriteComponent {
  late Vector2 velocity;
  late BasketballGame gameRef;
  Vector2? dragStartPosition;
  Vector2 initialPosition;
  Vector2? lastDragPosition;
  bool hasScored = false;

  bool isTapped = false;
  bool isMoving = false;
  late TextComponent scoreText;

  final double gravity = 900; // Declare gravity as a class variable
  final double bounceFactor = 0.6; // Declare bounceFactor as a class variable

  Ball({
    required Vector2 position,
    required Vector2 size,
    required Sprite sprite,
    required this.gameRef,
  }) : initialPosition = position.clone(),
        super(position: position, size: size, sprite: sprite) {
    velocity = Vector2.zero();
  }


  void addComponent(TextComponent textComponent) {
    scoreText = textComponent;
  }

  void updateScoreText() {
    scoreText.text = 'Score: ${gameRef.score}';
  }



  @override
  void update(double dt) {
    super.update(dt);
    // Check if ball has scored
    bool isBallCloseToRimY = position.y > gameRef.rimFront.position.y - size.y &&
        position.y < gameRef.rimFront.position.y + gameRef.rimFront.size.y;

    if (gameRef.hoop.isBallInsideRim(this) && !hasScored && isBallCloseToRimY) {
      gameRef.increaseScore();
      hasScored = true;
    }
    // Check for collision with the front rim
    if (isCollidingWithFloor(gameRef.rimFront)) {
      handleRimCollision(gameRef.rimFront);
    }

    // Check for collision with the back rim
    if (isCollidingWithFloor(gameRef.rimBack)) {
      handleRimCollision(gameRef.rimBack);
    }
    if (isCollidingWithBackboard(gameRef.backBoard)) {
      handleBackboardCollision(gameRef.backBoard);
    }

    // Call handleBackboardCollision
    handleBackboardCollision(gameRef.backBoard);
    if (isMoving) {
      if (dragStartPosition == null) {
        position += velocity * dt;
        velocity.y += gravity * dt; // Use gravity class variable
      } else {
        position += velocity * dt;
        velocity.y += gravity * dt; // Use gravity class variable
      }

      // Check for collision with the screen floor
      if (position.y > (gameRef.screenSize.y - size.y)) {
        position.y = gameRef.screenSize.y - size.y;
        velocity.y *= -bounceFactor; // Use bounceFactor class variable
      }
      // Check if the ball is offscreen
      if (position.x < -size.x || position.x > gameRef.screenSize.x + size.x) {
        gameRef.removeBall(this); // Use the new removeBall method
      }
    }
  }
  void handleRimCollision(Floor rim) {
    final collisionNormal = (position + (size / 2)) - (rim.position + (rim.size / 2));
    collisionNormal.normalize();

    final relativeVelocity = velocity;
    final double impulseMagnitude = -(1 + bounceFactor) * relativeVelocity.dot(collisionNormal);

    final impulse = collisionNormal * impulseMagnitude;
    velocity += impulse;

    // Separation logic
    final overlap = (size.y / 2) + (rim.size.y / 2) - position.distanceTo(rim.position);
    if (overlap > 0) {
      final separation = collisionNormal * overlap;
      position += separation;
    }
  }

  bool isCollidingWithFloor(Floor floor) {
    final ballRect = toRect();
    final floorRect = floor.toRect();
    return ballRect.overlaps(floorRect);
  }

  void handleBackboardCollision(Floor backboard) {
    final ballRect = toRect();
    final backboardRect = backboard.toRect();

    if (ballRect.overlaps(backboardRect)) {
      final overlapX = ballRect.right - backboardRect.left;

      // Separate the ball and backboard
      position.x -= overlapX;

      // Reverse the horizontal velocity and apply bounce factor
      velocity.x = -velocity.x * bounceFactor;
    }
  }




  void onTapDown(Vector2 details) {
    if (toRect().contains(details.toOffset())) {
      velocity = (details.toOffset() - position.toOffset()).toVector2()..scaleTo(100.0);
      isTapped = true;
      isMoving = true;

      // Schedule a new ball to be created after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        gameRef.addNewBall();
      });
    }
  }
  void onDragStart(DragStartDetails details) {
    final touchPosition = details.localPosition;
    if (toRect().contains(touchPosition)) {
      dragStartPosition = touchPosition.toVector2();
    }
  }

  void onDragUpdate(DragUpdateDetails details) {
    final touchPosition = details.localPosition;
    if (dragStartPosition != null) {
      lastDragPosition = touchPosition.toVector2();
    }
  }

  void onDragEnd(DragEndDetails details) {
    if (dragStartPosition != null && lastDragPosition != null) {
      final dragVector = (dragStartPosition! - lastDragPosition!);
      const dragMultiplier = 6.0; // Adjust this value to control the strength of the fling
      velocity = dragVector * dragMultiplier;
      dragStartPosition = null;
      lastDragPosition = null;
      isMoving = true;

      // Schedule a new ball to be created after 2 seconds
      Future.delayed(const Duration(seconds: 1), () {
        gameRef.addNewBall();
      });
    }
  }

  bool isCollidingWithBackboard(Floor backboard) {
    final ballRect = toRect();
    final backboardRect = backboard.toRect();
    return ballRect.overlaps(backboardRect);
  }



}

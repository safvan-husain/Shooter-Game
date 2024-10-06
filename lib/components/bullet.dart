import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../main.dart';

class Bullet extends SpriteAnimationComponent
    with HasGameRef<SpaceShooterGame> {
  final double directionAngle;
  Bullet({super.position, this.directionAngle = 0.0})
      : super(
          size: Vector2(25, 50),
          anchor: Anchor.topLeft,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox(collisionType: CollisionType.passive));

    animation = await game.loadSpriteAnimation(
      'bullet.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: .2,
        textureSize: Vector2(8, 16),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (position.y > gameRef.size.y || position.x > gameRef.size.y) return;

    var newP = calculateNewPosition(
      Point(position.x, position.y),
      angle,
      dt * 100,
    );

    position.y = newP.y;
    position.x = newP.x;

    if (position.y < -height) {
      removeFromParent();
    } else if (position.x < -width) {
      removeFromParent();
    }

    if(position.y == gameRef.size.y) {
      removeFromParent();
    }
  }
}

class Point {
  double x;
  double y;

  Point(this.x, this.y);
}

Point calculateNewPosition(
    Point currentPosition, double angleInDegrees, double k) {

  var angleInRadians = angleInDegrees + (270 * (pi / 180));
  var dx = k * cos(angleInRadians);
  var dy = k * sin(angleInRadians);
  var newX = currentPosition.x + dx;
  var newY = currentPosition.y + dy;
  return Point(newX, newY);
}
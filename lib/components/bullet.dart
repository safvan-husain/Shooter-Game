import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../main.dart';

class Bullet extends SpriteAnimationComponent
    with HasGameReference<SpaceShooterGame>  {
  Bullet({
    super.position,
    super.angle
  }) : super(
    size: Vector2(25, 50),
    anchor: Anchor.topLeft,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox( collisionType: CollisionType.passive));

    animation = await game.loadSpriteAnimation(
      'bullet.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: .2,
        textureSize: Vector2(8, 16),
      ),
    );

    print("plane bullet postion $position");
    print("bullet from topLeft ${positionOfAnchor(Anchor.topLeft)}");

    print("bullet from center ${positionOfAnchor(Anchor.center)}");
  }

  @override
  void update(double dt) {
    super.update(dt);

    // var newP = calculateNewPosition(Point(position.x, position.y), angle, dt * 100);
    //
    // position.y = newP?.y ?? position.y + 10;
    // position.x = newP?.x ?? position.x + 10;

    if (position.y < -height) {
      removeFromParent();
    } else if (position.x < -width) {
      removeFromParent();
    }
  }
}

class Point {
  double x;
  double y;

  Point(this.x, this.y);
}

Point? calculateNewPosition(Point currentPosition, double angleInDegrees, double k) {
  var angleInRadians = angleInDegrees * (pi / 180);
  var dx = k * cos(angleInRadians);
  var dy = k * sin(angleInRadians);
  var newX = currentPosition.x + dx;
  var newY = currentPosition.y + dy;
  // print("old (${currentPosition.x}, ${currentPosition.y}) and new ($newX, $newY})");
  // return Point(newX, newY);
  return null;
}
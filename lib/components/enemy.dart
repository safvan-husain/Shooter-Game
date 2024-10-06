import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';

import '../main.dart';
import 'bullet.dart';
import 'explosion.dart';

class CometSmall extends SpriteComponent
    with HasGameReference<SpaceShooterGame>, CollisionCallbacks {

  CometSmall({
    super.position,
  }) : super(
    size: Vector2.all(enemySize),
    anchor: Anchor.center,
  );


  static const enemySize = 50.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());

      sprite = await game.loadSprite(
      'stone2.png',
      // SpriteAnimationData.sequenced(
      //   amount: 4,
      //   stepTime: .2,
      //   textureSize: Vector2.all(16),
      // ),
    );
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints,
      PositionComponent other,
      ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Bullet) {
      removeFromParent();
      other.removeFromParent();
      game.add(Explosion(position: position));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y += dt * 250;

    if (position.y > game.size.y) {
      removeFromParent();
    }
  }
}
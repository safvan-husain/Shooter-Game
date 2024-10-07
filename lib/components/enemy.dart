import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';

import '../main.dart';
import 'bullet.dart';
import 'explosion.dart';

class CometSmall extends SpriteComponent
    with HasGameReference<SpaceShooterGame>, CollisionCallbacks {
  final double speed;
  CometSmall({
    super.position,
    required this.speed,
  }) : super(
          size: Vector2.all(cometSize),
          anchor: Anchor.center,
        );

  static const cometSize = 50.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());

    sprite = await game.loadSprite('stone2.png');
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Bullet) {
      game.gameCubit.hitComet();
      removeFromParent();
      other.removeFromParent();
      game.add(Explosion(position: position));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y += dt * speed;

    if (position.y > game.size.y) {
      removeFromParent();
    }
  }
}

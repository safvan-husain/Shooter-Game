import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';

import '../main.dart';
import 'bullet.dart';
import 'explosion.dart';
import 'gun.dart';

enum CometType { small, medium, big }

class Comet extends SpriteComponent
    with HasGameReference<SpaceShooterGame>, CollisionCallbacks {
  final double speed;
  final CometType type;
  Comet({super.position, required this.speed, required this.type})
      : super(
          size: Vector2.all(switch (type) {
            CometType.small => cometSize,
            CometType.medium => cometSize * 1.2,
            _ => cometSize * 1.7
          }),
          anchor: Anchor.center,
        );

  static const cometSize = 50.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());

    sprite = switch(type) {
      CometType.small => await game.loadSprite('stone2.png'),
      _ => await game.loadSprite('stone3.png')
    };
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
    } else if (other is Gun) {
      removeFromParent();
      game.add(Explosion(position: position));
      game.gameCubit.damageHealth(type);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y += dt * speed;

    if (position.y > game.size.y) {
      removeFromParent();
      game.gameCubit.damageHealth(type);
      game.add(Explosion(position: position));
    }
  }
}

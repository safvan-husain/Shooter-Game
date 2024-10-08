import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../main.dart';

class Bullet extends SpriteAnimationComponent
    with HasGameRef<SpaceShooterGame> {
  final double directionAngle;
  Bullet({super.position, this.directionAngle = 0.0})
      : super(
          size: Vector2(25, 50),
          anchor: Anchor.bottomCenter,
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
    var newP = game.gameCubit.calculateNewPosition(
      position,
      angle,
      dt * game.gameCubit.bulletSpeed,
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


import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'bullet.dart';

class Player extends SpriteAnimationComponent with HasGameRef<SpaceShooterGame> {
  Player() : super(
    size: Vector2(100, 150),
    anchor: Anchor.center,
  );
  late SpawnComponent _bulletSpawner;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
      'player.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: .2,
        textureSize: Vector2(32, 48),
      ),
    );

    position = gameRef.size / 2;

    print("player init ${position.toString()}");


    // _bulletSpawner = SpawnComponent(
    //   period: .1,
    //   selfPositioning: true,
    //   factory: (index) {
    //     return Bullet(
    //       position: position +
    //           Vector2(
    //             0,
    //             -height / 5,
    //           ),
    //       angle: 10
    //
    //     );
    //
    //     // return bullet;
    //   },
    //   autoStart: false,
    // );
    //
    // game.add(_bulletSpawner);


  }

  void move(Vector2 delta) {
    position.add(delta);
  }

  void startShooting() {

    // _bulletSpawner.timer.start();
    // _bulletSpawner.

  }

  void stopShooting() {
    // _bulletSpawner.timer.stop();
  }
}
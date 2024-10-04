import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import 'components/box.dart';
import 'components/bullet.dart';
import 'components/enemy.dart';
import 'components/player.dart';

extension on Vector2 {
  Vector2 copyWith(double nx, double ny) {
    return Vector2(x + nx, y + ny);
  }
}

class SpaceShooterGame extends FlameGame {
  //with PanDetector, HasCollisionDetection {
  late Player player;

  @override
  Color backgroundColor() {
    return Colors.green;
  }
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    var box = Box()..size = Vector2(101, 101)..anchor = Anchor.bottomCenter
      ..position = size / 2;

    add(box);
    // final parallax = await loadParallaxComponent(
    //   [
    //     ParallaxImageData('stars_0.png'),
    //     ParallaxImageData('stars_1.png'),
    //     ParallaxImageData('stars_2.png'),
    //   ],
    //   baseVelocity: Vector2(0, -5),
    //   repeat: ImageRepeat.repeat,
    //   velocityMultiplierDelta: Vector2(0, 5),
    // );
    // add(parallax);
    // player = Player();
    // player.angle = 10;
    // add(player);
    //
    // Vector2 bulletPosition = size / 2; //Vector2(0, 0);
    // print("bullet pos ${bulletPosition.toString()}");
    //
    // add(Bullet(position: bulletPosition, angle: 10));

    // List<Bullet> bullets = List.generate(
    //     10,
    //     (index) => Bullet(
    //         position: bulletPosition.copyWith(index * 10, index * 10),
    //         angle: index.toDouble()));
    //
    // bullets.forEach(add);

    // add(
    //   SpawnComponent(
    //     factory: (index) {
    //       return Enemy();
    //     },
    //     period: 1,
    //     area: Rectangle.fromLTWH(0, 0, size.x, -Enemy.enemySize),
    //   ),
    // );
  }

  // @override
  // void onPanUpdate(DragUpdateInfo info) {
  //   player.move(info.delta.global);
  //   super.onPanUpdate(info);
  // }
  //
  // @override
  // void onPanStart(DragStartInfo info) {
  //   super.onPanStart(info);
  //   player.startShooting();
  // }
  //
  // @override
  // void onPanEnd(DragEndInfo info) {
  //   super.onPanEnd(info);
  //   player.stopShooting();
  // }
}

void main() {
  runApp(GameWidget(game: SpaceShooterGame()));
}

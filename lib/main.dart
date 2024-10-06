import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:shooter_game/components/gun.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'components/box.dart';
import 'components/bullet.dart';
import 'components/enemy.dart';
import 'components/player.dart';

class SpaceShooterGame extends FlameGame
    with PanDetector, HasCollisionDetection {
  late Player player;
  double _angel = 0;

  @override
  Color backgroundColor() {
    return Colors.green;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(Shooter(size: Size(100, 220), paint: Paint()..color = Color.fromARGB(255, 247, 92, 3))..angle = _angel);
    //
    // accelerometerEventStream().listen((data) {
    //   // print(" current x ${data.x}, total x is ${size.x} ");
    // });
   // Future.microtask(() async {
   //   for (int i = 0; i < 10; i++){
   //     print("angle is ${_angel}");
   //     _angel += .1;
   //     await Future.delayed(Duration(seconds: 1));
   //   }
   // });

    // player = Player();
    // player.angle = _angel;
    // add(player);
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

  @override
  void onPanStart(DragStartInfo info) {
    // bool isLeftTap = info.eventPosition.global.x < size.x / 2;
    // if(isLeftTap) {
    //   _angel -= .2;
    // } else {
    //   _angel += .2;
    // }
    // player.angle = _angel;
    // add(Bullet(position: Vector2(size.x / 2, size.y))..angle = _angel);
    // player.startShooting(_angel);
    super.onPanStart(info);
  }
}

void main() {
  runApp(GameWidget(game: SpaceShooterGame()));
}





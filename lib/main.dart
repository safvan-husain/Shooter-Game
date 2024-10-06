import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/parallax.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:shooter_game/components/gun.dart';
import 'bloc/game_bloc.dart';
import 'components/box.dart';
import 'components/bullet.dart';
import 'components/enemy.dart';
import 'components/player.dart';

class SpaceShooterGame extends FlameGame
    with PanDetector, HasCollisionDetection {
  final GameCubit gameCubit = GameCubit()..initControl();
  @override
  Color backgroundColor() {
    return Colors.green;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final parallax = await loadParallaxComponent(
      [
        ParallaxImageData('stars_0.png'),
        ParallaxImageData('stars_1.png'),
        ParallaxImageData('stars_2.png'),
      ],
      baseVelocity: Vector2(0, -5),
      repeat: ImageRepeat.repeat,
      velocityMultiplierDelta: Vector2(0, 5),
    );
    add(parallax);
    add(
      SpawnComponent(
        factory: (index) {
          return CometSmall();
        },
        period: 1,
        area: Rectangle.fromLTWH(0, 0, size.x, -CometSmall.enemySize),
      ),
    );
    await add(
      FlameBlocProvider<GameCubit, GameState>(
        create: () => gameCubit,
        children: [
          Gun(
            Vector2(100, 250),
            Paint()..color = Color.fromARGB(255, 247, 92, 3),
          )..position = Vector2(size.x / 2, size.y + 30),
        ],
      ),
    );
  }

  @override
  void onPanStart(DragStartInfo info) {
    // add(Bullet()..position = size / 2..angle = gameCubit.state.angle);

    add(
      Bullet()
        ..angle = gameCubit.state.angle
        ..position = calculateNewPosition(
          Vector2(size.x / 2, size.y + 30),
          gameCubit.state.angle,
          250,
        ),
    );
    super.onPanStart(info);
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GameWidget(game: SpaceShooterGame()));
}

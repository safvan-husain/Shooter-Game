import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/parallax.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:shooter_game/components/gun.dart';
import 'bloc/game_bloc.dart';
import 'components/bullet.dart';
import 'components/enemy.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/game_status_bar.dart';

const gameStatusBar = 'status-bar';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GameWidget(
    game: SpaceShooterGame(),
    overlayBuilderMap: {
      gameStatusBar: (BuildContext context, SpaceShooterGame game) {
        return BlocProvider(
          create: (context) => game.gameCubit,
          child: const GameStatus(),
        );
      },
    },
  ));
}

class SpaceShooterGame extends FlameGame
    with PanDetector, HasCollisionDetection {
  final GameCubit gameCubit = GameCubit()..initControl();
  late ParallaxComponent parallaxComponent;
  late SpawnComponent comets;

  @override
  Future<void> onLoad() async {
    overlays.add(gameStatusBar);
    await super.onLoad();
    //background stars
    parallaxComponent = await loadParallaxComponent(
      [
        ParallaxImageData('stars_0.png'),
        ParallaxImageData('stars_1.png'),
        ParallaxImageData('stars_2.png'),
      ],
      baseVelocity: Vector2(0, -5),
      repeat: ImageRepeat.repeat,
      velocityMultiplierDelta: Vector2(0, 5),
    );
    comets = SpawnComponent(
      factory: (index) {
        return gameCubit.getComet();
      },
      period: 1,
      area: Rectangle.fromLTWH(0, 0, size.x, -CometSmall.cometSize),
    );
    add(parallaxComponent);
    //comets (target)
    add(comets);
    //shooting gun
    await add(
      FlameBlocProvider<GameCubit, GameState>(
        create: () => gameCubit,
        children: [
          Gun(
            Vector2(100, 250),
            Paint()
              ..shader = const LinearGradient(colors: [
                Colors.grey,
                Color.fromARGB(255, 191, 209, 229),
              ]).createShader(
                Vector2(100, 250).toRect(),
              ),
          )..position = Vector2(size.x / 2, size.y + 30),
        ],
      ),
    );
  }

  @override
  void onPanStart(DragStartInfo info) {
    print("camera angele is ${camera.viewfinder.angle} and current ${CameraComponent.currentCamera?.viewfinder.angle}");
    shakeGame();

    // gameCubit.incrementCometSpeed();

    //update background star speed if not null
    // if(parallaxComponent.parallax != null) {
    //   parallaxComponent.parallax =
    //       gameCubit.getFasterParallax(parallaxComponent.parallax!);
    // }

    add(
      Bullet()
        ..angle = gameCubit.state.angle
        //calculating the top position of gun
        //for the bullet to show up
        ..position = calculateNewPosition(
          Vector2(size.x / 2, size.y + 30),
          gameCubit.state.angle,
          //gun height
          250,
        ),
    );
    super.onPanStart(info);
  }

  void shakeGame() {
    // camera = CameraComponent.withFixedResolution(
    //     height: camera.viewport.size.y,
    //     width: camera.viewport.size.x,
    //     viewfinder: Viewfinder()
    //       ..angle = camera.viewfinder.angle + .5);
    camera.moveBy(Vector2(-10, 30));
  }
}

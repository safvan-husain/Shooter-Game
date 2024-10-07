import 'dart:math';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/parallax.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:shooter_game/components/gun.dart';
import 'package:shooter_game/widgets/game_over_overlay.dart';
import 'bloc/game_bloc.dart';
import 'components/bullet.dart';
import 'components/enemy.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/damage_overlay.dart';
import 'widgets/game_status_bar.dart';

const gameStatusBar = 'status-bar';
const redOverlay = "red";
const gameOver = "game-over";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GameWidget(
    game: SpaceShooterGame(),
    overlayBuilderMap: {
      gameStatusBar: (context, SpaceShooterGame game) => BlocProvider(
            create: (c) => game.gameCubit,
            child: const GameStatus(),
          ),
      redOverlay: (context, game) => const RedOverlay(),
      gameOver: (context, SpaceShooterGame game) =>
          GameOverOverlay(cubit: game.gameCubit),
    },
  ));
}

Widget wrapWithBloc(Cubit cubit, Widget widget) {
  return BlocProvider(
    create: (c) => cubit,
    child: widget,
  );
}

class SpaceShooterGame extends FlameGame
    with PanDetector, HasCollisionDetection {
  final GameCubit gameCubit = GameCubit();
  late SpawnComponent comets;

  @override
  Future<void> onLoad() async {
    gameCubit.initControl(game: this);
    overlays.add(gameStatusBar);
    await super.onLoad();
    camera.viewfinder.anchor = Anchor.topLeft;
    //background stars
    gameCubit.parallaxComponent = await loadParallaxComponent(
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
        //get comet with speed corresponding to level
        return gameCubit.getRandomComet();
      },
      period: 1,
      area: Rectangle.fromLTWH(0, 0, size.x, -Comet.cometSize),
    );
    //adding components to world to use camera.
    world.add(gameCubit.parallaxComponent);
    //(target)
    world.add(comets);
    //shooting gun
    await world.add(
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
    gameCubit.shoot();
    super.onPanStart(info);
  }
}

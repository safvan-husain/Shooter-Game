import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shooter_game/components/enemy.dart';
import 'package:shooter_game/main.dart';

import '../components/bullet.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameState.initial());

  double get speedLevel => (state.timer.elapsed.inMinutes / 5) + 1;
  double get cometSpeed => 250 * speedLevel;
  double get bulletSpeed => 500 * speedLevel;

  late FlameGame _game;

  late ParallaxComponent parallaxComponent;

  void initControl({required FlameGame game}) async {
    _game = game;
    //handling direction of the gun.
    accelerometerEventStream().listen((data) {
      if (data.x < -4 || data.x > 4) return;

      emit(state.copyWith(angle: (data.x / -10) * 1.3));
    });
  }

  void restart() {
    emit(GameState.initial());
    _game.world
        .removeWhere((element) => element is Bullet || element is Comet);
    _game.overlays.remove(gameOver);
    _game.resumeEngine();
  }

  void onHitComet() {
    hitCometEffect();
    emit(state.copyWith(cometDestroyed: state.cometDestroyed + 1));
  }

  Comet getRandomComet() {
    return Comet(
      speed: cometSpeed,
      type: CometType.values.elementAt(
        Random().nextInt(CometType.values.length),
      ),
    )..angle = Random().nextDouble();
  }

  void damageHealth(CometType cometType) {
    damageHealthEffect();
    double damagedHealth = switch(cometType) {
      CometType.small => 1,
      CometType.medium => 1.5,
      _ => 2
    };
    emit(state.copyWith(health: state.health - damagedHealth));
    if (state.health <= 0) {
      _game.pauseEngine();
      _game.overlays.add(gameOver);
    }
  }

  void shoot() {
    _game.world.add(
      Bullet()
        ..angle = state.angle
        //calculating the top position of gun
        //for the bullet to show up
        ..position = calculateNewPosition(
          Vector2(_game.size.x / 2, _game.size.y + 30),
          state.angle,
          //gun height
          250,
        ),
    );
  }

  void hitCometEffect() async {
    for (int i = 0; i < 5; i++) {
      final dx = Random().nextDouble() * 10 - 8;
      final dy = Random().nextDouble() * 10 - 8;

      _game.camera.moveBy(Vector2(dx, dy));

      await Future.delayed(const Duration(milliseconds: 20));
    }

    // Reset camera position after shake
    _game.camera.moveTo(Vector2(0, 0));
  }

  void damageHealthEffect() async {
    _game.overlays.add(redOverlay);
    for (int i = 0; i < 10; i++) {
      final dx = Random().nextDouble() * 10 - 5;
      final dy = Random().nextDouble() * 10 - 5;

      _game.camera.moveBy(Vector2(dx, dy));
      await Future.delayed(const Duration(milliseconds: 20));
    }
    _game.overlays.remove(redOverlay);
    // Reset camera position after shake
    _game.camera.moveTo(Vector2(0, 0));
  }

  Vector2 calculateNewPosition(
      Vector2 currentPosition, double angleInDegrees, double distance) {
    var angleInRadians = angleInDegrees + (270 * (pi / 180));
    var dx = distance * cos(angleInRadians);
    var dy = distance * sin(angleInRadians);
    var newX = currentPosition.x + dx;
    var newY = currentPosition.y + dy;
    return Vector2(newX, newY);
  }
}

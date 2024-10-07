import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shooter_game/components/enemy.dart';

class GameState {
  final double angle;
  final Stopwatch timer;
  final int cometDestroyed;
  const GameState({
    required this.angle,
    required this.timer,
    this.cometDestroyed = 0,
  });

  GameState copyWith({double? angle, int? cometDestroyed}) {
    return GameState(
      angle: angle ?? this.angle,
      timer: timer,
      cometDestroyed: cometDestroyed ?? this.cometDestroyed,
    );
  }
}

class GameCubit extends Cubit<GameState> {
  GameCubit()
      : super(GameState(
          angle: 0,
          timer: Stopwatch()..start(),
        ));

  double cometSpeed = 250;

  void initControl() {
    accelerometerEventStream().listen((data) {
      if (data.x < -3 || data.x > 3) return;

      emit(state.copyWith(angle: (data.x / -10) * 1.3));
      // print
    });
  }

  void hitComet() {
    emit(state.copyWith(cometDestroyed: state.cometDestroyed + 1));
  }

  CometSmall getComet() {
    return CometSmall(speed: cometSpeed);
  }

  void incrementCometSpeed() {
    cometSpeed += 50;
  }

  Parallax getFasterParallax(Parallax p) {
    return Parallax(
      p.layers ?? [],
      size: p.size,
      baseVelocity: Vector2(
        0,
        p.baseVelocity.y * 1.2,
      ),
    );
  }
}

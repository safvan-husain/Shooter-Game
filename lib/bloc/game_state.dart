
part of 'game_bloc.dart';

class GameState {
  final double angle;
  final Stopwatch timer;
  final int cometDestroyed;
  final double health;
  const GameState(
      {required this.angle,
        required this.timer,
        this.cometDestroyed = 0,
        this.health = 100});

  GameState copyWith({double? angle, int? cometDestroyed, double? health}) {
    return GameState(
        angle: angle ?? this.angle,
        timer: timer,
        cometDestroyed: cometDestroyed ?? this.cometDestroyed,
        health: health ?? this.health);
  }

  factory GameState.initial() {
    return GameState(
      angle: 0,
      timer: Stopwatch()..start(),
    );
  }
}
import 'package:bloc/bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';

class GameState {
  final double angle;
  const GameState({required this.angle});
}

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(const GameState(angle: 0));

  void initControl() {
    accelerometerEventStream().listen((data) {
      if (data.x < -3 || data.x > 3) return;

      emit(GameState(angle: (data.x / -10) * 1.3));
      // print
    });
  }
}
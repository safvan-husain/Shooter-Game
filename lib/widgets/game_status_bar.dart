import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/game_bloc.dart';

class GameStatus extends StatelessWidget {
  const GameStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          padding: const EdgeInsets.all(10),
          height: 140,
          width: 120,
          child: BlocBuilder<GameCubit, GameState>(
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <List>[
                  [Icons.temple_buddhist_outlined, state.cometDestroyed],
                  [Icons.timer, state.timer.elapsed.toString().substring(2, 7),
                  ],
                  [Icons.health_and_safety_outlined, "${state.health.toInt()}%"]
                ]
                    .map((e) => Row(
                          children: [
                            Icon(
                              e.first,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "${e.last}",
                              style: const TextStyle(color: Colors.white),
                            )
                          ],
                        ))
                    .toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}

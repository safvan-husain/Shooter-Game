import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/game_bloc.dart';

class GameOverOverlay extends StatelessWidget {
  final GameCubit cubit;
  const GameOverOverlay({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * .7,
          height: 200,
          decoration: const BoxDecoration(
            color: Color.fromARGB(100, 255, 255, 255),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Game Over",
                style: GoogleFonts.sixtyfour(color: Colors.red, fontSize: 20),
              ),
              InkWell(
                onTap: cubit.restart,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(100, 105, 20, 60),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Restart",
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

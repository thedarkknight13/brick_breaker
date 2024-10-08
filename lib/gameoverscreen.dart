import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({
    super.key,
    required this.isGameOver,
    this.function,
  });

  // font
  static var gameFont = GoogleFonts.pressStart2p(
    textStyle: TextStyle(
      color: Colors.deepPurple[600],
      letterSpacing: 0,
      fontSize: 28,
    ),
  );

  final bool isGameOver;
  final function;

  @override
  Widget build(BuildContext context) {
    return isGameOver
        ? Stack(
            children: [
              Container(
                alignment: const Alignment(0, -0.3),
                child: Text(
                  "GAME OVER",
                  style: gameFont,
                ),
              ),
              Container(
                alignment: const Alignment(0, 0),
                child: GestureDetector(
                  onTap: function,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      color: Colors.deepPurple,
                      child: const Text(
                        "PLAY AGAIN",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        : Container();
  }
}

import 'dart:async';

import 'package:brick_breaker/ball.dart';
import 'package:brick_breaker/coverscreen.dart';
import 'package:brick_breaker/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FocusNode _focusNode = FocusNode();

  // ball variables
  double ballX = 0.0;
  double ballY = 0.0;

  // game settings
  bool hasGameStarted = false;

  // player variables
  double playerX = 0.0;
  double playerWidth = 0.3; // out of 2

  // start Game
  void startGame() {
    hasGameStarted = true;
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        ballY += 0.01;
      });
    });
  }

  // move player left
  void moveLeft() {
    // only move left if moving left doesn't move player off the screen
    setState(() {
      if (playerX - 0.2 > -1) playerX -= 0.2;
    });
  }

  // move player right
  void moveRight() {
    // only move left if moving left doesn't move player off the screen
    setState(() {
      if (playerX + 0.2 < 1) playerX += 0.2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          moveLeft();
        } else if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.arrowRight) {
          moveRight();
        }
      },
      child: GestureDetector(
        onTap: startGame,
        child: Scaffold(
          backgroundColor: Colors.deepPurple[100],
          body: Center(
            child: Stack(
              children: [
                // tap to play
                CoverScreen(
                  hasGameStarted: hasGameStarted,
                ),

                // ball
                MyBall(
                  ballX: ballX,
                  ballY: ballY,
                ),

                // player
                MyPlayer(
                  playerX: playerX,
                  playerWidth: playerWidth,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

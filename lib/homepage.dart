import 'dart:async';

import 'package:brick_breaker/ball.dart';
import 'package:brick_breaker/brick.dart';
import 'package:brick_breaker/coverscreen.dart';
import 'package:brick_breaker/gameoverscreen.dart';
import 'package:brick_breaker/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum Direction { up, down, left, right }

class _HomePageState extends State<HomePage> {
  final FocusNode _focusNode = FocusNode();

  // ball variables
  double ballX = 0.0;
  double ballY = 0.0;
  double ballXIncrements = 0.01;
  double ballYIncrements = 0.01;
  var ballYDirection = Direction.down;
  var ballXDirection = Direction.left;

  // game settings
  bool hasGameStarted = false;
  bool isGameOver = false;

  // player variables
  double playerX = -0.4;
  double playerWidth = 0.3; // out of 2

  // brick variables
  double brickX = 0;
  double brickY = -0.9;
  double brickWidth = 0.4; // out of 2
  double brickHeight = 0.05; // out of 2
  bool brickBroken = false;

  // start Game
  void startGame() {
    hasGameStarted = true;
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      // update direction
      updateDirection();

      // move ball
      moveBall();

      // check if player is dead
      if (isPlayerDead()) {
        timer.cancel();
        isGameOver = true;
      }

      // check if brick is hit
      checkForBrokenBricks();
    });
  }

  void checkForBrokenBricks() {
    // check for when ball hits bottom of thr brick
    if (ballX >= brickX &&
        ballX <= brickX + brickWidth &&
        ballY <= brickY + brickHeight &&
        brickBroken == false) {
      setState(() {
        brickBroken = true;
        ballYDirection = Direction.down;
      });
    }
  }

  // is player dead
  bool isPlayerDead() {
    //player dies if ball reaches bottom of screen
    if (ballY >= 1) return true;
    return false;
  }

  // move ball
  void moveBall() {
    setState(() {
      // move horizontally
      if (ballXDirection == Direction.left) {
        ballX -= ballXIncrements;
      } else if (ballXDirection == Direction.right) {
        ballX += ballXIncrements;
      }

      // move vertically
      if (ballYDirection == Direction.down) {
        ballY += ballYIncrements;
      } else if (ballYDirection == Direction.up) {
        ballY -= ballYIncrements;
      }
    });
  }

  // update direction of the ball
  void updateDirection() {
    setState(() {
      if (ballY >= 0.9 && ballX >= playerX && ballX <= playerX + playerWidth) {
        ballYDirection = Direction.up;
      } else if (ballY <= -1) {
        ballYDirection = Direction.down;
      }
    });
  }

  // move player left
  void moveLeft() {
    // only move left if moving left doesn't move player off the screen
    setState(() {
      if (!(playerX - 0.2 < -1)) playerX -= 0.2;
    });
  }

  // move player right
  void moveRight() {
    // only move left if moving left doesn't move player off the screen
    setState(() {
      if (!(playerX + playerWidth >= 1)) playerX += 0.2;
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

                // game over screen
                GameOverScreen(isGameOver: isGameOver),

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

                // bricks
                MyBrick(
                  brickHeight: brickHeight,
                  brickWidth: brickWidth,
                  brickX: brickX,
                  brickY: brickY,
                  brickBroken: brickBroken,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

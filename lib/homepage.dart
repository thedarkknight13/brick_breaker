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
  double ballXIncrements = 0.02;
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
  // for reference on what the variables mean, visit the tutorial
  static double firstBrickX = -1 + wallGap;
  static double firstBrickY = -0.9;
  static double brickWidth = 0.4; // out of 2
  static double brickHeight = 0.05; // out of 2
  static double brickGap = 0.01;
  static int n = 3; // n is number of bricks in each row
  static double wallGap = 0.5 * (2 - n * brickWidth - (n - 1) * brickGap);

  List myBricks = [
    // [x, y, broken = true/false]
    [firstBrickX + 0 * (brickWidth + brickGap), firstBrickY, false],
    [firstBrickX + 1 * (brickWidth + brickGap), firstBrickY, false],
    [firstBrickX + 2 * (brickWidth + brickGap), firstBrickY, false]
  ];

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
    // check for when ball is inside the brick (aka hits the brick)
    for (int i = 0; i < myBricks.length; i++) {
      if (ballX >= myBricks[i][0] &&
          ballX <= myBricks[i][0] + brickWidth &&
          ballY <= myBricks[i][1] + brickHeight &&
          myBricks[i][2] == false) {
        setState(() {
          myBricks[i][2] = true;

          // since brick is broken, update the direction of the ball
          // based on the side of the brick it hit
          // to do this, calculate the distance of the ball from each of the
          // 4 sides. The smallest distance is the side the ball hit

          double leftSideDist = (myBricks[i][0] - ballX).abs();
          double righrSideDist = (myBricks[i][0] + brickWidth - ballX).abs();
          double topSideDist = (myBricks[i][1] - ballY).abs();
          double bottomSideDist = (myBricks[i][1] + brickHeight - ballY).abs();

          String min = findMin(
            leftSideDist,
            righrSideDist,
            topSideDist,
            bottomSideDist,
          );

          switch (min) {
            case "left":
              ballXDirection = Direction.left;
              break;
            case "right":
              ballXDirection = Direction.right;
              break;
            case "top":
              ballYDirection = Direction.up;
              break;
            case "bottom":
              ballYDirection = Direction.down;
              break;
          }
        });
      }
    }
  }

  // returns the smallest side
  String findMin(double a, double b, double c, double d) {
    List<double> myList = [a, b, c, d];

    double currentMin = a;
    for (int i = 1; i < myList.length; i++) {
      if (myList[i] < currentMin) {
        currentMin = myList[i];
      }
    }

    if ((currentMin - a).abs() < 0.01) {
      return "left";
    } else if ((currentMin - b).abs() < 0.01) {
      return "right";
    } else if ((currentMin - c).abs() < 0.01) {
      return "top";
    } else if ((currentMin - d).abs() < 0.01) {
      return "bottom";
    }
    return "";
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
      // ball goes up when  it hits player
      if (ballY >= 0.9 && ballX >= playerX && ballX <= playerX + playerWidth) {
        ballYDirection = Direction.up;
      }
      // ball goes down when it hits top of the screen
      else if (ballY <= -1) {
        ballYDirection = Direction.down;
      }

      // ball goes left when it hits right wall
      if (ballX >= 1) {
        ballXDirection = Direction.left;
      }
      // ball goes right when it hits right wall
      else if (ballX <= -1) {
        ballXDirection = Direction.right;
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

  // reset game back to initial values when user hits play again
  void resetGame() {
    setState(() {
      playerX = -0.2;
      ballX = 0.0;
      ballY = 0.0;
      isGameOver = false;
      hasGameStarted = false;
      myBricks = [
        // [x, y, broken = true/false]
        [firstBrickX + 0 * (brickWidth + brickGap), firstBrickY, false],
        [firstBrickX + 1 * (brickWidth + brickGap), firstBrickY, false],
        [firstBrickX + 2 * (brickWidth + brickGap), firstBrickY, false]
      ];
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
                  isGameOver: isGameOver,
                  hasGameStarted: hasGameStarted,
                ),

                // game over screen
                GameOverScreen(
                  isGameOver: isGameOver,
                  function: resetGame,
                ),

                // ball
                MyBall(
                  ballX: ballX,
                  ballY: ballY,
                  hasGameStarted: hasGameStarted,
                  isGameOver: isGameOver,
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
                  brickX: myBricks[0][0],
                  brickY: myBricks[0][1],
                  brickBroken: myBricks[0][2],
                ),
                MyBrick(
                  brickHeight: brickHeight,
                  brickWidth: brickWidth,
                  brickX: myBricks[1][0],
                  brickY: myBricks[1][1],
                  brickBroken: myBricks[1][2],
                ),
                MyBrick(
                  brickHeight: brickHeight,
                  brickWidth: brickWidth,
                  brickX: myBricks[2][0],
                  brickY: myBricks[2][1],
                  brickBroken: myBricks[2][2],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

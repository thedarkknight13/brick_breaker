import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

class MyBall extends StatelessWidget {
  final double ballX;
  final double ballY;
  final bool isGameOver;
  final bool hasGameStarted;

  const MyBall({
    super.key,
    required this.ballX,
    required this.ballY,
    required this.isGameOver,
    required this.hasGameStarted,
  });

  @override
  Widget build(BuildContext context) {
    return hasGameStarted
        ? Container(
            alignment: Alignment(ballX, ballY),
            child: Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                color: isGameOver ? Colors.deepPurple[300] : Colors.deepPurple,
                shape: BoxShape.circle,
              ),
            ),
          )
        : Container(
            alignment: Alignment(ballX, ballY),
            child: AvatarGlow(
              glowRadiusFactor: 20,
              child: Material(
                elevation: 8.0,
                shape: const CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors.deepPurple[100],
                  radius: 7.0,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.deepPurple,
                    ),
                    width: 15,
                    height: 15,
                  ),
                ),
              ),
            ),
          );
  }
}

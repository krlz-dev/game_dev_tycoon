import 'package:flutter/material.dart';
import 'dart:math';
import '../models/progress_bar_data.dart';

/// A particle that moves toward a progress bar
class DotParticle {
  final ProgressBarData targetBar;
  final VoidCallback onReachTarget;

  late double x;
  late double y;
  late double targetX;
  late double targetY;
  late double velocityX;
  late double velocityY;

  bool hasReachedTarget = false;
  final Random _random = Random();

  DotParticle({
    required this.targetBar,
    required this.onReachTarget,
  }) {
    _initialize();
  }

  void _initialize() {
    // Start from a random position on screen edges
    final startSide = _random.nextInt(4); // 0: top, 1: right, 2: bottom, 3: left

    switch (startSide) {
      case 0: // Top
        x = _random.nextDouble() * 400;
        y = 0;
        break;
      case 1: // Right
        x = 400;
        y = _random.nextDouble() * 800;
        break;
      case 2: // Bottom
        x = _random.nextDouble() * 400;
        y = 800;
        break;
      case 3: // Left
        x = 0;
        y = _random.nextDouble() * 800;
        break;
    }

    // Target is center-right of screen (where progress bars are)
    targetX = 300 + _random.nextDouble() * 50;
    targetY = 300 + _random.nextDouble() * 200;

    // Calculate velocity based on target bar's speed
    final distance = sqrt(pow(targetX - x, 2) + pow(targetY - y, 2));
    final time = distance / targetBar.dotSpeed;

    velocityX = (targetX - x) / time;
    velocityY = (targetY - y) / time;
  }

  void update(double deltaTime) {
    if (hasReachedTarget) return;

    x += velocityX * deltaTime;
    y += velocityY * deltaTime;

    // Check if reached target
    final distanceToTarget = sqrt(pow(targetX - x, 2) + pow(targetY - y, 2));

    if (distanceToTarget < 10) {
      hasReachedTarget = true;
      onReachTarget();
    }
  }

  Widget buildWidget(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: Color(targetBar.color),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(targetBar.color).withOpacity(0.6),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }
}

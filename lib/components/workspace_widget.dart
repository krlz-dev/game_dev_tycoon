import 'package:flutter/material.dart';
import 'dart:async';

/// Widget that displays the character working at their desk
class WorkspaceWidget extends StatefulWidget {
  const WorkspaceWidget({super.key});

  @override
  State<WorkspaceWidget> createState() => _WorkspaceWidgetState();
}

class _WorkspaceWidgetState extends State<WorkspaceWidget> {
  int _characterFrame = 0;
  int _pcFrame = 0;
  Timer? _animationTimer;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    _animationTimer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      setState(() {
        // Cycle through sitting animation frames (row 2 and 3, 4 frames each)
        _characterFrame = (_characterFrame + 1) % 8;
        // Cycle through PC states
        _pcFrame = (_pcFrame + 1) % 4;
      });
    });
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Table at the bottom
        Positioned(
          bottom: 60,
          child: Image.asset(
            'assets/images/table.png',
            width: 200,
            height: 100,
            fit: BoxFit.contain,
          ),
        ),

        // PC on the table
        Positioned(
          bottom: 100,
          left: MediaQuery.of(context).size.width / 2 - 50,
          child: ClipRect(
            child: Align(
              alignment: Alignment.topLeft,
              widthFactor: 0.25, // 1/4 of the image width (4 sprites)
              child: Transform.translate(
                offset: Offset(-_pcFrame * 80.0, 0), // Shift to show different PC state
                child: Image.asset(
                  'assets/images/pc.png',
                  width: 320, // 4 sprites * 80px each
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),

        // Character sitting at desk
        Positioned(
          bottom: 80,
          right: MediaQuery.of(context).size.width / 2 - 80,
          child: _buildCharacterSprite(),
        ),
      ],
    );
  }

  Widget _buildCharacterSprite() {
    // Character sprite sheet is 4x4
    // Rows 2-3 (index 2-3) contain sitting animations
    // We have 8 frames total for sitting (4 in row 2, 4 in row 3)

    final row = (_characterFrame < 4) ? 2 : 3; // Row 2 or 3
    final col = _characterFrame % 4; // Column 0-3

    final spriteWidth = 100.0; // Approximate width of each sprite
    final spriteHeight = 120.0; // Approximate height of each sprite

    return ClipRect(
      child: Align(
        alignment: Alignment.topLeft,
        widthFactor: 0.25, // Show 1/4 of the width (one sprite)
        heightFactor: 0.25, // Show 1/4 of the height (one sprite)
        child: Transform.translate(
          offset: Offset(
            -col * spriteWidth,
            -row * spriteHeight,
          ),
          child: Image.asset(
            'assets/images/character.png',
            width: spriteWidth * 4, // 4 columns
            height: spriteHeight * 4, // 4 rows
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

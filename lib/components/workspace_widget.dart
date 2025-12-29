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
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Table at the bottom - larger and more prominent
        Positioned(
          bottom: 40,
          child: Image.asset(
            'assets/images/table.png',
            width: 280,
            height: 280,
            fit: BoxFit.contain,
          ),
        ),

        // Character sitting at desk
        Positioned(
          bottom: 70,
          right: screenWidth / 2 - 60,
          child: _buildCharacterSprite(),
        ),

        // PC on the table (in front of character)
        Positioned(
          bottom: 120, // On the table surface
          left: screenWidth / 2 - 40, // Slightly to the left of center
          child: ClipRect(
            child: Align(
              alignment: Alignment.topLeft,
              widthFactor: 0.25, // 1/4 of the image width (4 sprites)
              child: Transform.translate(
                offset: Offset(-_pcFrame * 72.0, 0), // Precise: 72px per sprite
                child: Image.asset(
                  'assets/images/pc.png',
                  width: 288, // Exact: 4 sprites * 72px each
                  height: 70,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCharacterSprite() {
    // Character sprite sheet is 4x4 (380x592 pixels total)
    // Each sprite is exactly 95x148 pixels
    // Rows 2-3 (index 2-3) contain sitting animations
    // We have 8 frames total for sitting (4 in row 2, 4 in row 3)

    final row = (_characterFrame < 4) ? 2 : 3; // Row 2 or 3
    final col = _characterFrame % 4; // Column 0-3

    // Exact dimensions from character.png (380x592)
    const spriteWidth = 95.0; // 380 / 4 = 95px
    const spriteHeight = 148.0; // 592 / 4 = 148px

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
            width: 380, // Exact total width
            height: 592, // Exact total height
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

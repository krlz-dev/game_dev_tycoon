import 'package:flutter/material.dart';
import '../models/progress_bar_data.dart';
import '../config/game_constants.dart';

/// Widget that displays a progress bar with label
class ProgressBarWidget extends StatelessWidget {
  final ProgressBarData barData;

  const ProgressBarWidget({
    super.key,
    required this.barData,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (barData.currentProgress / GameConstants.maxProgressPerBar)
        .clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          barData.name.toUpperCase(),
          style: TextStyle(
            color: Color(barData.color),
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        // Progress bar
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Color(barData.color).withValues(alpha: 0.5),
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                // Fill
                FractionallySizedBox(
                  widthFactor: percentage,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(barData.color).withValues(alpha: 0.6),
                          Color(barData.color),
                        ],
                      ),
                    ),
                  ),
                ),
                // Text overlay
                Center(
                  child: Text(
                    '${barData.currentProgress.toStringAsFixed(1)} / ${GameConstants.maxProgressPerBar.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

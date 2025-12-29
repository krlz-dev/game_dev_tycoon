import 'game_type.dart';

/// Model representing a game development project
class GameProject {
  final GameType type;
  final double designProgress;
  final double technologyProgress;
  final double bugProgress;
  final DateTime startTime;
  final DateTime endTime;
  final double moneyEarned;

  GameProject({
    required this.type,
    required this.designProgress,
    required this.technologyProgress,
    required this.bugProgress,
    required this.startTime,
    required this.endTime,
    required this.moneyEarned,
  });

  Duration get developmentDuration => endTime.difference(startTime);
}

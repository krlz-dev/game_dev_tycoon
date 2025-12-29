import '../models/game_type.dart';

/// Configuration data for each game type (ECS-like approach)
class GameTypeConfig {
  final GameType type;
  final String displayName;
  final double developmentTime; // seconds
  final double moneyEarned; // dollars
  final int colorCode;
  final String iconName;

  const GameTypeConfig({
    required this.type,
    required this.displayName,
    required this.developmentTime,
    required this.moneyEarned,
    required this.colorCode,
    required this.iconName,
  });

  double get moneyPerSecond => moneyEarned / developmentTime;
}

/// Registry of all game type configurations
class GameTypeRegistry {
  static const Map<GameType, GameTypeConfig> _configs = {
    GameType.sciFi: GameTypeConfig(
      type: GameType.sciFi,
      displayName: 'SCI-FI GAME',
      developmentTime: 10.0,
      moneyEarned: 50.0,
      colorCode: 0xFF00d4ff,
      iconName: 'rocket',
    ),
    GameType.fight: GameTypeConfig(
      type: GameType.fight,
      displayName: 'FIGHT GAME',
      developmentTime: 5.0,
      moneyEarned: 20.0,
      colorCode: 0xFFff006e,
      iconName: 'fight',
    ),
    GameType.thriller: GameTypeConfig(
      type: GameType.thriller,
      displayName: 'THRILLER GAME',
      developmentTime: 2.0,
      moneyEarned: 3.0,
      colorCode: 0xFF8b00ff,
      iconName: 'thriller',
    ),
  };

  /// Get configuration for a game type
  static GameTypeConfig getConfig(GameType type) {
    return _configs[type]!;
  }

  /// Get all game type configurations
  static List<GameTypeConfig> getAllConfigs() {
    return _configs.values.toList();
  }

  /// Check if a game type exists
  static bool hasConfig(GameType type) {
    return _configs.containsKey(type);
  }
}

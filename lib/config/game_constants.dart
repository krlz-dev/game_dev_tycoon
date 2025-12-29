/// Game constants and configuration
class GameConstants {
  // Development timer
  static const double developmentDuration = 10.0; // seconds

  // Progress bar settings
  static const double maxProgressPerBar = 10.0; // 10% max for first level

  // Dot spawn settings
  static const double minDotSpawnInterval = 0.3; // seconds
  static const double maxDotSpawnInterval = 0.8; // seconds

  // Dot speed settings (pixels per second)
  static const double designDotSpeed = 80.0;
  static const double technologyDotSpeed = 100.0;
  static const double bugDotSpeed = 60.0;

  // Progress values per dot
  static const double designProgressPerDot = 0.5;
  static const double technologyProgressPerDot = 0.6;
  static const double bugProgressPerDot = 0.8;

  // Colors
  static const int designColor = 0xFF4CAF50; // Green
  static const int technologyColor = 0xFF2196F3; // Blue
  static const int bugColor = 0xFFF44336; // Red

  // Game types
  static const String sciFiGame = 'SCI-FI GAME';
  static const String fightGame = 'FIGHT GAME';
}

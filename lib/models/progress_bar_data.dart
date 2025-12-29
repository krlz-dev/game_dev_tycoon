/// Data model for a progress bar (Design, Technology, or Bugs)
class ProgressBarData {
  final String name;
  final int color;
  final double dotSpeed;
  final double progressPerDot;
  double currentProgress;

  ProgressBarData({
    required this.name,
    required this.color,
    required this.dotSpeed,
    required this.progressPerDot,
    this.currentProgress = 0.0,
  });

  void addProgress(double amount) {
    currentProgress += amount;
  }

  void reset() {
    currentProgress = 0.0;
  }

  double get progressPercentage => currentProgress;
}

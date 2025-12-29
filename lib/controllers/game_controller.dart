import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_type.dart';
import '../models/progress_bar_data.dart';
import '../models/game_project.dart';
import '../config/game_constants.dart';
import '../config/game_type_config.dart';

/// Main game controller for state management
class GameController extends ChangeNotifier {
  // Money state
  double _totalMoney = 0.0;

  // Current game state
  GameType? _selectedGameType;
  bool _isDeveloping = false;
  bool _isComplete = false;
  double _timeRemaining = GameConstants.developmentDuration;
  DateTime? _startTime;

  // Progress bars
  late ProgressBarData designBar;
  late ProgressBarData technologyBar;
  late ProgressBarData bugBar;

  // Completed project
  GameProject? _completedProject;

  GameController() {
    _initializeProgressBars();
    _loadMoney();
  }

  void _initializeProgressBars() {
    designBar = ProgressBarData(
      name: 'Design',
      color: GameConstants.designColor,
      dotSpeed: GameConstants.designDotSpeed,
      progressPerDot: GameConstants.designProgressPerDot,
    );

    technologyBar = ProgressBarData(
      name: 'Technology',
      color: GameConstants.technologyColor,
      dotSpeed: GameConstants.technologyDotSpeed,
      progressPerDot: GameConstants.technologyProgressPerDot,
    );

    bugBar = ProgressBarData(
      name: 'Bugs',
      color: GameConstants.bugColor,
      dotSpeed: GameConstants.bugDotSpeed,
      progressPerDot: GameConstants.bugProgressPerDot,
    );
  }

  // Getters
  double get totalMoney => _totalMoney;
  GameType? get selectedGameType => _selectedGameType;
  bool get isDeveloping => _isDeveloping;
  bool get isComplete => _isComplete;
  double get timeRemaining => _timeRemaining;
  GameProject? get completedProject => _completedProject;

  // Select game type and start development
  void selectGameType(GameType type) {
    _selectedGameType = type;
    notifyListeners();
  }

  // Start development
  void startDevelopment() {
    if (_selectedGameType == null) return;

    final config = GameTypeRegistry.getConfig(_selectedGameType!);
    _isDeveloping = true;
    _isComplete = false;
    _timeRemaining = config.developmentTime;
    _startTime = DateTime.now();

    // Reset progress bars
    designBar.reset();
    technologyBar.reset();
    bugBar.reset();

    notifyListeners();
  }

  // Update timer
  void updateTimer(double deltaTime) {
    if (!_isDeveloping || _isComplete) return;

    _timeRemaining -= deltaTime;

    if (_timeRemaining <= 0) {
      _timeRemaining = 0;
      _completeDevelopment();
    }

    notifyListeners();
  }

  // Add progress to a specific bar
  void addProgressToBar(ProgressBarData bar, double amount) {
    if (!_isDeveloping || _isComplete) return;

    bar.addProgress(amount);
    notifyListeners();
  }

  // Complete development
  void _completeDevelopment() {
    _isDeveloping = false;
    _isComplete = true;

    final config = GameTypeRegistry.getConfig(_selectedGameType!);

    // Create completed project
    _completedProject = GameProject(
      type: _selectedGameType!,
      designProgress: designBar.currentProgress,
      technologyProgress: technologyBar.currentProgress,
      bugProgress: bugBar.currentProgress,
      startTime: _startTime!,
      endTime: DateTime.now(),
      moneyEarned: config.moneyEarned,
    );

    // Add money to total
    _addMoney(config.moneyEarned);

    notifyListeners();
  }

  // Money management
  Future<void> _loadMoney() async {
    final prefs = await SharedPreferences.getInstance();
    _totalMoney = prefs.getDouble('total_money') ?? 0.0;
    notifyListeners();
  }

  Future<void> _saveMoney() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('total_money', _totalMoney);
  }

  void _addMoney(double amount) {
    _totalMoney += amount;
    _saveMoney();
    notifyListeners();
  }

  // Reset game state
  void reset() {
    _selectedGameType = null;
    _isDeveloping = false;
    _isComplete = false;
    _timeRemaining = GameConstants.developmentDuration;
    _startTime = null;
    _completedProject = null;

    designBar.reset();
    technologyBar.reset();
    bugBar.reset();

    notifyListeners();
  }
}

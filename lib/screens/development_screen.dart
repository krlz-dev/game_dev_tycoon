import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:math';
import '../controllers/game_controller.dart';
import '../config/game_constants.dart';
import '../config/game_type_config.dart';
import '../components/progress_bar_widget.dart';
import '../components/dot_particle.dart';

/// Development screen where the game is being created
class DevelopmentScreen extends StatefulWidget {
  const DevelopmentScreen({super.key});

  @override
  State<DevelopmentScreen> createState() => _DevelopmentScreenState();
}

class _DevelopmentScreenState extends State<DevelopmentScreen>
    with TickerProviderStateMixin {
  Timer? _gameTimer;
  Timer? _dotSpawnTimer;
  final List<DotParticle> _particles = [];
  final Random _random = Random();
  DateTime? _lastUpdate;

  @override
  void initState() {
    super.initState();
    _startGameLoop();
    _startDotSpawner();
  }

  void _startGameLoop() {
    _lastUpdate = DateTime.now();
    _gameTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      final now = DateTime.now();
      final deltaTime = now.difference(_lastUpdate!).inMilliseconds / 1000.0;
      _lastUpdate = now;

      final controller = context.read<GameController>();
      controller.updateTimer(deltaTime);

      // Update particles
      setState(() {
        _particles.removeWhere((particle) {
          particle.update(deltaTime);
          return particle.hasReachedTarget;
        });
      });

      // Check if development is complete
      if (controller.isComplete) {
        _stopTimers();
        _showCompletionDialog();
      }
    });
  }

  void _startDotSpawner() {
    _dotSpawnTimer = Timer.periodic(
      Duration(
        milliseconds: (_random.nextDouble() *
                    (GameConstants.maxDotSpawnInterval -
                        GameConstants.minDotSpawnInterval) +
                GameConstants.minDotSpawnInterval) *
            1000 ~/
            1,
      ),
      (timer) {
        _spawnRandomDot();
        // Reschedule with random interval
        timer.cancel();
        _startDotSpawner();
      },
    );
  }

  void _spawnRandomDot() {
    final controller = context.read<GameController>();
    if (!controller.isDeveloping || controller.isComplete) return;

    // Randomly select which bar to target
    final bars = [
      controller.designBar,
      controller.technologyBar,
      controller.bugBar,
    ];
    final targetBar = bars[_random.nextInt(bars.length)];

    setState(() {
      _particles.add(
        DotParticle(
          targetBar: targetBar,
          onReachTarget: () {
            controller.addProgressToBar(targetBar, targetBar.progressPerDot);
          },
        ),
      );
    });
  }

  void _stopTimers() {
    _gameTimer?.cancel();
    _dotSpawnTimer?.cancel();
  }

  void _showCompletionDialog() {
    final controller = context.read<GameController>();
    final project = controller.completedProject;
    final config = GameTypeRegistry.getConfig(project!.type);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16213e),
        title: const Text(
          'PRODUCT MADE!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Game Type: ${config.displayName}',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.attach_money, color: Colors.greenAccent, size: 20),
                const SizedBox(width: 5),
                Text(
                  'Money Earned: \$${project.moneyEarned.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _ProgressInfo(
              label: 'Design Progress',
              value: project.designProgress,
              color: Color(GameConstants.designColor),
            ),
            const SizedBox(height: 10),
            _ProgressInfo(
              label: 'Technology Progress',
              value: project.technologyProgress,
              color: Color(GameConstants.technologyColor),
            ),
            const SizedBox(height: 10),
            _ProgressInfo(
              label: 'Bugs',
              value: project.bugProgress,
              color: Color(GameConstants.bugColor),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.reset();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              'BACK TO MENU',
              style: TextStyle(color: Color(0xFF00d4ff)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _stopTimers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f3460),
      body: SafeArea(
        child: Consumer<GameController>(
          builder: (context, controller, child) {
            final config = controller.selectedGameType != null
                ? GameTypeRegistry.getConfig(controller.selectedGameType!)
                : null;

            return Stack(
              children: [
                // Main content
                Column(
                  children: [
                    const SizedBox(height: 20),
                    // Header
                    Text(
                      'DEVELOPING: ${config?.displayName ?? ""}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Timer
                    Text(
                      'Time: ${controller.timeRemaining.toStringAsFixed(1)}s',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Progress bars at the top
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          ProgressBarWidget(
                            key: const ValueKey('design'),
                            barData: controller.designBar,
                          ),
                          const SizedBox(height: 15),
                          ProgressBarWidget(
                            key: const ValueKey('technology'),
                            barData: controller.technologyBar,
                          ),
                          const SizedBox(height: 15),
                          ProgressBarWidget(
                            key: const ValueKey('bugs'),
                            barData: controller.bugBar,
                          ),
                        ],
                      ),
                    ),
                    // Space for future characters/content
                    const Expanded(
                      child: Center(
                        child: Text(
                          '(Character area - Coming soon)',
                          style: TextStyle(
                            color: Colors.white30,
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Particles overlay
                ..._particles.map((particle) => particle.buildWidget(context)),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ProgressInfo extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _ProgressInfo({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '${value.toStringAsFixed(1)}%',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

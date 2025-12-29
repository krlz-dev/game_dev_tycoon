import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import '../config/game_type_config.dart';
import 'development_screen.dart';

/// Main menu screen for selecting game type
class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  IconData _getIconForType(String iconName) {
    switch (iconName) {
      case 'rocket':
        return Icons.rocket_launch;
      case 'fight':
        return Icons.sports_mma;
      case 'thriller':
        return Icons.psychology;
      default:
        return Icons.gamepad;
    }
  }

  @override
  Widget build(BuildContext context) {
    final configs = GameTypeRegistry.getAllConfigs();

    return Scaffold(
      backgroundColor: const Color(0xFF1a1a2e),
      body: SafeArea(
        child: Consumer<GameController>(
          builder: (context, controller, child) {
            return Column(
              children: [
                // Money display at the top
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF16213e),
                        const Color(0xFF1a1a2e),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.account_balance_wallet,
                        color: Colors.greenAccent,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '\$${controller.totalMoney.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                // Main content
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            'GAME DEV TYCOON',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Choose a game type to develop',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 40),
                          // Generate buttons from configs
                          ...configs.map((config) => Padding(
                                padding: const EdgeInsets.only(bottom: 25),
                                child: _GameTypeButton(
                                  config: config,
                                  icon: _getIconForType(config.iconName),
                                ),
                              )),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _GameTypeButton extends StatelessWidget {
  final GameTypeConfig config;
  final IconData icon;

  const _GameTypeButton({
    required this.config,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final controller = context.read<GameController>();
        controller.selectGameType(config.type);
        controller.startDevelopment();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DevelopmentScreen(),
          ),
        );
      },
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(config.colorCode).withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Color(config.colorCode),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            // Title row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Color(config.colorCode),
                  size: 28,
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    config.displayName,
                    style: TextStyle(
                      color: Color(config.colorCode),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Info row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _InfoChip(
                  icon: Icons.access_time,
                  label: '${config.developmentTime.toStringAsFixed(0)}s',
                  color: Color(config.colorCode),
                ),
                _InfoChip(
                  icon: Icons.attach_money,
                  label: '\$${config.moneyEarned.toStringAsFixed(0)}',
                  color: Color(config.colorCode),
                ),
                _InfoChip(
                  icon: Icons.trending_up,
                  label: '\$${config.moneyPerSecond.toStringAsFixed(1)}/s',
                  color: Color(config.colorCode),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

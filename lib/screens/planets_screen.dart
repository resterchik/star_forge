import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../painters/planet_painter.dart';
import '../utils/constants.dart';

class PlanetsScreen extends StatelessWidget {
  final GameState gameState;

  const PlanetsScreen({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            const Text('🪐 ', style: TextStyle(fontSize: 20)),
            const Text(
              'Планеты',
              style: TextStyle(color: Colors.white),
            ),
            const Spacer(),
            const Text('✨ ', style: TextStyle(fontSize: 16)),
            Text(
              gameState.formatNumber(gameState.stardust),
              style: const TextStyle(
                color: AppColors.gold,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      body: ListenableBuilder(
        listenable: gameState,
        builder: (context, _) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: gameState.celestialBodies.length,
            itemBuilder: (context, index) {
              final body = gameState.celestialBodies[index];
              final isSelected = index == gameState.currentBodyIndex;
              final canAfford = gameState.stardust >= body.unlockCost;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.gold
                        : body.unlocked
                            ? AppColors.accent.withValues(alpha: 0.3)
                            : Colors.transparent,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.gold.withValues(alpha: 0.3),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      if (body.unlocked) {
                        gameState.selectBody(index);
                      } else if (canAfford) {
                        _showUnlockDialog(context, index, body);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Mini planet preview
                          SizedBox(
                            width: 70,
                            height: 70,
                            child: CustomPaint(
                              painter: PlanetPainter(
                                colors: body.unlocked
                                    ? body.colors
                                    : [Colors.grey.shade800, Colors.grey.shade600, Colors.grey.shade900],
                                animation: 0,
                                pulseAnimation: 0.5,
                                size: 50,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  body.unlocked ? body.name : '???',
                                  style: TextStyle(
                                    color: body.unlocked
                                        ? AppColors.textPrimary
                                        : AppColors.textSecondary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  body.unlocked
                                      ? body.description
                                      : AppStrings.locked,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                                if (body.unlocked) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Множитель: ×${body.tapMultiplier.toStringAsFixed(1)}',
                                    style: const TextStyle(
                                      color: AppColors.gold,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          // Action
                          if (body.unlocked)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.gold
                                    : AppColors.accent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                isSelected
                                    ? AppStrings.selected
                                    : AppStrings.select,
                                style: TextStyle(
                                  color: isSelected
                                      ? AppColors.background
                                      : Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: canAfford
                                    ? AppColors.success
                                    : AppColors.surfaceLight,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  const Text('🔒', style: TextStyle(fontSize: 16)),
                                  Text(
                                    gameState.formatNumber(body.unlockCost),
                                    style: TextStyle(
                                      color: canAfford
                                          ? Colors.white
                                          : AppColors.textSecondary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showUnlockDialog(BuildContext context, int index, CelestialBody body) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Открыть ${body.name}?',
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: CustomPaint(
                painter: PlanetPainter(
                  colors: body.colors,
                  animation: 0,
                  pulseAnimation: 0.5,
                  size: 70,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              body.description,
              style: const TextStyle(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Множитель: ×${body.tapMultiplier.toStringAsFixed(1)}',
              style: const TextStyle(
                color: AppColors.gold,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Стоимость: ${gameState.formatNumber(body.unlockCost)} ✨',
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Отмена',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              gameState.unlockBody(index);
              Navigator.pop(ctx);
            },
            child: const Text(
              AppStrings.unlock,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

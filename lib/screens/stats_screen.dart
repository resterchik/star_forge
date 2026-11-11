import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../utils/constants.dart';

class StatsScreen extends StatelessWidget {
  final GameState gameState;

  const StatsScreen({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: Colors.white,
        title: const Row(
          children: [
            Text('📊 ', style: TextStyle(fontSize: 20)),
            Text('Статистика', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      body: ListenableBuilder(
        listenable: gameState,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildStatCard(
                  '✨',
                  'Текущая пыль',
                  gameState.formatNumber(gameState.stardust),
                ),
                _buildStatCard(
                  '🏆',
                  'Всего заработано',
                  gameState.formatNumber(gameState.totalStardust),
                ),
                _buildStatCard(
                  '👆',
                  'Всего тапов',
                  gameState.formatNumber(gameState.totalTaps.toDouble()),
                ),
                _buildStatCard(
                  '💪',
                  'Сила тапа',
                  '${gameState.formatNumber(gameState.tapPower)} × ${gameState.currentBody.tapMultiplier.toStringAsFixed(1)}',
                ),
                _buildStatCard(
                  '🤖',
                  'Автодобыча',
                  '${gameState.formatNumber(gameState.autoPerSecond)} /сек',
                ),
                _buildStatCard(
                  '🪐',
                  'Текущее тело',
                  gameState.currentBody.name,
                ),
                _buildStatCard(
                  '🔓',
                  'Открыто планет',
                  '${gameState.celestialBodies.where((b) => b.unlocked).length} / ${gameState.celestialBodies.length}',
                ),
                const SizedBox(height: 24),
                // Upgrade summary
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '📈 Улучшения',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...gameState.tapUpgrades.map((u) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Text(u.emoji,
                                    style: const TextStyle(fontSize: 20)),
                                const SizedBox(width: 8),
                                Text(
                                  u.name,
                                  style: const TextStyle(
                                      color: AppColors.textPrimary),
                                ),
                                const Spacer(),
                                Text(
                                  '${AppStrings.level} ${u.level}',
                                  style: const TextStyle(
                                      color: AppColors.accentLight),
                                ),
                              ],
                            ),
                          )),
                      const Divider(color: AppColors.surfaceLight),
                      ...gameState.autoUpgrades.map((u) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Text(u.emoji,
                                    style: const TextStyle(fontSize: 20)),
                                const SizedBox(width: 8),
                                Text(
                                  u.name,
                                  style: const TextStyle(
                                      color: AppColors.textPrimary),
                                ),
                                const Spacer(),
                                Text(
                                  '${AppStrings.level} ${u.level}',
                                  style: const TextStyle(
                                      color: AppColors.accentLight),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String emoji, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

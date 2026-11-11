import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../utils/constants.dart';

class ShopScreen extends StatelessWidget {
  final GameState gameState;

  const ShopScreen({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          foregroundColor: Colors.white,
          title: Row(
            children: [
              const Text('✨ ', style: TextStyle(fontSize: 20)),
              Text(
                gameState.formatNumber(gameState.stardust),
                style: const TextStyle(
                  color: AppColors.gold,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          bottom: const TabBar(
            indicatorColor: AppColors.accent,
            labelColor: Colors.white,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: [
              Tab(text: '👆 Тап'),
              Tab(text: '🤖 Авто'),
            ],
          ),
        ),
        body: ListenableBuilder(
          listenable: gameState,
          builder: (context, _) {
            return TabBarView(
              children: [
                _buildUpgradeList(gameState.tapUpgrades, true),
                _buildUpgradeList(gameState.autoUpgrades, false),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildUpgradeList(List<Upgrade> upgrades, bool isTap) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: upgrades.length,
      itemBuilder: (context, index) {
        final upgrade = upgrades[index];
        final canAfford = gameState.stardust >= upgrade.currentCost;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: canAfford
                  ? AppColors.accent.withValues(alpha: 0.5)
                  : Colors.transparent,
              width: 1,
            ),
            boxShadow: canAfford
                ? [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.2),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: canAfford
                  ? () {
                      if (isTap) {
                        gameState.buyTapUpgrade(index);
                      } else {
                        gameState.buyAutoUpgrade(index);
                      }
                    }
                  : null,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Emoji icon
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          upgrade.emoji,
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                upgrade.name,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (upgrade.level > 0) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.accent.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${AppStrings.level} ${upgrade.level}',
                                    style: const TextStyle(
                                      color: AppColors.accentLight,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            upgrade.description,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                          if (upgrade.level > 0)
                            Text(
                              'Итого: +${gameState.formatNumber(upgrade.totalValue)} ${isTap ? "за тап" : "/сек"}',
                              style: const TextStyle(
                                color: AppColors.success,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Cost
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: canAfford
                            ? AppColors.accent
                            : AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            gameState.formatNumber(upgrade.currentCost),
                            style: TextStyle(
                              color: canAfford
                                  ? Colors.white
                                  : AppColors.textSecondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '✨',
                            style: TextStyle(
                              fontSize: 12,
                              color: canAfford
                                  ? Colors.white
                                  : AppColors.textSecondary,
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
  }
}

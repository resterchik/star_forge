import 'dart:async';
import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../utils/constants.dart';
import '../widgets/star_field_widget.dart';
import '../widgets/planet_widget.dart';
import 'shop_screen.dart';
import 'planets_screen.dart';
import 'stats_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late GameState _gameState;
  Timer? _autoTimer;
  Timer? _saveTimer;

  // Floating texts
  final List<_FloatingTextData> _floatingTexts = [];
  int _floatingTextId = 0;

  @override
  void initState() {
    super.initState();
    _gameState = GameState();

    // Auto earnings timer (60fps)
    _autoTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      _gameState.addAutoStardust(0.05);
    });

    // Periodic save
    _saveTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _gameState.periodicSave();
    });
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _saveTimer?.cancel();
    _gameState.periodicSave();
    super.dispose();
  }

  void _onTap() {
    _gameState.tap();
    final earned = _gameState.tapPower * _gameState.currentBody.tapMultiplier;
    setState(() {
      _floatingTexts.add(_FloatingTextData(
        id: _floatingTextId++,
        text: '+${_gameState.formatNumber(earned)}',
      ));
    });
    // Remove after animation
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _floatingTexts.removeWhere((t) => t.id == _floatingTextId - 1);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ListenableBuilder(
        listenable: _gameState,
        builder: (context, _) {
          return Stack(
            children: [
              // Star field background
              const Positioned.fill(
                child: StarFieldWidget(),
              ),

              // Main content
              SafeArea(
                child: Column(
                  children: [
                    // Top bar
                    _buildTopBar(),

                    const SizedBox(height: 8),

                    // Planet name
                    Text(
                      _gameState.currentBody.name,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      '×${_gameState.currentBody.tapMultiplier.toStringAsFixed(1)}',
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Planet + particles
                    Expanded(
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: PlanetWidget(
                            gameState: _gameState,
                            onTap: _onTap,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Tap hint
                    const Text(
                      'ТАПНИ!',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        letterSpacing: 4,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Bottom stats
                    _buildBottomStats(),

                    const SizedBox(height: 8),

                    // Bottom navigation
                    _buildBottomNav(),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('✨', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ЗВЁЗДНАЯ ПЫЛЬ',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                  letterSpacing: 2,
                ),
              ),
              Text(
                _gameState.formatNumber(_gameState.stardust),
                style: const TextStyle(
                  color: AppColors.gold,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomStats() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            '👆',
            '${_gameState.formatNumber(_gameState.tapPower * _gameState.currentBody.tapMultiplier)}/тап',
          ),
          Container(
            width: 1,
            height: 30,
            color: AppColors.surfaceLight,
          ),
          _buildStatItem(
            '🤖',
            '${_gameState.formatNumber(_gameState.autoPerSecond * _gameState.currentBody.tapMultiplier)}/сек',
          ),
          Container(
            width: 1,
            height: 30,
            color: AppColors.surfaceLight,
          ),
          _buildStatItem(
            '👆',
            '${_gameState.formatNumber(_gameState.totalTaps.toDouble())} тапов',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String emoji, String value) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildNavButton(
              '🛒',
              AppStrings.shop,
              AppColors.accent,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ShopScreen(gameState: _gameState),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildNavButton(
              '🪐',
              AppStrings.planets,
              AppColors.accent,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlanetsScreen(gameState: _gameState),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildNavButton(
              '📊',
              AppStrings.stats,
              AppColors.accent,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StatsScreen(gameState: _gameState),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(
    String emoji,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withValues(alpha: 0.4),
            ),
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FloatingTextData {
  final int id;
  final String text;

  _FloatingTextData({required this.id, required this.text});
}

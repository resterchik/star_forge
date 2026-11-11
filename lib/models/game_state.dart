import 'dart:convert';
import 'dart:ui' show Color;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Upgrade {
  final String id;
  final String name;
  final String description;
  final String emoji;
  int level;
  double baseCost;
  double costMultiplier;
  double value;

  Upgrade({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    this.level = 0,
    required this.baseCost,
    this.costMultiplier = 1.15,
    required this.value,
  });

  double get currentCost => baseCost * pow(costMultiplier, level);
  double get totalValue => value * level;

  Map<String, dynamic> toJson() => {
        'id': id,
        'level': level,
      };

  static double pow(double base, int exponent) {
    double result = 1.0;
    for (int i = 0; i < exponent; i++) {
      result *= base;
    }
    return result;
  }
}

class CelestialBody {
  final String id;
  final String name;
  final String description;
  final double unlockCost;
  final double tapMultiplier;
  final List<Color> colors;
  final double size;
  bool unlocked;

  CelestialBody({
    required this.id,
    required this.name,
    required this.description,
    required this.unlockCost,
    required this.tapMultiplier,
    required this.colors,
    this.size = 120,
    this.unlocked = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'unlocked': unlocked,
      };
}

class GameState extends ChangeNotifier {
  double _stardust = 0;
  double _totalStardust = 0;
  double _tapPower = 1;
  double _autoPerSecond = 0;
  int _totalTaps = 0;
  int _currentBodyIndex = 0;

  // Upgrades
  late List<Upgrade> tapUpgrades;
  late List<Upgrade> autoUpgrades;

  // Celestial bodies
  late List<CelestialBody> celestialBodies;

  GameState() {
    _initUpgrades();
    _initCelestialBodies();
    _loadState();
  }

  // Getters
  double get stardust => _stardust;
  double get totalStardust => _totalStardust;
  double get tapPower => _tapPower;
  double get autoPerSecond => _autoPerSecond;
  int get totalTaps => _totalTaps;
  CelestialBody get currentBody => celestialBodies[_currentBodyIndex];
  int get currentBodyIndex => _currentBodyIndex;

  void _initUpgrades() {
    tapUpgrades = [
      Upgrade(
        id: 'tap_power',
        name: 'Сила Тапа',
        description: '+1 звёздная пыль за тап',
        emoji: '👆',
        baseCost: 10,
        value: 1,
      ),
      Upgrade(
        id: 'tap_multi',
        name: 'Мульти-Тап',
        description: '+5 звёздной пыли за тап',
        emoji: '✨',
        baseCost: 100,
        value: 5,
      ),
      Upgrade(
        id: 'tap_mega',
        name: 'Мега-Тап',
        description: '+25 звёздной пыли за тап',
        emoji: '💫',
        baseCost: 1000,
        value: 25,
      ),
      Upgrade(
        id: 'tap_ultra',
        name: 'Ультра-Тап',
        description: '+100 звёздной пыли за тап',
        emoji: '🌟',
        baseCost: 10000,
        value: 100,
      ),
    ];

    autoUpgrades = [
      Upgrade(
        id: 'auto_drone',
        name: 'Дрон-Сборщик',
        description: '+1 пыль/сек',
        emoji: '🛸',
        baseCost: 50,
        value: 1,
      ),
      Upgrade(
        id: 'auto_station',
        name: 'Станция Добычи',
        description: '+5 пыли/сек',
        emoji: '🏗️',
        baseCost: 500,
        value: 5,
      ),
      Upgrade(
        id: 'auto_factory',
        name: 'Звёздная Фабрика',
        description: '+20 пыли/сек',
        emoji: '🏭',
        baseCost: 5000,
        value: 20,
      ),
      Upgrade(
        id: 'auto_nebula',
        name: 'Генератор Туманности',
        description: '+100 пыли/сек',
        emoji: '🌌',
        baseCost: 50000,
        value: 100,
      ),
    ];
  }

  void _initCelestialBodies() {
    celestialBodies = [
      CelestialBody(
        id: 'asteroid',
        name: 'Астероид',
        description: 'Маленький, но уютный камешек',
        unlockCost: 0,
        tapMultiplier: 1.0,
        colors: [const Color(0xFF616161), const Color(0xFF9E9E9E), const Color(0xFF424242)],
        size: 80,
        unlocked: true,
      ),
      CelestialBody(
        id: 'moon',
        name: 'Луна',
        description: 'Серебристый спутник',
        unlockCost: 500,
        tapMultiplier: 1.5,
        colors: [const Color(0xFFBDBDBD), const Color(0xFFE0E0E0), const Color(0xFF9E9E9E)],
        size: 100,
      ),
      CelestialBody(
        id: 'mars',
        name: 'Марс',
        description: 'Красная планета',
        unlockCost: 5000,
        tapMultiplier: 2.0,
        colors: [const Color(0xFFD84315), const Color(0xFFFF5722), const Color(0xFFBF360C)],
        size: 110,
      ),
      CelestialBody(
        id: 'earth',
        name: 'Земля',
        description: 'Голубая жемчужина',
        unlockCost: 25000,
        tapMultiplier: 3.0,
        colors: [const Color(0xFF1565C0), const Color(0xFF4CAF50), const Color(0xFF0D47A1)],
        size: 120,
      ),
      CelestialBody(
        id: 'jupiter',
        name: 'Юпитер',
        description: 'Гигант газовых бурь',
        unlockCost: 100000,
        tapMultiplier: 5.0,
        colors: [const Color(0xFFE65100), const Color(0xFFFF9800), const Color(0xFFF57C00)],
        size: 150,
      ),
      CelestialBody(
        id: 'sun',
        name: 'Звезда',
        description: 'Сияющий источник энергии',
        unlockCost: 500000,
        tapMultiplier: 10.0,
        colors: [const Color(0xFFFFD600), const Color(0xFFFF6F00), const Color(0xFFFFAB00)],
        size: 160,
      ),
      CelestialBody(
        id: 'neutron',
        name: 'Нейтронная Звезда',
        description: 'Сверхплотная материя',
        unlockCost: 5000000,
        tapMultiplier: 25.0,
        colors: [const Color(0xFF7C4DFF), const Color(0xFF651FFF), const Color(0xFFB388FF)],
        size: 90,
      ),
      CelestialBody(
        id: 'blackhole',
        name: 'Чёрная Дыра',
        description: 'Бесконечная мощь',
        unlockCost: 50000000,
        tapMultiplier: 100.0,
        colors: [const Color(0xFF1A237E), const Color(0xFF000000), const Color(0xFF311B92)],
        size: 140,
      ),
    ];
  }

  void tap() {
    double earned = _tapPower * currentBody.tapMultiplier;
    _stardust += earned;
    _totalStardust += earned;
    _totalTaps++;
    notifyListeners();
  }

  void addAutoStardust(double dt) {
    if (_autoPerSecond > 0) {
      double earned = _autoPerSecond * dt * currentBody.tapMultiplier;
      _stardust += earned;
      _totalStardust += earned;
      notifyListeners();
    }
  }

  bool buyTapUpgrade(int index) {
    if (index >= tapUpgrades.length) return false;
    final upgrade = tapUpgrades[index];
    if (_stardust >= upgrade.currentCost) {
      _stardust -= upgrade.currentCost;
      upgrade.level++;
      _recalcTapPower();
      notifyListeners();
      _saveState();
      return true;
    }
    return false;
  }

  bool buyAutoUpgrade(int index) {
    if (index >= autoUpgrades.length) return false;
    final upgrade = autoUpgrades[index];
    if (_stardust >= upgrade.currentCost) {
      _stardust -= upgrade.currentCost;
      upgrade.level++;
      _recalcAutoPerSecond();
      notifyListeners();
      _saveState();
      return true;
    }
    return false;
  }

  bool unlockBody(int index) {
    if (index >= celestialBodies.length) return false;
    final body = celestialBodies[index];
    if (body.unlocked) return false;
    if (_stardust >= body.unlockCost) {
      _stardust -= body.unlockCost;
      body.unlocked = true;
      notifyListeners();
      _saveState();
      return true;
    }
    return false;
  }

  void selectBody(int index) {
    if (index < celestialBodies.length && celestialBodies[index].unlocked) {
      _currentBodyIndex = index;
      notifyListeners();
      _saveState();
    }
  }

  void _recalcTapPower() {
    _tapPower = 1;
    for (final u in tapUpgrades) {
      _tapPower += u.totalValue;
    }
  }

  void _recalcAutoPerSecond() {
    _autoPerSecond = 0;
    for (final u in autoUpgrades) {
      _autoPerSecond += u.totalValue;
    }
  }

  String formatNumber(double n) {
    if (n < 1000) return n.toStringAsFixed(0);
    if (n < 1e6) return '${(n / 1e3).toStringAsFixed(1)}K';
    if (n < 1e9) return '${(n / 1e6).toStringAsFixed(1)}M';
    if (n < 1e12) return '${(n / 1e9).toStringAsFixed(1)}B';
    return '${(n / 1e12).toStringAsFixed(1)}T';
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('stardust', _stardust);
    await prefs.setDouble('totalStardust', _totalStardust);
    await prefs.setInt('totalTaps', _totalTaps);
    await prefs.setInt('currentBodyIndex', _currentBodyIndex);

    final tapLevels = tapUpgrades.map((u) => u.level).toList();
    await prefs.setString('tapLevels', jsonEncode(tapLevels));

    final autoLevels = autoUpgrades.map((u) => u.level).toList();
    await prefs.setString('autoLevels', jsonEncode(autoLevels));

    final unlockedBodies = celestialBodies.map((b) => b.unlocked).toList();
    await prefs.setString('unlockedBodies', jsonEncode(unlockedBodies));

    await prefs.setString('lastSave', DateTime.now().toIso8601String());
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    _stardust = prefs.getDouble('stardust') ?? 0;
    _totalStardust = prefs.getDouble('totalStardust') ?? 0;
    _totalTaps = prefs.getInt('totalTaps') ?? 0;
    _currentBodyIndex = prefs.getInt('currentBodyIndex') ?? 0;

    final tapLevelsStr = prefs.getString('tapLevels');
    if (tapLevelsStr != null) {
      final tapLevels = List<int>.from(jsonDecode(tapLevelsStr));
      for (int i = 0; i < tapLevels.length && i < tapUpgrades.length; i++) {
        tapUpgrades[i].level = tapLevels[i];
      }
    }

    final autoLevelsStr = prefs.getString('autoLevels');
    if (autoLevelsStr != null) {
      final autoLevels = List<int>.from(jsonDecode(autoLevelsStr));
      for (int i = 0; i < autoLevels.length && i < autoUpgrades.length; i++) {
        autoUpgrades[i].level = autoLevels[i];
      }
    }

    final unlockedStr = prefs.getString('unlockedBodies');
    if (unlockedStr != null) {
      final unlocked = List<bool>.from(jsonDecode(unlockedStr));
      for (int i = 0; i < unlocked.length && i < celestialBodies.length; i++) {
        celestialBodies[i].unlocked = unlocked[i];
      }
    }

    // Calculate offline earnings
    final lastSaveStr = prefs.getString('lastSave');
    if (lastSaveStr != null) {
      final lastSave = DateTime.parse(lastSaveStr);
      final elapsed = DateTime.now().difference(lastSave).inSeconds;
      if (elapsed > 0 && _autoPerSecond > 0) {
        // Cap offline earnings at 8 hours
        final cappedElapsed = elapsed.clamp(0, 28800);
        final offlineEarnings = _autoPerSecond * cappedElapsed * currentBody.tapMultiplier;
        _stardust += offlineEarnings;
        _totalStardust += offlineEarnings;
      }
    }

    _recalcTapPower();
    _recalcAutoPerSecond();
    notifyListeners();
  }

  void periodicSave() {
    _saveState();
  }
}

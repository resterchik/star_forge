import 'dart:math';

class Helpers {
  static final Random random = Random();

  static double randomBetween(double min, double max) {
    return min + random.nextDouble() * (max - min);
  }

  static int randomIntBetween(int min, int max) {
    return min + random.nextInt(max - min);
  }
}

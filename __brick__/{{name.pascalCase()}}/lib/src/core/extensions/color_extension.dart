import 'package:flutter/material.dart';
import 'dart:math' as math;

extension ColorExtension on Color {
  Color get contrastColor {
    // Calculate the perceptive luminance (aka luma) - human eye favors green color...
    double luma = ((0.299 * red) + (0.587 * green) + (0.114 * blue)) / 255;

    // Return black for bright colors, white for dark colors
    return luma > 0.5 ? Colors.black : Colors.white;
  }

  double getColorBrightness() {
    return (red * 299 + green * 587 + blue * 114) / 1000;
  }

  bool isColorDark() {
    return getColorBrightness() < 128.0;
  }

  Color brighten([int amount = 10]) {
    return Color.fromARGB(
      alpha,
      math.max(0, math.min(255, red - (255 * -(amount / 100)).round())),
      math.max(0, math.min(255, green - (255 * -(amount / 100)).round())),
      math.max(0, math.min(255, blue - (255 * -(amount / 100)).round())),
    );
  }
}

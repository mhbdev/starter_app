import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MyPainter extends CustomPainter {
  final Function(Canvas canvas, Size size) painter;
  final bool repaint;

  MyPainter({required this.painter, this.repaint = false});

  @override
  void paint(Canvas canvas, Size size) {
    painter(canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => repaint;
}

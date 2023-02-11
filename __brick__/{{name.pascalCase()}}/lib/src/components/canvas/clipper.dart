import 'package:flutter/rendering.dart';

class CustomPathClipper extends CustomClipper<Path> {
  Path Function(Size size) onClip;

  CustomPathClipper({required this.onClip});

  @override
  Path getClip(Size size) {
    return onClip(size);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

import 'package:flutter/material.dart';

extension Metrics on GlobalKey {
  Size getSize() {
    if (currentContext != null) {
      final RenderBox renderBox =
      currentContext!.findRenderObject() as RenderBox;
      final size = renderBox.size;
      return size;
    } else {
      return const Size(0, 0);
    }
  }

  Offset getPosition({bool localToGlobal = true}) {
    if (currentContext != null) {
      final RenderBox renderBox =
      currentContext!.findRenderObject() as RenderBox;
      return localToGlobal
          ? renderBox.localToGlobal(Offset.zero)
          : renderBox.globalToLocal(Offset.zero);
    }
    return Offset.zero;
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension WidgetExtension on Widget {
  Widget visible(bool visibility) {
    return visibility
        ? Visibility(
            visible: visibility,
            child: this,
          )
        : const SizedBox.shrink();
  }
}

extension MouseCursorExtenstion on Widget {
  Widget cursor(
          {SystemMouseCursor type = SystemMouseCursors.none,
          Function(PointerEnterEvent e)? onEnter,
          Function(PointerHoverEvent e)? onHover,
          Function(PointerExitEvent e)? onExit}) =>
      MouseRegion(
          cursor: type,
          onHover: onHover,
          onExit: onExit,
          onEnter: onEnter,
          child: this);

  Widget clickCursor(
          {Function(PointerEnterEvent e)? onEnter,
          Function(PointerHoverEvent e)? onHover,
          Function(PointerExitEvent e)? onExit}) =>
      cursor(
          type: SystemMouseCursors.click,
          onEnter: onEnter,
          onHover: onHover,
          onExit: onExit);
}

extension PositionedExtension on Widget {
  Widget get bottomRight => Positioned(bottom: 0, right: 0, child: this);

  Widget get topRight => Positioned(bottom: 0, right: 0, child: this);

  Widget get bottomLeft => Positioned(bottom: 0, left: 0, child: this);

  Widget get topLeft => Positioned(top: 0, left: 0, child: this);
}

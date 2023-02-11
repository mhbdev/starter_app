import 'package:flutter/material.dart';

class UpOnScrollWidget extends StatefulWidget {
  final Widget child;
  final ScrollController controller;

  final bool dark;
  final bool animate;
  final double triggerOffset;
  final IconData icon;

  final bool disallowGlow;

  const UpOnScrollWidget({Key? key,
    required this.child,
    required this.controller,
    this.triggerOffset = 32,
    this.animate = false,
    this.dark = false,
    this.icon = Icons.arrow_upward_outlined,
    this.disallowGlow = true,
  }) : super(key: key);

  @override
  _UpOnScrollWidgetState createState() => _UpOnScrollWidgetState();
}

class _UpOnScrollWidgetState extends State<UpOnScrollWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if(mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overScroll) {
        if (widget.disallowGlow) overScroll.disallowIndicator();
        return true;
      },
      child: Stack(children: [
        Positioned.fill(child: widget.child),
        if (widget.controller.hasClients &&
            widget.controller.offset >= widget.triggerOffset)
          PositionedDirectional(
              bottom: 16,
              start: 16,
              child: FloatingActionButton(
                heroTag: 'up-scroll',
                mini: true,
                onPressed: () {
                  if (widget.animate) {
                    widget.controller.animateTo(0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut);
                  } else {
                    widget.controller.jumpTo(0);
                  }
                },
                backgroundColor: widget.dark ? Colors.black : Colors.white,
                child: Icon(Icons.arrow_upward_outlined,
                    color: !widget.dark ? Colors.black : Colors.white),
              ))
      ]),
    );
  }
}

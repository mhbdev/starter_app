import 'package:apex_api/apex_api.dart';
import 'package:flutter/material.dart';

class LoadingButton extends StatefulWidget {
  final String text;
  final String loadingText;
  final VoidCallback? onPressed;
  final bool isLoading;

  const LoadingButton({
    Key? key,
    required this.text,
    this.loadingText = 'Loading',
    this.onPressed,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> with TickerProviderStateMixin, MountedStateMixin {

  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _controller.addStatusListener(_statusListener);
    _animation = IntTween(begin: 0, end: 3).animate(_controller)..addListener(mountedSetState);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_statusListener);
    _animation.removeListener(mountedSetState);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant LoadingButton oldWidget) {
    if(widget.isLoading == true) {
      _controller.forward(from: 1);
    } else {
      _controller.stop();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final child = widget.isLoading
        ? Row(
            children:  [
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.loadingText + List.generate(_animation.value, (index) => '.').join() + List.generate(4 - _animation.value, (index) => ' ').join(),
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white
                ),
              )
            ],
          )
        : Text(
            widget.text,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white
            ),
          );

    return ElevatedButton(onPressed: widget.isLoading ? null : widget.onPressed, child: child);
  }

  void _statusListener(AnimationStatus status) {
    if(status == AnimationStatus.completed) {
      _controller.reset();
    } else if (status == AnimationStatus.dismissed) {
      _controller.forward();
    }
  }
}

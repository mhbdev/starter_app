import 'dart:async';

import 'package:apex_api/apex_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpField extends StatefulWidget {
  final TextEditingController controller;
  final bool readOnly;
  final String hintText;
  final Duration resendDuration;
  final Future<bool> Function()? onResend;
  final String resendText;
  final ValueChanged<String>? onSubmitted;

  const OtpField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.onResend,
    this.readOnly = false,
    this.resendDuration = const Duration(minutes: 2),
    required this.resendText, this.onSubmitted,
  }) : super(key: key);

  @override
  State<OtpField> createState() => _OtpFieldState();
}

class _OtpFieldState extends State<OtpField> with MountedStateMixin {
  bool _canResendOtp = false;
  late Timer _timer;

  // true means loading / null means done successfully / true means disappear loading
  bool? _loadingResend = false;

  @override
  void initState() {
    _initTimer();

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resendChild = _loadingResend == true
        ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 1,
            ))
        : (_loadingResend == false
            ? Text(
                _canResendOtp
                    ? widget.resendText
                    : '${widget.resendDuration.inSeconds - _timer.tick}',
      key: ValueKey('resend-$_canResendOtp'),
      style: const TextStyle(
                    color: Colors.grey, fontSize: 14, fontWeight: FontWeight.normal),
              )
            : const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
              ));

    return TextFormField(
      controller: widget.controller,
      readOnly: widget.readOnly,
      onFieldSubmitted: widget.onSubmitted,
      maxLength: 6,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(Icons.lock_clock_outlined),
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: _canResendOtp && widget.onResend != null
                  ? () async {
                      mountedSetState(() {
                        _loadingResend = true;
                        _canResendOtp = false;
                      });
                      final resetTimer = await widget.onResend!();
                      widget.controller.clear();
                      mountedSetState(() {
                        _loadingResend = null;
                      });
                      Future.delayed(const Duration(seconds: 1)).then((_) {
                        mountedSetState(() {
                          _loadingResend = false;
                        });
                        if (resetTimer) {
                          _timer.cancel();
                          _initTimer();
                        }
                      });
                    }
                  : null,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: AnimatedSwitcher(
                  transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
                  duration: const Duration(milliseconds: 200),
                  switchInCurve: Curves.easeInCubic,
                  switchOutCurve: Curves.easeOutCubic,
                  layoutBuilder: (currentChild, previousChildren) => ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 30),
                    child: Stack(
                      alignment: AlignmentDirectional.centerEnd,
                      children: [
                        ...previousChildren.map((e) => PositionedDirectional(
                            end: 0,
                            child: e)),
                        if (currentChild != null) currentChild,
                      ],
                    ),
                  ),
                  child: resendChild,
                ),
              ),
            ),
          )),
      buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
    );
  }

  void _initTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      print(timer.tick);
      if (timer.tick == widget.resendDuration.inSeconds) {
        timer.cancel();
        mountedSetState(() {
          _canResendOtp = true;
        });
      } else {
        mountedSetState();
      }
    });
  }
}

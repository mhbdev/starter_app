import 'package:apex_api/apex_api.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../routes/router.gr.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../res/r.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with MountedStateMixin, WidgetLoadMixin, SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final ValueNotifier<double> _animationValue = ValueNotifier<double>(0.0);

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )
      ..addStatusListener(_manageAnimationStatus)
      ..addListener(_setAnimationValue);
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_manageAnimationStatus);
    _controller.removeListener(_setAnimationValue);
    _controller.dispose();
    super.dispose();
  }

  void _setAnimationValue() {
    _animationValue.value = _controller.value;
  }

  void _manageAnimationStatus(status) {
    if (status == AnimationStatus.completed) {
      _controller.reverse();
    } else if (status == AnimationStatus.dismissed) {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Stack(
        children: [
          Center(
            child: ValueListenableBuilder<double>(
              valueListenable: _animationValue,
              builder: (context, value, child) {
                final logoSize = 120 - 20 * value;

                return Hero(
                  tag: 'logo-hero',
                  child: Image.asset(
                    R.images.logo,
                    width: logoSize,
                    height: logoSize,
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            left: 16,
            child: Text.rich(
              TextSpan(text: 'from ', children: [
                TextSpan(
                    text: 'ApexTeam',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrlString('https://apexteam.net',
                            mode: LaunchMode.externalApplication);
                      })
              ]),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  @override
  void onLoad(BuildContext context) {
    // TODO : You can change duration of splash here
    Future.delayed(const Duration(seconds: 3)).then((_) {
      if (ApexApiDb.isAuthenticated) {
        // TODO : route to Dashboard Screen
        // context.router.navigate(const DashboardRoute());
      } else {
        // TODO : route to Login Screen
        context.router.navigate(const LoginRoute());
      }
    });
  }
}

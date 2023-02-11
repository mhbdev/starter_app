import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../screens/splash.dart';
import '../screens/login/login.dart';

@CustomAutoRouter(
  replaceInRouteName: 'Page|Screen,Route',
  transitionsBuilder: noTransition,
  routes: <AutoRoute>[
    AutoRoute<String>(
      path: '/intro',
      page: SplashScreen,
      maintainState: false,
      initial: true,
    ),
    AutoRoute(maintainState: true, page: LoginScreen, path: '/login'),
    RedirectRoute(path: '*', redirectTo: '/intro'),
  ],
)
class $RootRouter {}

Widget noTransition(BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) =>
    child;

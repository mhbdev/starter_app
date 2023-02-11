import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => Application());
}

class Application {
  static Application get l => locator<Application>();

  GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

  Application();
}

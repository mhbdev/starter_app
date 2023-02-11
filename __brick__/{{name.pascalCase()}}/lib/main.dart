import 'dart:io';

import 'package:apex_api/apex_api.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'configure_nonweb.dart' if (dart.library.html) 'configure_web.dart';

import 'src/core/utils/storage_util.dart';
import 'src/routes/router.gr.dart';
import 'app.dart';
import 'locator.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // In case you have XHttpParseError uncomment this line below
  // HttpOverrides.global = MyHttpOverrides();

  // Initializing ApexApi
  await ApexApi.init();

  // Configure web app (urlStrategy)
  configureApp();

  // Setup StorageUtil
  StorageUtil.getInstance();

  // Setting up get_it locator
  // This should be after storage util init
  setupLocator();

  // Setup RootRouter for auto_route
  locator
      .registerSingleton<RootRouter>(RootRouter(locator<Application>().navKey));

  DevicePreview(
    enabled: !kReleaseMode && defaultTargetPlatform != TargetPlatform.android,
    builder: (context) => const RootRestorationScope(
      restorationId: 'root-scope',
      child: App(),
    ),
  );
}

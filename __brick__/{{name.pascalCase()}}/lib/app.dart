import 'package:apex_api/apex_api.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/app_localizations.dart';
import 'locator.dart';
import 'constants.dart';
import 'src/core/utils/storage_util.dart';
import 'src/routes/router.gr.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();

  static _AppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_AppState>();
}

class _AppState extends State<App> with MountedStateMixin {
  Locale? _locale = const Locale('en', '');

  @override
  void initState() {
    _locale = Locale(StorageUtil.getString('locale', defValue: 'en')!, '');
    super.initState();
  }

  Locale get locale => _locale ?? const Locale('en', '');

  void setLocale(Locale value) {
    mountedSetState(() {
      _locale = value;
    });
    StorageUtil.putString('locale', value.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit();
    final router = locator<RootRouter>();

    return MaterialApp.router(
      title: 'TestApp',
      useInheritedMediaQuery: true,
      routerDelegate: AutoRouterDelegate(router,
          navigatorObservers: () => [AutoRouteObserver()]),
      routeInformationParser:
          router.defaultRouteParser(includePrefixMatches: true),
      routeInformationProvider: router.routeInfoProvider(),
      locale: _locale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate
      ],
      supportedLocales: S.supportedLocales,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return DevicePreview.appBuilder(
          context,
          GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                currentFocus.focusedChild!.unfocus();
              }
            },
            child: ApiWrapper(
              navKey: router.navigatorKey,
              config: ApiConfig(Constants.handlerUrl,
                  privateVersion: Constants.handlerPrivateVersion,
                  publicVersion: Constants.handlerPublicVersion,
                  webKey: Constants.webKey,
                  androidKey: Constants.androidKey,
                  iosKey: Constants.iosKey,
                  windowsKey: Constants.windowsKey,
                  requestTimeout: const Duration(seconds: 30),
                  useMocks: true,
                  namespace: 'data',
                  languageCode: (_locale ?? const Locale('en', 'US'))
                      .languageCode
                      .toUpperCase()),
              // TODO : provide your implemented
              responseModels: const {},
              messageHandler: (request, response) {
                // TODO : implement your own way of showing global messages
              },
              progressWidget: WillPopScope(
                onWillPop: () {
                  return Future(() => false);
                },
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: SizedBox(
                            width: 45,
                            height: 45,
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.red[100],
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color?>(
                                  Colors.blue[400]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              retryBuilder: (context, onRetry) {
                // TODO : implement your own retry dialog widget. make sure you 'pop' the Navigator before calling [onRetry]
                throw UnimplementedError();
              },
              loginStepHandler: (step) {
                if ([
                  LoginStep.showUsername,
                  LoginStep.showPassword,
                  LoginStep.showOtp,
                ].contains(step)) {
                  context.router.replace(LoginRoute());
                }
              },
              child: botToastBuilder(context, child),
            ),
          ),
        );
      },
    );
  }
}

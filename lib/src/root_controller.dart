import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:trionesdev_antd_mobile/antd.dart';

class GetAntController extends SuperController {
  bool testMode = false;
  Key? unikey;
  AntThemeData? theme;
  AntThemeData? darkTheme;
  AntThemeMode? themeMode;

  final scaffoldMessengerKey = GlobalKey<AntScaffoldMessengerState>();

  bool defaultPopGesture = GetPlatform.isIOS;
  bool defaultOpaqueRoute = true;

  Transition? defaultTransition;
  Duration defaultTransitionDuration = const Duration(milliseconds: 300);
  Curve defaultTransitionCurve = Curves.easeOutQuad;

  Curve defaultDialogTransitionCurve = Curves.easeOutQuad;

  Duration defaultDialogTransitionDuration = const Duration(milliseconds: 300);

  final routing = Routing();

  Map<String, String?> parameters = {};

  CustomTransition? customTransition;

  var _key = GlobalKey<NavigatorState>(debugLabel: 'Key Created by default');

  Map<dynamic, GlobalKey<NavigatorState>> keys = {};

  GlobalKey<NavigatorState> get key => _key;

  GlobalKey<NavigatorState>? addKey(GlobalKey<NavigatorState> newKey) {
    _key = newKey;
    return key;
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    Get.asap(() {
      final locale = Get.deviceLocale;
      if (locale != null) {
        Get.updateLocale(locale);
      }
    });
  }

  @override
  void onDetached() {}

  @override
  void onInactive() {}

  @override
  void onPaused() {}

  @override
  void onResumed() {}

  @override
  void onHidden() {}

  void restartApp() {
    unikey = UniqueKey();
    update();
  }

  void setTheme(AntThemeData value) {
    if (darkTheme == null) {
      theme = value;
    } else {

      if (value.brightness == Brightness.light) {
        theme = value;
      } else {
        darkTheme = value;
      }
    }
    update();
  }

  void setThemeMode(AntThemeMode value) {
    themeMode = value;
    update();
  }
}

import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:trionesdev_antd_mobile/antd.dart';

class GetAntController extends GetMaterialController {

  AntThemeData? antTheme;
  AntThemeData? antDarkTheme;
  AntThemeMode? antThemeMode;

  final antScaffoldMessengerKey = GlobalKey<AntScaffoldMessengerState>();


  void setAntTheme(AntThemeData value) {
    if (antDarkTheme == null) {
      antTheme = value;
    } else {

      if (value.brightness == Brightness.light) {
        antTheme = value;
      } else {
        antDarkTheme = value;
      }
    }
    update();
  }

  void setAntThemeMode(AntThemeMode value) {
    antThemeMode = value;
    update();
  }
}

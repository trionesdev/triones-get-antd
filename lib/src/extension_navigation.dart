import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trionesdev_get_antd/src/root_controller.dart';
import 'package:trionesdev_antd_mobile/antd.dart';

import 'bottom_sheet.dart';

extension ExtensionBottomSheet on GetInterface {
  Future<T?> bottomSheet<T>(
      Widget bottomsheet, {
        Color? backgroundColor,
        double? elevation,
        bool persistent = true,
        ShapeBorder? shape,
        Clip? clipBehavior,
        Color? barrierColor,
        bool? ignoreSafeArea,
        bool isScrollControlled = false,
        bool useRootNavigator = false,
        bool isDismissible = true,
        bool enableDrag = true,
        RouteSettings? settings,
        Duration? enterBottomSheetDuration,
        Duration? exitBottomSheetDuration,
      }) {
    return Navigator.of(antOverlayContext!, rootNavigator: useRootNavigator)
        .push(GetAntModalBottomSheetRoute<T>(
      builder: (_) => bottomsheet,
      isPersistent: persistent,
      // theme: Theme.of(key.currentContext, shadowThemeOnly: true),
      theme: AntTheme.of(antKey.currentContext!),
      isScrollControlled: isScrollControlled,

      barrierLabel: MaterialLocalizations.of(antKey.currentContext!)
          .modalBarrierDismissLabel,

      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: elevation,
      shape: shape,
      removeTop: ignoreSafeArea ?? true,
      clipBehavior: clipBehavior,
      isDismissible: isDismissible,
      modalBarrierColor: barrierColor,
      settings: settings,
      enableDrag: enableDrag,
      enterBottomSheetDuration:
      enterBottomSheetDuration ?? const Duration(milliseconds: 250),
      exitBottomSheetDuration:
      exitBottomSheetDuration ?? const Duration(milliseconds: 200),
    ));
  }
}


extension GetAntNavigation on GetInterface {
  Future<T?>? to<T>(
      dynamic page, {
        bool? opaque,
        Transition? transition,
        Curve? curve,
        Duration? duration,
        int? id,
        String? routeName,
        bool fullscreenDialog = false,
        dynamic arguments,
        Bindings? binding,
        bool preventDuplicates = true,
        bool? popGesture,
        double Function(BuildContext context)? gestureWidth,
      }) {
    // var routeName = "/${page.runtimeType}";
    routeName ??= "/${page.runtimeType}";
    routeName = _cleanRouteName(routeName);
    if (preventDuplicates && routeName == currentRoute) {
      return null;
    }
    return global(id).currentState?.push<T>(
      GetPageRoute<T>(
        opaque: opaque ?? true,
        page: _resolvePage(page, 'to'),
        routeName: routeName,
        gestureWidth: gestureWidth,
        settings: RouteSettings(
          name: routeName,
          arguments: arguments,
        ),
        popGesture: popGesture ?? defaultAntPopGesture,
        transition: transition ?? defaultAntTransition,
        curve: curve ?? defaultAntTransitionCurve,
        fullscreenDialog: fullscreenDialog,
        binding: binding,
        transitionDuration: duration ?? defaultAntTransitionDuration,
      ),
    );
  }

  GetPageBuilder _resolvePage(dynamic page, String method) {
    if (page is GetPageBuilder) {
      return page;
    } else if (page is Widget) {
      Get.log(
          '''WARNING, consider using: "Get.$method(() => Page())" instead of "Get.$method(Page())".
Using a widget function instead of a widget fully guarantees that the widget and its controllers will be removed from memory when they are no longer used.
      ''');
      return () => page;
    } else if (page is String) {
      throw '''Unexpected String,
use toNamed() instead''';
    } else {
      throw '''Unexpected format,
you can only use widgets and widget functions here''';
    }
  }

  Future<T?>? toNamed<T>(
      String page, {
        dynamic arguments,
        int? id,
        bool preventDuplicates = true,
        Map<String, String>? parameters,
      }) {
    if (preventDuplicates && page == currentRoute) {
      return null;
    }

    if (parameters != null) {
      final uri = Uri(path: page, queryParameters: parameters);
      page = uri.toString();
    }

    return global(id).currentState?.pushNamed<T>(
      page,
      arguments: arguments,
    );
  }

  Future<T?>? offNamed<T>(
      String page, {
        dynamic arguments,
        int? id,
        bool preventDuplicates = true,
        Map<String, String>? parameters,
      }) {
    if (preventDuplicates && page == currentRoute) {
      return null;
    }

    if (parameters != null) {
      final uri = Uri(path: page, queryParameters: parameters);
      page = uri.toString();
    }
    return global(id).currentState?.pushReplacementNamed(
      page,
      arguments: arguments,
    );
  }

  void until(RoutePredicate predicate, {int? id}) {
    // if (key.currentState.mounted) // add this if appear problems on future with route navigate
    // when widget don't mounted
    return global(id).currentState?.popUntil(predicate);
  }

  Future<T?>? offUntil<T>(Route<T> page, RoutePredicate predicate, {int? id}) {
    // if (key.currentState.mounted) // add this if appear problems on future with route navigate
    // when widget don't mounted
    return global(id).currentState?.pushAndRemoveUntil<T>(page, predicate);
  }

  Future<T?>? offNamedUntil<T>(
      String page,
      RoutePredicate predicate, {
        int? id,
        dynamic arguments,
        Map<String, String>? parameters,
      }) {
    if (parameters != null) {
      final uri = Uri(path: page, queryParameters: parameters);
      page = uri.toString();
    }

    return global(id).currentState?.pushNamedAndRemoveUntil<T>(
      page,
      predicate,
      arguments: arguments,
    );
  }

  Future<T?>? offAndToNamed<T>(
      String page, {
        dynamic arguments,
        int? id,
        dynamic result,
        Map<String, String>? parameters,
      }) {
    if (parameters != null) {
      final uri = Uri(path: page, queryParameters: parameters);
      page = uri.toString();
    }
    return global(id).currentState?.popAndPushNamed(
      page,
      arguments: arguments,
      result: result,
    );
  }

  /// **Navigation.removeRoute()** shortcut.<br><br>
  ///
  /// Remove a specific [route] from the stack
  ///
  /// [id] is for when you are using nested navigation,
  /// as explained in documentation
  void removeRoute(Route<dynamic> route, {int? id}) {
    return global(id).currentState?.removeRoute(route);
  }


  Future<T?>? offAllNamed<T>(
      String newRouteName, {
        RoutePredicate? predicate,
        dynamic arguments,
        int? id,
        Map<String, String>? parameters,
      }) {
    if (parameters != null) {
      final uri = Uri(path: newRouteName, queryParameters: parameters);
      newRouteName = uri.toString();
    }

    return global(id).currentState?.pushNamedAndRemoveUntil<T>(
      newRouteName,
      predicate ?? (_) => false,
      arguments: arguments,
    );
  }

  /// Returns true if a Snackbar, Dialog or BottomSheet is currently OPEN
  bool get isOverlaysOpen =>
      (isSnackbarOpen || isDialogOpen! || isBottomSheetOpen!);

  /// Returns true if there is no Snackbar, Dialog or BottomSheet open
  bool get isOverlaysClosed =>
      (!isSnackbarOpen && !isDialogOpen! && !isBottomSheetOpen!);

  void back<T>({
    T? result,
    bool closeOverlays = false,
    bool canPop = true,
    int? id,
  }) {
    //TODO: This code brings compatibility of the new snackbar with GetX 4,
    // remove this code in version 5
    if (isSnackbarOpen && !closeOverlays) {
      closeCurrentSnackbar();
      return;
    }

    if (closeOverlays && isOverlaysOpen) {
      //TODO: This code brings compatibility of the new snackbar with GetX 4,
      // remove this code in version 5
      if (isSnackbarOpen) {
        closeAllSnackbars();
      }
      navigator?.popUntil((route) {
        return (!isDialogOpen! && !isBottomSheetOpen!);
      });
    }
    if (canPop) {
      if (global(id).currentState?.canPop() == true) {
        global(id).currentState?.pop<T>(result);
      }
    } else {
      global(id).currentState?.pop<T>(result);
    }
  }

  void close(int times, [int? id]) {
    if (times < 1) {
      times = 1;
    }
    var count = 0;
    var back = global(id).currentState?.popUntil((route) => count++ == times);

    return back;
  }

  Future<T?>? off<T>(
      dynamic page, {
        bool opaque = false,
        Transition? transition,
        Curve? curve,
        bool? popGesture,
        int? id,
        String? routeName,
        dynamic arguments,
        Bindings? binding,
        bool fullscreenDialog = false,
        bool preventDuplicates = true,
        Duration? duration,
        double Function(BuildContext context)? gestureWidth,
      }) {
    routeName ??= "/${page.runtimeType.toString()}";
    routeName = _cleanRouteName(routeName);
    if (preventDuplicates && routeName == currentRoute) {
      return null;
    }
    return global(id).currentState?.pushReplacement(GetPageRoute(
        opaque: opaque,
        gestureWidth: gestureWidth,
        page: _resolvePage(page, 'off'),
        binding: binding,
        settings: RouteSettings(
          arguments: arguments,
          name: routeName,
        ),
        routeName: routeName,
        fullscreenDialog: fullscreenDialog,
        popGesture: popGesture ?? defaultAntPopGesture,
        transition: transition ?? defaultAntTransition,
        curve: curve ?? defaultAntTransitionCurve,
        transitionDuration: duration ?? defaultAntTransitionDuration));
  }

  Future<T?>? offAll<T>(
      dynamic page, {
        RoutePredicate? predicate,
        bool opaque = false,
        bool? popGesture,
        int? id,
        String? routeName,
        dynamic arguments,
        Bindings? binding,
        bool fullscreenDialog = false,
        Transition? transition,
        Curve? curve,
        Duration? duration,
        double Function(BuildContext context)? gestureWidth,
      }) {
    routeName ??= "/${page.runtimeType.toString()}";
    routeName = _cleanRouteName(routeName);
    return global(id).currentState?.pushAndRemoveUntil<T>(
        GetPageRoute<T>(
          opaque: opaque,
          popGesture: popGesture ?? defaultAntPopGesture,
          page: _resolvePage(page, 'offAll'),
          binding: binding,
          gestureWidth: gestureWidth,
          settings: RouteSettings(
            name: routeName,
            arguments: arguments,
          ),
          fullscreenDialog: fullscreenDialog,
          routeName: routeName,
          transition: transition ?? defaultAntTransition,
          curve: curve ?? defaultAntTransitionCurve,
          transitionDuration: duration ?? defaultAntTransitionDuration,
        ),
        predicate ?? (route) => false);
  }

  String _cleanRouteName(String name) {
    name = name.replaceAll('() => ', '');

    /// uncommonent for URL styling.
    // name = name.paramCase!;
    if (!name.startsWith('/')) {
      name = '/$name';
    }
    return Uri.tryParse(name)?.toString() ?? name;
  }

  /// change default config of Get
  void antConfig(
      {bool? enableLog,
        LogWriterCallback? logWriterCallback,
        bool? defaultPopGesture,
        bool? defaultOpaqueRoute,
        Duration? defaultDurationTransition,
        bool? defaultGlobalState,
        Transition? defaultTransition}) {
    if (enableLog != null) {
      Get.isLogEnable = enableLog;
    }
    if (logWriterCallback != null) {
      Get.log = logWriterCallback;
    }
    if (defaultPopGesture != null) {
      _getxController.defaultPopGesture = defaultPopGesture;
    }
    if (defaultOpaqueRoute != null) {
      _getxController.defaultOpaqueRoute = defaultOpaqueRoute;
    }
    if (defaultTransition != null) {
      _getxController.defaultTransition = defaultTransition;
    }

    if (defaultDurationTransition != null) {
      _getxController.defaultTransitionDuration = defaultDurationTransition;
    }
  }

  Future<void> updateLocale(Locale l) async {
    Get.locale = l;
    await forceAppUpdate();
  }

  Future<void> forceAppUpdate() async {
    await antEngine.performReassemble();
  }

  void appUpdate() => _getxController.update();

  void changeTheme(AntThemeData theme) {
    _getxController.setTheme(theme);
  }

  void changeThemeMode(AntThemeMode themeMode) {
    _getxController.setThemeMode(themeMode);
  }

  GlobalKey<NavigatorState>? antAddKey(GlobalKey<NavigatorState> newKey) {
    return _getxController.addKey(newKey);
  }

  GlobalKey<NavigatorState>? nestedKey(dynamic key) {
    keys.putIfAbsent(
      key,
          () => GlobalKey<NavigatorState>(
        debugLabel: 'Getx nested key: ${key.toString()}',
      ),
    );
    return keys[key];
  }

  GlobalKey<NavigatorState> global(int? k) {
    GlobalKey<NavigatorState> newKey;
    if (k == null) {
      newKey = key;
    } else {
      if (!keys.containsKey(k)) {
        throw 'Route id ($k) not found';
      }
      newKey = keys[k]!;
    }

    if (newKey.currentContext == null && !testMode) {
      throw """You are trying to use contextless navigation without
      a GetMaterialApp or Get.key.
      If you are testing your app, you can use:
      [Get.testMode = true], or if you are running your app on
      a physical device or emulator, you must exchange your [MaterialApp]
      for a [GetMaterialApp].
      """;
    }

    return newKey;
  }

  /// give current arguments
  dynamic get arguments => antRouting.args;

  /// give name from current route
  String get currentRoute => antRouting.current;

  /// give name from previous route
  String get previousRoute => antRouting.previous;

  /// check if snackbar is open
  bool get isSnackbarOpen =>
      SnackbarController.isSnackbarBeingShown; //routing.isSnackbar;

  void closeAllSnackbars() {
    SnackbarController.cancelAllSnackbars();
  }

  Future<void> closeCurrentSnackbar() async {
    await SnackbarController.closeCurrentSnackbar();
  }

  /// check if dialog is open
  bool? get isDialogOpen => antRouting.isDialog;

  /// check if bottomsheet is open
  bool? get isBottomSheetOpen => antRouting.isBottomSheet;

  /// check a raw current route
  Route<dynamic>? get rawRoute => antRouting.route;

  /// check if popGesture is enable
  bool get isAntPopGestureEnable => defaultPopGesture;

  /// check if default opaque route is enable
  bool get isAntOpaqueRouteDefault => defaultAntOpaqueRoute;

  /// give access to currentContext
  BuildContext? get antContext => antKey.currentContext;

  /// give access to current Overlay Context
  BuildContext? get antOverlayContext {
    BuildContext? overlay;
    key.currentState?.overlay?.context.visitChildElements((element) {
      overlay = element;
    });
    return overlay;
  }

  /// give access to Theme.of(context)
  AntThemeData get theme {
    var theme = AntThemeData.fallback();
    if (antContext != null) {
      theme = AntTheme.of(antContext!);
    }
    return theme;
  }

  ///The current [WidgetsBinding]
  WidgetsBinding get antEngine {
    return WidgetsFlutterBinding.ensureInitialized();
  }

  /// The window to which this binding is bound.
  FlutterView get antWindow => View.of(antContext!);


  GlobalKey<NavigatorState> get antKey => _getxController.key;

  Map<dynamic, GlobalKey<NavigatorState>> get antKeys => _getxController.keys;

  GetAntController get antRootController => _getxController;

  bool get defaultAntPopGesture => _getxController.defaultPopGesture;
  bool get defaultAntOpaqueRoute => _getxController.defaultOpaqueRoute;

  Transition? get defaultAntTransition => _getxController.defaultTransition;

  Duration get defaultAntTransitionDuration {
    return _getxController.defaultTransitionDuration;
  }

  Curve get defaultAntTransitionCurve => _getxController.defaultTransitionCurve;

  Curve get defaultDialogTransitionCurve {
    return _getxController.defaultDialogTransitionCurve;
  }

  Duration get defaultDialogTransitionDuration {
    return _getxController.defaultDialogTransitionDuration;
  }

  Routing get antRouting => _getxController.routing;

  Map<String, String?> get parameters => _getxController.parameters;
  set parameters(Map<String, String?> newParameters) =>
      _getxController.parameters = newParameters;

  CustomTransition? get antCustomTransition => _getxController.customTransition;
  set antCustomTransition(CustomTransition? newTransition) =>
      _getxController.customTransition = newTransition;

  bool get testMode => _getxController.testMode;
  set testMode(bool isTest) => _getxController.testMode = isTest;

  void resetRootNavigator() {
    _getxController = GetAntController();
  }

  static GetAntController _getxController = GetAntController();
}

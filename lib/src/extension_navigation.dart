
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trionesdev_get_antd/src/root_controller.dart';
import 'package:trionesdev_antd_mobile/antd.dart';

extension GetAntNavigation on GetInterface{

  Future<T?>? antTo<T>(
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
    if (preventDuplicates && routeName == antCurrentRoute) {
      return null;
    }
    return antGlobal(id).currentState?.push<T>(
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

  Future<T?>? antToNamed<T>(
      String page, {
        dynamic arguments,
        int? id,
        bool preventDuplicates = true,
        Map<String, String>? parameters,
      }) {
    if (preventDuplicates && page == antCurrentRoute) {
      return null;
    }

    if (parameters != null) {
      final uri = Uri(path: page, queryParameters: parameters);
      page = uri.toString();
    }

    return antGlobal(id).currentState?.pushNamed<T>(
      page,
      arguments: arguments,
    );
  }

  Future<T?>? antOffNamed<T>(
      String page, {
        dynamic arguments,
        int? id,
        bool preventDuplicates = true,
        Map<String, String>? parameters,
      }) {
    if (preventDuplicates && page == antCurrentRoute) {
      return null;
    }

    if (parameters != null) {
      final uri = Uri(path: page, queryParameters: parameters);
      page = uri.toString();
    }
    return antGlobal(id).currentState?.pushReplacementNamed(
      page,
      arguments: arguments,
    );
  }

  void antUntil(RoutePredicate predicate, {int? id}) {
    // if (key.currentState.mounted) // add this if appear problems on future with route navigate
    // when widget don't mounted
    return antGlobal(id).currentState?.popUntil(predicate);
  }

  Future<T?>? antOffUntil<T>(Route<T> page, RoutePredicate predicate, {int? id}) {
    // if (key.currentState.mounted) // add this if appear problems on future with route navigate
    // when widget don't mounted
    return antGlobal(id).currentState?.pushAndRemoveUntil<T>(page, predicate);
  }

  Future<T?>? antOffNamedUntil<T>(
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

    return antGlobal(id).currentState?.pushNamedAndRemoveUntil<T>(
      page,
      predicate,
      arguments: arguments,
    );
  }

  Future<T?>? antOffAndToNamed<T>(
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
    return antGlobal(id).currentState?.popAndPushNamed(
      page,
      arguments: arguments,
      result: result,
    );
  }

  void removeRoute(Route<dynamic> route, {int? id}) {
    return antGlobal(id).currentState?.removeRoute(route);
  }

  Future<T?>? antOffAllNamed<T>(
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

    return antGlobal(id).currentState?.pushNamedAndRemoveUntil<T>(
      newRouteName,
      predicate ?? (_) => false,
      arguments: arguments,
    );
  }

  bool get isAntOverlaysOpen =>
      (isSnackbarOpen || isAntDialogOpen! || isAntBottomSheetOpen!);

  bool get isAntOverlaysClosed =>
      (!isSnackbarOpen && !isAntDialogOpen! && !isAntBottomSheetOpen!);

  void antBack<T>({
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
        return (!isAntDialogOpen! && !isAntBottomSheetOpen!);
      });
    }
    if (canPop) {
      if (antGlobal(id).currentState?.canPop() == true) {
        antGlobal(id).currentState?.pop<T>(result);
      }
    } else {
      antGlobal(id).currentState?.pop<T>(result);
    }
  }

  void antClose(int times, [int? id]) {
    if (times < 1) {
      times = 1;
    }
    var count = 0;
    var back = antGlobal(id).currentState?.popUntil((route) => count++ == times);

    return back;
  }

  Future<T?>? antOff<T>(
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
    return antGlobal(id).currentState?.pushReplacement(GetPageRoute(
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

  Future<T?>? antOffAll<T>(
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
    return antGlobal(id).currentState?.pushAndRemoveUntil<T>(
        GetPageRoute<T>(
          opaque: opaque,
          popGesture: popGesture ?? defaultPopGesture,
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
      _getxAntController.defaultPopGesture = defaultAntPopGesture;
    }
    if (defaultOpaqueRoute != null) {
      _getxAntController.defaultOpaqueRoute = defaultAntOpaqueRoute;
    }
    if (defaultTransition != null) {
      _getxAntController.defaultTransition = defaultAntTransition;
    }

    if (defaultDurationTransition != null) {
      _getxAntController.defaultTransitionDuration = defaultDurationTransition;
    }
  }


  void antAppUpdate() => _getxAntController.update();

  void changeAntTheme(ThemeData theme) {
    _getxAntController.setTheme(theme);
  }

  void changeAntThemeMode(ThemeMode themeMode) {
    _getxAntController.setThemeMode(themeMode);
  }

  GlobalKey<NavigatorState>? addAntKey(GlobalKey<NavigatorState> newKey) {
    return _getxAntController.addKey(newKey);
  }

  GlobalKey<NavigatorState>? antNestedKey(dynamic key) {
    antKeys.putIfAbsent(
      key,
          () => GlobalKey<NavigatorState>(
        debugLabel: 'Getx nested key: ${key.toString()}',
      ),
    );
    return antKeys[key];
  }

  GlobalKey<NavigatorState> antGlobal(int? k) {
    GlobalKey<NavigatorState> newKey;
    if (k == null) {
      newKey = antKey;
    } else {
      if (!antKeys.containsKey(k)) {
        throw 'Route id ($k) not found';
      }
      newKey = antKeys[k]!;
    }

    if (newKey.currentContext == null && !antTestMode) {
      throw """You are trying to use contextless navigation without
      a GetAntApp or Get.key.
      If you are testing your app, you can use:
      [Get.testMode = true], or if you are running your app on
      a physical device or emulator, you must exchange your [AntApp]
      for a [GetAntApp].
      """;
    }

    return newKey;
  }


  dynamic get antArguments {
    print(antRouting.args);
    return antRouting.args;
  }

  String get antCurrentRoute => antRouting.current;

  String get antPreviousRoute => antRouting.previous;


  bool? get isAntDialogOpen => antRouting.isDialog;

  bool? get isAntBottomSheetOpen => antRouting.isBottomSheet;

  Route<dynamic>? get antRawRoute => antRouting.route;

  bool get isAntPopGestureEnable => defaultAntPopGesture;

  bool get isAntOpaqueRouteDefault => defaultAntOpaqueRoute;

  BuildContext? get antContext => antKey.currentContext;

  /// give access to current Overlay Context
  BuildContext? get antOverlayContext {
    BuildContext? overlay;
    antKey.currentState?.overlay?.context.visitChildElements((element) {
      overlay = element;
    });
    return overlay;
  }

  AntThemeData get antTheme {
    var theme = AntThemeData.fallback();
    if (antContext != null) {
      theme = AntThemeData.of(antContext!);
    }
    return theme;
  }


  GlobalKey<NavigatorState> get antKey => _getxAntController.key;

  Map<dynamic, GlobalKey<NavigatorState>> get antKeys => _getxAntController.keys;

  GetAntController get antRootController => _getxAntController;

  bool get defaultAntPopGesture => _getxAntController.defaultPopGesture;
  bool get defaultAntOpaqueRoute => _getxAntController.defaultOpaqueRoute;

  Transition? get defaultAntTransition => _getxAntController.defaultTransition;

  Duration get defaultAntTransitionDuration {
    return _getxAntController.defaultTransitionDuration;
  }

  Curve get defaultAntTransitionCurve => _getxAntController.defaultTransitionCurve;

  Curve get defaultAntDialogTransitionCurve {
    return _getxAntController.defaultDialogTransitionCurve;
  }

  Duration get defaultAntDialogTransitionDuration {
    return _getxAntController.defaultDialogTransitionDuration;
  }


  Routing get antRouting => _getxAntController.routing;

  Map<String, String?> get antParameters => _getxAntController.parameters;
  set parameters(Map<String, String?> newParameters) =>
      _getxAntController.parameters = newParameters;


  CustomTransition? get antCustomTransition => _getxAntController.customTransition;
  set antCustomTransition(CustomTransition? newTransition) =>
      _getxAntController.customTransition = newTransition;

  bool get antTestMode => _getxAntController.testMode;
  set antTestMode(bool isTest) => _getxAntController.testMode = isTest;


  void resetRootNavigator() {
    _getxAntController = GetAntController();
  }

  static GetAntController _getxAntController = GetAntController();
}
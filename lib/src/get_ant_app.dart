import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_core/src/log.dart';
import 'package:get/get_core/src/smart_management.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_navigation/src/root/internacionalization.dart';
import 'package:get/get_navigation/src/routes/custom_transition.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/observers/route_observer.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/route_manager.dart';
// import 'package:triones_get_antd/src/extension_navigation.dart';
import 'package:trionesdev_antd_mobile/antd.dart';
import 'root_controller.dart';

class GetAntApp extends StatelessWidget {
  final GlobalKey<NavigatorState>? navigatorKey;

  final GlobalKey<AntScaffoldMessengerState>? scaffoldMessengerKey;
  final Widget? home;
  final Map<String, WidgetBuilder>? routes;
  final String? initialRoute;
  final RouteFactory? onGenerateRoute;
  final InitialRouteListFactory? onGenerateInitialRoutes;
  final RouteFactory? onUnknownRoute;
  final List<NavigatorObserver>? navigatorObservers;
  final TransitionBuilder? builder;
  final String title;
  final GenerateAppTitle? onGenerateTitle;
  final AntThemeData? theme;
  final AntThemeData? darkTheme;
  final AntThemeMode themeMode;
  final CustomTransition? customTransition;
  final Color? color;
  final Map<String, Map<String, String>>? translationsKeys;
  final Translations? translations;
  final TextDirection? textDirection;
  final Locale? locale;
  final Locale? fallbackLocale;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final LocaleListResolutionCallback? localeListResolutionCallback;
  final LocaleResolutionCallback? localeResolutionCallback;
  final Iterable<Locale> supportedLocales;
  final bool showPerformanceOverlay;
  final bool checkerboardRasterCacheImages;
  final bool checkerboardOffscreenLayers;
  final bool showSemanticsDebugger;
  final bool debugShowCheckedModeBanner;
  final Map<LogicalKeySet, Intent>? shortcuts;
  final ScrollBehavior? scrollBehavior;
  final AntThemeData? highContrastTheme;
  final AntThemeData? highContrastDarkTheme;
  final Map<Type, Action<Intent>>? actions;
  final bool debugShowMaterialGrid;
  final ValueChanged<Routing?>? routingCallback;
  final Transition? defaultTransition;
  final bool? opaqueRoute;
  final VoidCallback? onInit;
  final VoidCallback? onReady;
  final VoidCallback? onDispose;
  final bool? enableLog;
  final LogWriterCallback? logWriterCallback;
  final bool? popGesture;
  final SmartManagement smartManagement;
  final Bindings? initialBinding;
  final Duration? transitionDuration;
  final bool? defaultGlobalState;
  final List<GetPage>? getPages;
  final GetPage? unknownRoute;
  final RouteInformationProvider? routeInformationProvider;
  final RouteInformationParser<Object>? routeInformationParser;
  final RouterDelegate<Object>? routerDelegate;
  final BackButtonDispatcher? backButtonDispatcher;
  final bool useInheritedMediaQuery;

  GetAntApp({
    Key? key,
    this.navigatorKey,
    this.scaffoldMessengerKey,
    this.home,
    Map<String, Widget Function(BuildContext)> this.routes =
    const <String, WidgetBuilder>{},
    this.initialRoute,
    this.onGenerateRoute,
    this.onGenerateInitialRoutes,
    this.onUnknownRoute,
    this.useInheritedMediaQuery = false,
    List<NavigatorObserver> this.navigatorObservers =
    const <NavigatorObserver>[],
    this.builder,
    this.textDirection,
    this.title = '',
    this.onGenerateTitle,
    this.color,
    this.theme,
    this.darkTheme,
    this.themeMode = AntThemeMode.system,
    this.locale,
    this.fallbackLocale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.debugShowMaterialGrid = false,
    this.showPerformanceOverlay = false,
    this.checkerboardRasterCacheImages = false,
    this.checkerboardOffscreenLayers = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = true,
    this.shortcuts,
    this.scrollBehavior,
    this.customTransition,
    this.translationsKeys,
    this.translations,
    this.onInit,
    this.onReady,
    this.onDispose,
    this.routingCallback,
    this.defaultTransition,
    this.getPages,
    this.opaqueRoute,
    this.enableLog = kDebugMode,
    this.logWriterCallback,
    this.popGesture,
    this.transitionDuration,
    this.defaultGlobalState,
    this.smartManagement = SmartManagement.full,
    this.initialBinding,
    this.unknownRoute,
    this.highContrastTheme,
    this.highContrastDarkTheme,
    this.actions,
  }): routeInformationProvider = null,
        routeInformationParser = null,
        routerDelegate = null,
        backButtonDispatcher = null,
        super(key: key);

  GetAntApp.router({
    Key? key,
    this.routeInformationProvider,
    this.scaffoldMessengerKey,
    RouteInformationParser<Object>? routeInformationParser,
    RouterDelegate<Object>? routerDelegate,
    this.backButtonDispatcher,
    this.builder,
    this.title = '',
    this.onGenerateTitle,
    this.color,
    this.theme,
    this.darkTheme,
    this.useInheritedMediaQuery = false,
    this.highContrastTheme,
    this.highContrastDarkTheme,
    this.themeMode = AntThemeMode.system,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.debugShowMaterialGrid = false,
    this.showPerformanceOverlay = false,
    this.checkerboardRasterCacheImages = false,
    this.checkerboardOffscreenLayers = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = true,
    this.shortcuts,
    this.scrollBehavior,
    this.actions,
    this.customTransition,
    this.translationsKeys,
    this.translations,
    this.textDirection,
    this.fallbackLocale,
    this.routingCallback,
    this.defaultTransition,
    this.opaqueRoute,
    this.onInit,
    this.onReady,
    this.onDispose,
    this.enableLog = kDebugMode,
    this.logWriterCallback,
    this.popGesture,
    this.smartManagement = SmartManagement.full,
    this.initialBinding,
    this.transitionDuration,
    this.defaultGlobalState,
    this.getPages,
    this.navigatorObservers,
    this.unknownRoute,
  })  : routerDelegate = routerDelegate ??= Get.createDelegate(
    notFoundRoute: unknownRoute,
  ),
        routeInformationParser =
        routeInformationParser ??= Get.createInformationParser(
          initialRoute: getPages?.first.name ?? '/',
        ),
  //navigatorObservers = null,
        navigatorKey = null,
        onGenerateRoute = null,
        home = null,
        onGenerateInitialRoutes = null,
        onUnknownRoute = null,
        routes = null,
        initialRoute = null,
        super(key: key) {
    Get.routerDelegate = routerDelegate;
    Get.routeInformationParser = routeInformationParser;
  }


  @override
  Widget build(BuildContext context) => GetBuilder<GetAntController>(
    init: Get.rootController,
    dispose: (d) {
      onDispose?.call();
    },
    initState: (i) {
      Get.engine.addPostFrameCallback((timeStamp) {
        onReady?.call();
      });
      if (locale != null) Get.locale = locale;

      if (fallbackLocale != null) Get.fallbackLocale = fallbackLocale;

      if (translations != null) {
        Get.addTranslations(translations!.keys);
      } else if (translationsKeys != null) {
        Get.addTranslations(translationsKeys!);
      }

      Get.customTransition = customTransition;

      initialBinding?.dependencies();
      if (getPages != null) {
        Get.addPages(getPages!);
      }

      //Get.setDefaultDelegate(routerDelegate);
      Get.smartManagement = smartManagement;
      onInit?.call();

      Get.config(
        enableLog: enableLog ?? Get.isLogEnable,
        logWriterCallback: logWriterCallback,
        defaultTransition: defaultTransition ?? Get.defaultTransition,
        defaultOpaqueRoute: opaqueRoute ?? Get.isOpaqueRouteDefault,
        defaultPopGesture: popGesture ?? Get.isPopGestureEnable,
        defaultDurationTransition:
        transitionDuration ?? Get.defaultTransitionDuration,
      );
    },
    builder: (_) => routerDelegate != null
        ? AntApp.router(
      routerDelegate: routerDelegate!,
      routeInformationParser: routeInformationParser!,
      backButtonDispatcher: backButtonDispatcher,
      routeInformationProvider: routeInformationProvider,
      key: _.unikey,
      builder: defaultBuilder,
      title: title,
      onGenerateTitle: onGenerateTitle,
      color: color,
      theme: _.theme ?? theme ?? AntThemeData.fallback(),
      darkTheme:
      _.darkTheme ?? darkTheme ?? theme ?? ThemeData.fallback(),
      themeMode: _.themeMode ?? themeMode,
      locale: Get.locale ?? locale,
      scaffoldMessengerKey:
      scaffoldMessengerKey ?? _.scaffoldMessengerKey,
      localizationsDelegates: localizationsDelegates,
      localeListResolutionCallback: localeListResolutionCallback,
      localeResolutionCallback: localeResolutionCallback,
      supportedLocales: supportedLocales,
      debugShowMaterialGrid: debugShowMaterialGrid,
      showPerformanceOverlay: showPerformanceOverlay,
      checkerboardRasterCacheImages: checkerboardRasterCacheImages,
      checkerboardOffscreenLayers: checkerboardOffscreenLayers,
      showSemanticsDebugger: showSemanticsDebugger,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      shortcuts: shortcuts,
      scrollBehavior: scrollBehavior,
      // useInheritedMediaQuery: useInheritedMediaQuery,
    )
        : AntApp(
      key: _.unikey,
      navigatorKey: (navigatorKey == null
          ? Get.key
          : Get.addKey(navigatorKey!)),
      scaffoldMessengerKey:
      scaffoldMessengerKey ?? _.scaffoldMessengerKey,
      home: home,
      routes: routes ?? const <String, WidgetBuilder>{},
      initialRoute: initialRoute,
      onGenerateRoute:
      (getPages != null ? generator : onGenerateRoute),
      onGenerateInitialRoutes: (getPages == null || home != null)
          ? onGenerateInitialRoutes
          : initialRoutesGenerate,
      onUnknownRoute: onUnknownRoute,
      navigatorObservers: (navigatorObservers == null
          ? <NavigatorObserver>[
        GetObserver(routingCallback, Get.routing)
      ]
          : <NavigatorObserver>[
        GetObserver(routingCallback, Get.routing)
      ]
        ..addAll(navigatorObservers!)),
      builder: defaultBuilder,
      title: title,
      onGenerateTitle: onGenerateTitle,
      color: color,
      theme: _.theme ?? theme ?? AntThemeData.fallback(),
      darkTheme:
      _.darkTheme ?? darkTheme ?? theme ?? AntThemeData.fallback(),
      themeMode: _.themeMode ?? themeMode,
      locale: Get.locale ?? locale,
      localizationsDelegates: localizationsDelegates,
      localeListResolutionCallback: localeListResolutionCallback,
      localeResolutionCallback: localeResolutionCallback,
      supportedLocales: supportedLocales,
      debugShowMaterialGrid: debugShowMaterialGrid,
      showPerformanceOverlay: showPerformanceOverlay,
      checkerboardRasterCacheImages: checkerboardRasterCacheImages,
      checkerboardOffscreenLayers: checkerboardOffscreenLayers,
      showSemanticsDebugger: showSemanticsDebugger,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      shortcuts: shortcuts,
      scrollBehavior: scrollBehavior,
      // useInheritedMediaQuery: useInheritedMediaQuery,
      //   actions: actions,
    ),
  );

  Widget defaultBuilder(BuildContext context, Widget? child) {
    return Directionality(
      textDirection: textDirection ??
          (rtlLanguages.contains(Get.locale?.languageCode)
              ? TextDirection.rtl
              : TextDirection.ltr),
      child: builder == null
          ? (child ?? const Ant())
          : builder!(context, child ?? const Ant()),
    );
  }

  Route<dynamic> generator(RouteSettings settings) {
    return PageRedirect(settings: settings, unknownRoute: unknownRoute).page();
  }

  List<Route<dynamic>> initialRoutesGenerate(String name) {
    return [
      PageRedirect(
        settings: RouteSettings(name: name),
        unknownRoute: unknownRoute,
      ).page()
    ];
  }
}
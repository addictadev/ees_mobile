import 'package:flutter/material.dart';
import 'package:palestine_console/palestine_console.dart';

class NavigationManager {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<T?>? navigatTo<T>(Widget screen,
      {GlobalKey<NavigatorState>? key}) {
    final navigator = key ?? navigatorKey;
    Print.green('navigate to => $screen');
    return navigator.currentState
        ?.push<T>(MaterialPageRoute(builder: (_) => screen));
  }

  static Future? navigatToAndFinish(Widget screen,
      {GlobalKey<NavigatorState>? key}) {
    final navigator = key ?? navigatorKey;
    Print.green('navigate and finish to => $screen');
    return navigator.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => screen),
      (route) => false,
    );
  }

  static void pop<T extends Object>([T? result]) {
    navigatorKey.currentState?.pop<T>(result);
  }

  static void popUntil(String routeName) {
    navigatorKey.currentState?.popUntil(ModalRoute.withName(routeName));
  }

  static BuildContext getContext() {
    return (navigatorKey.currentState!.overlay!.context);
  }
}

import 'package:flutter/widgets.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic>? navigateTo(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState
        ?.pushNamed(routeName, arguments: arguments);
  }

  Future<void>? pushAndRemoveUntil(Route newRoute, {dynamic arguments}) {
    navigatorKey.currentState?.pushAndRemoveUntil<void>(
      newRoute,
      (route) => false,
    );
  }

  Future<T?>? push<T extends Object?>(Route<T> newRoute, {dynamic arguments}) {
    return navigatorKey.currentState?.push(newRoute);
  }

  Future<void>? removeRouteBelow(Route anchorRoute) {
    navigatorKey.currentState?.removeRouteBelow(anchorRoute);
  }

  void goBack() {
    return navigatorKey.currentState?.pop();
  }
}

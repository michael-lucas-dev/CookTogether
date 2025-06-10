import 'package:flutter/widgets.dart';
import 'package:firebase_performance/firebase_performance.dart';

class NavigationPerformanceObserver extends NavigatorObserver {
  final FirebasePerformance _performance = FirebasePerformance.instance;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _trackRoutePerformance(route, 'push');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _trackRoutePerformance(route, 'pop');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _trackRoutePerformance(newRoute ?? oldRoute!, 'replace');
  }

  void _trackRoutePerformance(Route<dynamic> route, String action) {
    if (route is ModalRoute && route.settings.name != null) {
      final trace = _performance.newTrace('navigation_${route.settings.name}_$action');
      trace.start();

      // On arrête la trace après un court délai pour simuler la fin de la navigation
      Future.delayed(const Duration(milliseconds: 500), () {
        trace.stop();
      });
    }
  }
}

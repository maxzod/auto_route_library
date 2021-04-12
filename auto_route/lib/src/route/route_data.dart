import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';

import 'route_data_scope.dart';

class RouteData {
  final PageRouteInfo route;
  final RouteData? parent;
  final RouteConfig? config;
  final ValueKey<String> key;

  RouteData? activeChild;

  RouteData({
    required this.route,
    this.parent,
    this.config,
    required this.key,
  }) {
    if (route.hasInitialChildren) {
      activeChild = RouteData(
        route: route.initialChildren!.last,
        parent: this,
        key: ValueKey(route.initialChildren!.last.stringMatch),
      );
    }
  }

  List<PageRouteInfo> get breadcrumbs => List.unmodifiable([
        if (parent != null) ...parent!.breadcrumbs,
        route,
      ]);

  List<PageRouteInfo> get routeSegments => List.unmodifiable([
        route,
        if (activeChild != null) ...activeChild!.routeSegments,
      ]);

  List<String> get segments => [route.stringMatch, if (activeChild != null) ...activeChild!.segments];

  static RouteData of(BuildContext context) {
    return RouteDataScope.of(context);
  }

  T argsAs<T>({T Function()? orElse}) {
    final args = route.args;
    if (args == null) {
      if (orElse == null) {
        throw FlutterError('${T.toString()} can not be null because it has a required parameter');
      } else {
        return orElse();
      }
    } else if (args is! T) {
      throw FlutterError('Expected [${T.toString()}],  found [${args.runtimeType}]');
    } else {
      return args;
    }
  }

  String get name => route.routeName;

  String get path => route.path;

  String get match => route.stringMatch;

  Parameters get pathParams => Parameters(route.params);

  Parameters get queryParams => Parameters(route.queryParams);

  String? get fragment => route.match?.fragment;

  void updateChildren(PageRouteInfo route) {
    route = route;
  }
}

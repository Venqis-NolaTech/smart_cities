import 'package:flutter/material.dart';

typedef Widget AppHandlerFunc(Object);

class AppRouteHandler {
  final AppHandlerFunc handlerFunc;

  AppRouteHandler({@required this.handlerFunc});
}

class AppRoute {
  final String path;
  final AppRouteHandler handler;

  AppRoute(this.path, this.handler);
}

class AppRouter {
  static final appRouter = AppRouter();

  final routes = List<AppRoute>();

  void define({
    @required String routePath,
    @required AppRouteHandler handler,
  }) {
    routes.add(AppRoute(routePath, handler));
  }

  Route<dynamic> matchRoute(String path, {RouteSettings routeSettings}) {
    final routeMatched = routes.firstWhere(
      (route) => route.path == path,
      orElse: () => null,
    );

    if (routeMatched != null) {
      return MaterialPageRoute(
        settings: RouteSettings(
          name: path,
          arguments: routeSettings.arguments,
        ),
        builder: (context) =>
            routeMatched.handler.handlerFunc(routeSettings.arguments),
      );
    }

    return MaterialPageRoute(
      builder: (context) => Scaffold(
        body: Center(
          child: Text('path no implement'),
        ),
      ),
    );
  }
}

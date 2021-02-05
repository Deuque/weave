
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weave/Screens/splash.dart';
import 'package:weave/route_decider.dart';

class Routes {
  static Route<dynamic> getRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch(settings.name){
      case 'splash':
        return CupertinoPageRoute(builder: (_) => Splash());
      case 'initial':
        return CupertinoPageRoute(builder: (_) => RouteDecider());

    }
  }
}
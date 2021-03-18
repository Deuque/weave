
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weave/Screens/auth.dart';
import 'package:weave/Screens/dash.dart';
import 'package:weave/Screens/forgot_password.dart';
import 'package:weave/Screens/notifications.dart';
import 'package:weave/Screens/phone.dart';
import 'package:weave/Screens/play_area.dart';
import 'package:weave/Screens/select_user.dart';
import 'package:weave/Screens/splash.dart';
import 'package:weave/Screens/username.dart';
import 'package:weave/route_decider.dart';

class Routes {
  static Route<dynamic> getRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch(settings.name){
      case 'splash':
        return CupertinoPageRoute(builder: (_) => Splash());
      case 'initial':
        return CupertinoPageRoute(builder: (_) => RouteDecider());
      case 'auth':
        return CupertinoPageRoute(builder: (_) => Auth());
      case 'forgotPassword':
        return CupertinoPageRoute(builder: (_) => ForgotPassword());
      case 'username':
        return CupertinoPageRoute(builder: (_) => ChooseUsername(username: args,));
      case 'phone':
        return CupertinoPageRoute(builder: (_) => AddPhone(phone: args,));
      case 'notifications':
        return CupertinoPageRoute(builder: (_) => Notifications());
      case 'dash':
        return CupertinoPageRoute(builder: (_) => Dashboard());
      case 'playArea':
        return CupertinoPageRoute(builder: (_) => PlayArea(activity: args,));
      case 'selectUser':
        return CupertinoPageRoute(builder: (_) => SelectUser(selectUserType: (args as List)[0], selectedUsers: (args as List)[1], title: (args as List)[2],));

    }
  }
}
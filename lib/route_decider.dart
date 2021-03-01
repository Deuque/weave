import 'package:flutter/material.dart';
import 'package:weave/Controllers/contacts_controller.dart';
import 'package:weave/Controllers/current_user_controller.dart';
import 'file:///C:/Users/HP/Desktop/keep/weave_mobile/lib/Screens/onboarding.dart';
import 'package:weave/Controllers/user_controller.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:weave/Models/user.dart';
import 'package:weave/Screens/dash.dart';
import 'package:weave/Screens/username.dart';
import 'package:weave/Util/colors.dart';

class RouteDecider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return UserController().currentUserId() == null
        ? Onboarding()
        : FutureBuilder<User>(
            future: context.read(userProvider).getInitialUserData(),
            builder: (context, snapshot) {
              if (snapshot.data == null ||
                  snapshot.connectionState == ConnectionState.waiting)
                return Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    valueColor: AlwaysStoppedAnimation(primary),
                  ),
                );

              return snapshot.data.username.isEmpty ? ChooseUsername() : Dashboard();
            });
  }
}

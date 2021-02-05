import 'package:flutter/material.dart';
import 'package:weave/Screens/Onboarding/onboarding.dart';

class RouteDecider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return Consumer(
    //   builder: (context, watch,_) {
    //     var currentUserState = watch(currentUserProvider.state);
    //     return currentUserState==null||currentUserState.userId=='0'?Onboarding():currentUserState.userId=='1'?Dash();
    //   }
    // );
    //print(context.read(currentUserProvider).getUser().fullname);
    return Onboarding();
    // FutureBuilder(
    //   future: context.read(currentUserProvider).getLoginState(),
    //   builder: (context, snapshot) {
    //     if (snapshot==null || snapshot.connectionState == ConnectionState.waiting)
    //       return Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     if (!snapshot.data) return Onboarding();
    //     return Dash();
    //   });
  }
}
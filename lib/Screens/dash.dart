import 'package:flutter/material.dart';
import 'package:weave/Controllers/current_user_controller.dart';
import 'package:weave/Screens/home.dart';
import 'package:weave/Screens/new_game.dart';
import 'package:weave/Util/colors.dart';
import 'package:weave/Widgets/customBottomBar.dart';
import 'package:flutter_riverpod/all.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Widget currentTab = Home();

  @override
  Widget build(BuildContext context) {
    print('dash '+context.read(userProvider).currentUser().username);
    return Scaffold(
      body: currentTab,
      bottomNavigationBar: CustomBottomBar(
        items: [
          CustomBottomBarItem(
            iconData: 'assets/images/home.png',
          ),
          CustomBottomBarItem(
            iconData: 'assets/images/new.png',
          ),
          CustomBottomBarItem(
            iconData: 'assets/images/profile.png',
          ),
        ],
        color: lightGrey.withOpacity(.3),
        selectedColor: primary,
        onTabSelected: (int index) {
          if (index == 0)
            setState(() {
              currentTab = Home();
            });
          if (index == 1)
            Future.delayed(Duration(milliseconds: 400),()=>showModalBottomSheet(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                context: (context),
                builder: (_) => NewGame()));
          // if(index==3)currentTab=Account();
        },
      ),
    );
  }
}

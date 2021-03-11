import 'package:flutter/material.dart';
import 'package:weave/Controllers/contacts_controller.dart';
import 'package:weave/Controllers/current_user_controller.dart';
import 'package:weave/Controllers/streams_controller.dart';
import 'package:weave/Controllers/user_controller.dart';
import 'package:weave/Screens/home.dart';
import 'package:weave/Screens/new_game.dart';
import 'package:weave/Screens/profile.dart';
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
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read(userProvider).startCurrentUserStream();
    context.read(contactsProvider).initialSetup();
    context.read(userStreamsProvider).startStreams();
  }

  @override
  Widget build(BuildContext context) {
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
        onTabSelected: (int index) async{
          if (index == 0)
            setState(() {
              currentTab = Home();
            });
          if (index == 1)
            Future.delayed(Duration(milliseconds: 400),()=>showModalBottomSheet(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top:Radius.circular(10))),
                context: (context),
                builder: (_) => NewGame()));
          if(index==2){
            setState(() {
              currentTab = Profile();
            });
          }
        },
      ),
    );
  }
}

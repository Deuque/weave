import 'package:flutter/material.dart';
import 'package:weave/Screens/home.dart';
import 'package:weave/Util/colors.dart';
import 'package:weave/Widgets/customBottomBar.dart';
class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Widget currentTab = Home();
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
        onTabSelected: (int index){
           if(index==0)currentTab=Home();
          // if(index==1)currentTab=Transactions();
          // if(index==3)currentTab=Account();
          setState(() {

          });
        },
      ),
    );
  }
}

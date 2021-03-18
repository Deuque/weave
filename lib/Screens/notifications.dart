import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:weave/Controllers/current_user_controller.dart';
import 'package:weave/Controllers/user_controller.dart';
import 'package:weave/Util/helper_functions.dart';
import 'package:weave/Widgets/toggle.dart';

class Notifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List<Map<String, dynamic>> myNotifications() => [
      {
        'title': 'Invites',
        'toggles': ['Off', 'On'],
        'selected': context.read(userProvider.state).receiveInviteNotifications ? 1 : 0,
        'onSelected': (int index) => UserController().saveUserData({'receiveInviteNotifications':index==1})
      },
      {
        'title': 'Messages',
        'toggles': ['No', 'Yes'],
        'selected': context.read(userProvider.state).receiveMessageNotifications ? 1 :0,
        'onSelected': (int index) {
          UserController().saveUserData({'receiveMessageNotifications':index==1});
        }
      },
      {
        'title': 'Games',
        'toggles': ['No', 'Yes'],
        'selected': context.read(userProvider.state).receiveGameNotifications ? 1 :0,
        'onSelected': (int index) {
          UserController().saveUserData({'receiveGameNotifications':index==1});
        }
      },
    ];
    spacer() => SizedBox(
      height: size.height * .03,
    );
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: backButton(
            onPressed: () => Navigator.pop(context),
            color: Theme.of(context).secondaryHeaderColor.withOpacity(.8)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Receive Notifications For',
              style: TextStyle(
                  color: Theme
                      .of(context)
                      .secondaryHeaderColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            spacer(),
            Material(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).backgroundColor,
              child: ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (_, i) => Toggle(
                    title: myNotifications()[i]['title'],
                    toggles: myNotifications()[i]['toggles'],
                    selected: myNotifications()[i]['selected'],
                    onSelected: myNotifications()[i]['onSelected'],
                  ),
                  separatorBuilder: (_, i) => Divider(
                    height: 2,
                  ),
                  itemCount: myNotifications().length),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:weave/Models/activity.dart';
import 'package:weave/Models/invite.dart';
import 'package:weave/Util/colors.dart';
import 'package:weave/Util/helper_functions.dart';

class InviteLayout extends StatelessWidget {
  final Invite invite;

  const InviteLayout({Key key, this.invite}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool userIsSender = invite.sender == '@deeq';

    Widget actionWidgets() => Container(
      height: 40,
      child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              {'color': error, 'text': 'Decline', 'onClick': () {}},
              {},
              {'color': success, 'text': 'Accept', 'onClick': () {}},
            ]
                .map((e) => e.isEmpty? VerticalDivider() : Expanded(
                  child: FlatButton(
              onPressed: e['onClick'],
                        //color: e['color'],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        child: Text(
                          e['text'],
                          style: TextStyle(color: e['color'],),
                        ),
                      ),
                ))
                .toList(),
          ),
    );

    return Container(
      margin: EdgeInsets.only(bottom: 10,right: 6,left: 6),
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor.withOpacity(.2),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: RichText(
                text: TextSpan(
              children: [
                TextSpan(
                  text: userIsSender ? 'You' : invite.sender,
                  style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor.withOpacity(.8),
                      fontWeight: userIsSender ? FontWeight.w300 : FontWeight.w500,
                      fontSize:
                          userIsSender ? size.width * .032 : size.width * .035),
                ),
                TextSpan(
                  text: ' sent ',
                  style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor.withOpacity(.8),
                      fontWeight: FontWeight.w300,
                      fontSize: size.width * .032),
                ),
                TextSpan(
                  text: userIsSender ? invite.receiver : 'you',
                  style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor.withOpacity(.8),
                      fontWeight: FontWeight.w500,
                      fontSize: size.width * .035),
                ),
                TextSpan(
                  text: ' an invite ',
                  style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor.withOpacity(.8),
                      fontWeight: FontWeight.w300,
                      fontSize: size.width * .032),
                ),
              ],
            )),
            subtitle: gameTypeWidget(type: invite.gameType,size: size.width*.03,context: context),
            trailing: Text(
              invite.date,
              style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor.withOpacity(.5),
                  fontWeight: FontWeight.w300,
                  fontSize: size.width * .026),
            ),
          ),
          if(!userIsSender)Divider(height: 0,),
          if(!userIsSender)actionWidgets()
        ],
      ),
    );
  }
}

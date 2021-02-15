import 'package:flutter/material.dart';
import 'package:weave/Models/activity.dart';
import 'package:weave/Models/invite.dart';
import 'package:weave/Util/colors.dart';

class InviteLayout extends StatelessWidget {
  final Invite invite;

  const InviteLayout({Key key, this.invite}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool userIsSender = invite.sender == '@deeq';
    return Container(
      margin: EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: userIsSender ? 'You' : invite.sender,
                style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor.withOpacity(.8),
                    fontWeight: userIsSender ? FontWeight.w400 : FontWeight.w500,
                    fontSize: userIsSender ? size.width*.032 : size.width*.035),
              ),
              TextSpan(
                text: ' sent ',
                style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor.withOpacity(.8),
                    fontWeight: FontWeight.w400 ,
                    fontSize: size.width*.032 ),
              ),
              TextSpan(
                text: userIsSender ? invite.receiver : 'you' ,
                style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor.withOpacity(.8),
                    fontWeight: FontWeight.w500,
                    fontSize: size.width*.035),
              ),
              TextSpan(
                text: ' an invite ',
                style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor.withOpacity(.8),
                    fontWeight: FontWeight.w400 ,
                    fontSize: size.width*.032 ),
              ),
            ],
          )
        ),
        subtitle: Row(
          children: [
            Image.asset(
              invite.gameType == 0
                  ? 'assets/images/anagram.png'
                  : 'assets/images/tictactoe.png',
              height: size.width*.03,
              width: size.width*.03,
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              invite.gameType == 1 ? 'Anagram' : 'Tic-Tac-Toe',
              style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor.withOpacity(.6),
                  fontWeight: FontWeight.w100,
                  fontSize: size.width*.029),
            )
          ],
        ),
        trailing: Text(
          invite.date,
          style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor.withOpacity(.5),
              fontWeight: FontWeight.w300,
              fontSize: size.width*.026),
        ),
      ),
    );
  }
}

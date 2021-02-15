import 'package:flutter/material.dart';
import 'package:weave/Models/activity.dart';
import 'package:weave/Util/colors.dart';

class ActivityLayout extends StatelessWidget {
  final Activity activity;

  const ActivityLayout({Key key, this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget statusIndicator(){
      return Visibility(
        visible: activity.status!=0,
        child: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              shape: BoxShape.circle
            ),
            padding: EdgeInsets.all(3),
            child: Container(
              height: 7,width: 7,
              decoration: BoxDecoration(
                  color: success,
                  shape: BoxShape.circle
              ),
              padding: EdgeInsets.all(2),
            ),
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Stack(
          children: [
            Container(
              height: size.width * .08,
              width: size.width * .08,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: Theme.of(context).scaffoldBackgroundColor,
                image: DecorationImage(
                  image: AssetImage(
                    activity.image,
                  ),
                ),
              ),
            ),
            Positioned(bottom:0,right: 0,child: statusIndicator())
          ],
        ),
        title: Text(
          activity.username,
          style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor.withOpacity(.8),
              fontWeight: FontWeight.w500,
              fontSize: size.width*.035),
        ),
        subtitle: Row(
          children: [
            Image.asset(
              activity.gameType == 0
                  ? 'assets/images/anagram.png'
                  : 'assets/images/tictactoe.png',
              height: size.width*.03,
              width: size.width*.03,
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              activity.gameType == 1 ? 'Anagram' : 'Tic-Tac-Toe',
              style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor.withOpacity(.6),
                  fontWeight: FontWeight.w100,
                  fontSize: size.width*.029),
            )
          ],
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text(
              activity.date,
              style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor.withOpacity(.5),
                  fontWeight: FontWeight.w300,
                  fontSize: size.width*.026),
            ),
            Visibility(
              visible: activity.unseenCount>0,
              child: Container(
               margin: EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: success),
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  '${activity.unseenCount}',
                  style: TextStyle(
                      color: white,
                      fontSize: size.width * .027),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

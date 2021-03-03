import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weave/Controllers/user_controller.dart';
import 'package:weave/Models/activity.dart';
import 'package:weave/Models/user.dart';
import 'package:weave/Util/colors.dart';
import 'package:weave/Util/helper_functions.dart';

class ActivityLayout extends StatefulWidget {
  final Activity activity;

  const ActivityLayout({Key key, this.activity}) : super(key: key);

  @override
  _ActivityLayoutState createState() => _ActivityLayoutState();
}

class _ActivityLayoutState extends State<ActivityLayout> with AutomaticKeepAliveClientMixin{
  User opponent;
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startOpponentStream();
  }

  startOpponentStream(){
    print(widget.activity.opponentId);
    UserController().userStream(widget.activity.opponentId).listen((event) {
      setState(() {
        opponent = User.fromMap(event.data())..id=event.id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    // Widget statusIndicator(){
    //   return Visibility(
    //     visible: activity.status!=0,
    //     child: Material(
    //       color: Theme.of(context).scaffoldBackgroundColor,
    //       borderRadius: BorderRadius.circular(10),
    //       child: Container(
    //         decoration: BoxDecoration(
    //           color: Theme.of(context).backgroundColor.withOpacity(.2),
    //           shape: BoxShape.circle
    //         ),
    //         padding: EdgeInsets.all(3),
    //         child: Container(
    //           height: 7,width: 7,
    //           decoration: BoxDecoration(
    //               color: success,
    //               shape: BoxShape.circle
    //           ),
    //           padding: EdgeInsets.all(2),
    //         ),
    //       ),
    //     ),
    //   );
    // }
    String date = DateFormat('dd MMM, yy').format(
        DateTime.fromMillisecondsSinceEpoch(
            widget.activity.timestamp.millisecondsSinceEpoch));

    return InkWell(
      onTap: ()=>Navigator.pushNamed(context, 'playArea', arguments: widget.activity),
      child: Container(
        margin: EdgeInsets.only(bottom: 10,right: 6,left: 6),
        decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor.withOpacity(.2),
            borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          leading: Stack(
            children: [
              Container(
                height: size.width * .08,
                width: size.width * .08,
                decoration: BoxDecoration(
                  //borderRadius: BorderRadius.circular(15),
                  shape: BoxShape.circle,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/user_dummies/img${1+Random().nextInt(7)}.jpg',
                    ),
                  ),
                ),
              ),
              //Positioned(bottom:0,right: 0,child: statusIndicator())
            ],
          ),
          title: Text(
            opponent==null?'...':'@${opponent.username}',
            style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor.withOpacity(.8),
                fontWeight: FontWeight.w500,
                fontSize: size.width*.035),
          ),
          subtitle: gameTypeWidget(type: widget.activity.gameType,size: size.width*.03,context: context),
          trailing: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(
                date,
                style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor.withOpacity(.5),
                    fontWeight: FontWeight.w300,
                    fontSize: size.width*.026),
              ),
              Visibility(
                visible: widget.activity.unreadChat>0,
                child: Container(
                 margin: EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: success),
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    '${widget.activity.unreadChat}',
                    style: TextStyle(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        fontSize: size.width * .027),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

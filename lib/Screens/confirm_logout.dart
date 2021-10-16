import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:weave/Controllers/current_user_controller.dart';
import 'package:weave/Controllers/streams_controller.dart';
import 'package:weave/Controllers/user_controller.dart';
import 'package:weave/Models/invite.dart';
import 'package:weave/Models/user.dart';
import 'package:weave/Screens/select_user.dart';
import 'package:weave/Util/colors.dart';
import 'package:weave/Util/helper_functions.dart';
import 'package:flutter_riverpod/all.dart';

class ConfirmLogout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    spacer() => SizedBox(
          height: height * .05,
        );
    spacer2() => SizedBox(
          height: height * .03,
        );

    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: width * .07, vertical: height * .04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Logout',
                  style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                      fontWeight: FontWeight.bold,
                      fontSize: width * .06)),
              IconButton(
                  icon: Icon(
                    Icons.close,
                    color: lightGrey,
                    size: width * .04,
                  ),
                  onPressed: () => Navigator.pop(context)),
            ],
          ),
          spacer2(),
          Text('Are you sure you want to logout?',
              style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: width * .035)),
          spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FlatButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    'cancel',
                    style: TextStyle(
                        color: Theme.of(context)
                            .secondaryHeaderColor
                            .withOpacity(.5)),
                  )),
              FlatButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(
                    'logout',
                    style: TextStyle(color: error),
                  ))
            ],
          )
        ],
      ),
    );
  }
}

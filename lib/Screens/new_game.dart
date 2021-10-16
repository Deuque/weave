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

class NewGame extends StatefulWidget {
  @override
  _NewGameState createState() => _NewGameState();
}

class _NewGameState extends State<NewGame> {
  int gameType = 0;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery
        .of(context)
        .size
        .height;
    final width = MediaQuery
        .of(context)
        .size
        .width;

    spacer() =>
        SizedBox(
          height: height * .05,
        );
    spacer2() =>
        SizedBox(
          height: height * .03,
        );


    return Container(
      padding:
      EdgeInsets.symmetric(horizontal: width * .07, vertical: height * .04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('New game',
                  style: TextStyle(
                      color: Theme
                          .of(context)
                          .secondaryHeaderColor,
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
          spacer(),
          customFieldIdentifier(
              label: 'Game type',
              context: context,
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 7.0),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      isExpanded: true,
                      items: [0, 1]
                          .map((e) =>
                          DropdownMenuItem<int>(
                            value: e,
                            child: gameTypeWidget(
                                type: e, size: width * .033, context: context),
                          ))
                          .toList(),
                      value: gameType,
                      onChanged: (val) => setState(() => gameType = val),
                    )),
              )),
          spacer2(),
          actionButton('CONTINUE', true, false, ()=>Navigator.pop(context,gameType), context),
        ],
      ),
    );
  }
}

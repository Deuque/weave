import 'package:flutter/material.dart';
import 'package:weave/Models/user.dart';
import 'package:weave/Util/colors.dart';
import 'package:weave/Util/helper_functions.dart';

class NewGame extends StatefulWidget {
  @override
  _NewGameState createState() => _NewGameState();
}

class _NewGameState extends State<NewGame> {
  int gameType=0;
  List<User> invitees = [];

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
          EdgeInsets.symmetric(horizontal: width * .07, vertical: width * .08),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Start a game',
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
          spacer(),
          customFieldIdentifier(
              label: 'Game type',
              context: context,
              enablePadding: true,padding: 10,
              child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    isExpanded: true,
                items: [0, 1]
                    .map((e) => DropdownMenuItem<int>(
                          value: e,
                          child: gameTypeWidget(
                              type: e, size: width * .033, context: context),
                        ))
                    .toList(),
                value: gameType,
                onChanged: (val) => setState(() => gameType = val),
              ))),
          spacer2(),
          actionButton('SEND INVITE', true, () {}, context),
        ],
      ),
    );
  }
}

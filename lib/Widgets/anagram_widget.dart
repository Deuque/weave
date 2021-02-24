import 'package:flutter/material.dart';
import 'package:weave/Models/anagram_activity.dart';
import 'package:weave/Screens/scramble_word_anagram.dart';
import 'package:weave/Util/colors.dart';
import 'package:weave/Widgets/chat_clipper.dart';

class AnagramLayout extends StatefulWidget {
  final bool yourTurn;
  final AnagramActivity anagramActivity;
  final bool previousIsSameSender;

  const AnagramLayout(
      {Key key, this.anagramActivity, this.previousIsSameSender, this.yourTurn})
      : super(key: key);

  @override
  _AnagramLayoutState createState() => _AnagramLayoutState();
}

class _AnagramLayoutState extends State<AnagramLayout> {
  bool userIsSender;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userIsSender = widget.anagramActivity.userIsSender;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget widgetsBackground(child) => Container(
        width: size.width * .7,
        alignment: userIsSender ? Alignment.centerRight : Alignment.centerLeft,
        margin: EdgeInsets.only(
            top: widget.previousIsSameSender ? 0 : 10,
            bottom: 2,
            left: 10,
            right: 10),
        child: CustomPaint(
          painter: ChatClipperPainter(
              leftSide: !userIsSender,
              clip: !widget.previousIsSameSender,
              shadowColor: userIsSender ? primary : accentColor),
          child: ClipPath(
            clipper: ChatClipper(
                leftSide: !userIsSender, clip: !widget.previousIsSameSender),
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Container(
                  padding: EdgeInsets.only(
                      top: 7,
                      bottom: 6,
                      right: userIsSender ? 23 : 10,
                      left: userIsSender ? 10 : 23),
                  color: lightGrey.withOpacity(.15),
                  child: child),
            ),
          ),
        ));

    Widget statusWidget() => Material(
          borderRadius: BorderRadius.circular(20),
          color: widget.anagramActivity.isCorrect ? success : error,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Icon(
              widget.anagramActivity.isCorrect ? Icons.check : Icons.close,
              size: 10,
              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(.7),
            ),
          ),
        );

    Widget yourTurnWidget() => widgetsBackground(
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: userIsSender
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              // Text(
              //   widget.anagramActivity.message,
              //   style: TextStyle(
              //       fontSize: 13,
              //       color: Theme.of(context)
              //           .secondaryHeaderColor
              //           .withOpacity(.4)),
              // ),
              SizedBox(
                height: 30,
                child: FlatButton(
                  onPressed: () => showModalBottomSheet(
                    isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(10))),
                      context: (context),
                      builder: (_) => ScrambleWord()),
                  shape: RoundedRectangleBorder(),
                  child: Text(
                    'PLAY',
                    style: TextStyle(
                        fontSize: 14, color: primary.withOpacity(.78)),
                  ),
                ),
              )
            ],
          ),
        );

    Widget activityWidget() => widgetsBackground(Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              userIsSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (userIsSender) statusWidget(),
                if (userIsSender)
                  SizedBox(
                    width: 7,
                  ),
                Text(
                  widget.anagramActivity.time,
                  style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context)
                          .secondaryHeaderColor
                          .withOpacity(.4)),
                ),
                if (!userIsSender)
                  SizedBox(
                    width: 7,
                  ),
                if (!userIsSender) statusWidget()
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              widget.anagramActivity.message,
              style: TextStyle(
                  fontSize: 14,
                  color:
                      Theme.of(context).secondaryHeaderColor.withOpacity(.68)),
            ),
          ],
        ));

    return widget.yourTurn ? yourTurnWidget() : activityWidget();
  }
}

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weave/Controllers/current_user_controller.dart';
import 'package:weave/Controllers/user_controller.dart';
import 'package:weave/Models/anagram_activity.dart';
import 'package:weave/Screens/guess_word_anagram.dart';
import 'package:weave/Screens/scramble_word_anagram.dart';
import 'package:weave/Util/colors.dart';
import 'package:weave/Widgets/chat_clipper.dart';
import 'package:flutter_riverpod/all.dart';

class AnagramLayout extends StatefulWidget {
  final bool yourTurn;
  final AnagramActivity anagramActivity;
  final bool previousIsSameSender;
  final Function(AnagramActivity x) onScrambleWord;
  final Function(String index, String answer) onGuessWord;

  const AnagramLayout(
      {Key key,
      this.anagramActivity,
      this.previousIsSameSender,
      this.yourTurn,
      this.onGuessWord,
      this.onScrambleWord})
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

    String time='';
    if(widget.anagramActivity.type!='play'){time = DateFormat('HH:mma')
        .format(DateTime.fromMillisecondsSinceEpoch(
        widget.anagramActivity.timestamp.millisecondsSinceEpoch));}

    Widget widgetsBackground({child}) => Container(
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
          color:
              widget.anagramActivity.isCorrect
                  ? success
                  : error,
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
          child: SizedBox(
            height: 30,
            child: !userIsSender?FlatButton(
              onPressed: null,
              child: Text(
                widget.anagramActivity.word,
                style: TextStyle(
                    fontSize: 14, color: Theme.of(context)
                    .secondaryHeaderColor
                    .withOpacity(.6)),
              ),
            ): FlatButton(
              onPressed: () => showModalBottomSheet(
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10))),
                  context: (context),
                  builder: (_) => ScrambleWord()).then((value) {
                if (value != null) {
                  String hint = value['hint'];
                  String word = value['word'];
                  String scrambledWord = value['scramble'];
                  // var dateTime = DateTime.now();
                  // String date = DateFormat('dd-MM-yy').format(dateTime);
                  // String time = DateFormat('HH:mm').format(dateTime);
                  AnagramActivity newActivity = AnagramActivity(
                      word: word,
                      scrambledWord: scrambledWord,
                      hint: hint,
                      timestamp: Timestamp.now(),
                      opponentAnswer: '',
                      answered: false,type: '1',seenByReceiver: false);

                  widget.onScrambleWord(newActivity);
                }
              }),
              shape: RoundedRectangleBorder(),
              child: Text(
                'PLAY',
                style: TextStyle(
                    fontSize: 14, color: primary.withOpacity(.78)),
              ),
            ),
          ),
        );

    Widget activityWidget() => widgetsBackground(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: userIsSender
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (userIsSender && widget.anagramActivity.answered) statusWidget(),
            if (userIsSender && widget.anagramActivity.answered)
              SizedBox(
                width: 7,
              ),
            Text(
              time,
              style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context)
                      .secondaryHeaderColor
                      .withOpacity(.4)),
            ),
            if (!userIsSender&& widget.anagramActivity.answered)
              SizedBox(
                width: 7,
              ),
            if (!userIsSender&& widget.anagramActivity.answered) statusWidget()
          ],
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          widget.anagramActivity.opponentAnswer.isEmpty?widget.anagramActivity.scrambledWord:widget.anagramActivity.opponentAnswer,
          style: TextStyle(
              fontSize: 15,
              letterSpacing: 2.8,
              color: Theme.of(context)
                  .secondaryHeaderColor
                  .withOpacity(.68)),
        ),
        if(!widget.anagramActivity.answered)
        SizedBox(height: 8,),
        if(!userIsSender && !widget.anagramActivity.answered)SizedBox(
          height: 34,
          child: FlatButton(
            onPressed: (){
              if(!widget.anagramActivity.answered){
                showModalBottomSheet(
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10))),
                    context: (context),
                    builder: (_) => GuessWord(
                      hint: widget.anagramActivity.hint,
                      word: widget.anagramActivity.scrambledWord,
                      answer: widget.anagramActivity.word,
                      image: 'assets/user_dummies/img3.jpg',
                    )).then((value){
                  if(value!=null){
                    String opponentAnswer = value['opponentAnswer'];
                    widget.onGuessWord(widget.anagramActivity.id, opponentAnswer);
                  }
                });
              }
            },
            shape: RoundedRectangleBorder(),
            child: Text(
              'ANSWER',
              style: TextStyle(
                  fontSize: 14, color: primary.withOpacity(.78)),
            ),
          ),
        )
      ],
    ));

    return widget.yourTurn ? yourTurnWidget() : activityWidget();
  }
}

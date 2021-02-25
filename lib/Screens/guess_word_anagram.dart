import 'package:flutter/material.dart';
import 'package:weave/Models/user.dart';
import 'package:weave/Screens/select_user.dart';
import 'package:weave/Util/colors.dart';
import 'package:weave/Util/helper_functions.dart';
import 'package:weave/Widgets/chat_clipper.dart';

class GuessWord extends StatefulWidget {
  final String image, word, hint, answer;

  const GuessWord({Key key, this.image, this.word, this.hint, this.answer})
      : super(key: key);

  @override
  _GuessWordState createState() => _GuessWordState();
}

class _GuessWordState extends State<GuessWord> {
  List<String> splitWord = [];
  List<String> answerSelections = [];
  List<Map<String, dynamic>> answers = [];
  Color answerColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splitWord = widget.word.split('');
    answerSelections = splitWord;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    spacer() => SizedBox(
          height: height * .04,
        );
    spacer2() => SizedBox(
          height: height * .03,
        );

    textBox(String text,
            {double textSize, Color textColor, Color containerColor}) =>
        AnimatedContainer(
          duration: Duration(milliseconds: 400),
          curve: Curves.easeIn,
          height: height * .045,
          width: height * .045,
          margin: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color:
                  containerColor !=null? containerColor.withOpacity(.09): Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).backgroundColor,
                    offset: Offset(-1.3, 1.3),
                    spreadRadius: 1.6,
                    blurRadius: 2)
              ]),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
                fontSize: textSize ?? height * .045 / 2.3,
                color: textColor ??
                    Theme.of(context).secondaryHeaderColor.withOpacity(.7)),
          ),
        );

    bool textIsInAnswers(int index) {
      bool isThere = false;
      for (final item in answers)
        if (item['index'] == index) {
          isThere = true;
          continue;
        }

      return isThere;
    }

    onFinishedSelecting() {
      if (answers.length == splitWord.length) {

        if (answers.map((e) => e['text']).toList().join('') == widget.answer) {
          setState(() {
            answerColor = success;
          });
        } else {
          setState(() {
            answerColor = error;
          });
          // Future.delayed(Duration(milliseconds: 350),
          //     () => setState(() => answerColor = null));
        }
      }
    }

    void addToAnswers(int index, String text) {
      if (!textIsInAnswers(index)) {
        answers.add({'index': index, 'text': text});
        setState(() {});
      }

      onFinishedSelecting();
    }

    void removeFromAnswers(Map<String, dynamic> answer) {
      answers.removeWhere((element) => element['index'] == answer['index']);
      if(answerColor!=null)answerColor=null;
      setState(() {});
    }

    List<Widget> answeredWidgets = List.generate(
        answers.length,
        (index) => GestureDetector(
            onTap: () => removeFromAnswers(answers[index]),
            child: textBox(answers[index]['text'],
                textColor: answerColor??accentColor,
                containerColor: answerColor)));

    List<Widget> unansweredWidgets = List.generate(
        splitWord.length - answers.length, (index) => textBox(''));

    List<Widget> selectionWidgets = List.generate(
        answerSelections.length,
        (index) => GestureDetector(
            onTap: () => addToAnswers(index, answerSelections[index]),
            child: textBox(
                textIsInAnswers(index) ? ' ' : answerSelections[index],
            )));

    return Container(
        padding: EdgeInsets.only(
            right: width * .07,
            left: width * .07,
            top: height * .04,
            bottom: height * .04 + MediaQuery.of(context).viewInsets.bottom),
        child: ListView(shrinkWrap: true, children: [
          Row(children: [
            Container(
              height: width * .07,
              width: width * .07,
              decoration: BoxDecoration(
                //borderRadius: BorderRadius.circular(15),
                shape: BoxShape.circle,
                color: Theme.of(context).scaffoldBackgroundColor,
                image: DecorationImage(
                    image: AssetImage(
                      widget.image,
                    ),
                    fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 7.0, left: 10),
              child: ClipPath(
                  clipper: ChatClipper(leftSide: true, clip: true),
                  child: Container(
                      padding: EdgeInsets.only(
                          top: 10, bottom: 10, right: 10, left: 23),
                      color: lightGrey.withOpacity(.15),
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: 'hint: ',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Theme.of(context)
                                      .secondaryHeaderColor
                                      .withOpacity(.4))),
                          TextSpan(
                              text: widget.hint,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context)
                                      .secondaryHeaderColor
                                      .withOpacity(.68))),
                        ]),
                      ))),
            ),
          ]),
          spacer2(),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 15,
            runSpacing: 8,
            children: [...answeredWidgets, ...unansweredWidgets],
          ),
          spacer2(),
          Divider(),
          spacer2(),
          Wrap(
            spacing: 15,
            runSpacing: 8,
            children: selectionWidgets,
          ),
          spacer2(),
          actionButton(
              'DONE', answers.length == splitWord.length, () {
                Navigator.pop(context,{'opponentAnswer': answers.map((e) => e['text']).toList().join('')});
          }, context),
        ]));
  }
}

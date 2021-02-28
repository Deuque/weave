import 'package:flutter/material.dart';
import 'package:weave/Models/user.dart';
import 'package:weave/Screens/select_user.dart';
import 'package:weave/Util/colors.dart';
import 'package:weave/Util/helper_functions.dart';

class ScrambleWord extends StatefulWidget {
  @override
  _ScrambleWordState createState() => _ScrambleWordState();
}

class _ScrambleWordState extends State<ScrambleWord> {
  TextEditingController wordController = new TextEditingController();
  TextEditingController hintController = new TextEditingController();
  bool textEntered = false;
  bool scrambled = false;
  String scrambledWord = '';

  @override
  void initState() {
    super.initState();
    // wordController.addListener(() {
    //   if (wordController.text.isNotEmpty && !textEntered) {
    //     setState(() {
    //       textEntered = true;
    //     });
    //   }
    //   if (wordController.text.isEmpty && textEntered) {
    //     setState(() {
    //       textEntered = false;
    //     });
    //   }
    // });
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

    return Container(
      padding:
          EdgeInsets.only(right:width * .07,left: width * .07, top: height * .04,bottom:height*.04+MediaQuery.of(context).viewInsets.bottom),
      child: ListView(
        shrinkWrap: true,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Scramble a word',
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
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: MyTextField(
                  label: 'Word',
                  hint: 'Weave',
                  controller: wordController,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              IconButton(
                  icon: IconButton(
                      icon: Image.asset(
                        'assets/images/shuffle.png',
                        height: 13,
                        color: Theme.of(context)
                            .secondaryHeaderColor
                            .withOpacity(.68),
                      ),
                      onPressed: () {
                        if(wordController.value.text.isEmpty)return;
                        setState(() {
                          var wordStyle =  wordController.value.text.trim().split(' ');
                          List<String> shuffledList = wordStyle[0].split('');
                          shuffledList.shuffle();
                          scrambledWord = shuffledList.join('');
                          scrambled=true;
                        });
                      }),
                  onPressed: null)
            ],
          ),
          spacer2(),
          MyTextField(
            label: 'Hint',
            hint: 'Optional',
            controller: hintController,
          ),
          spacer2(),
          Text(
            scrambledWord,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,

                letterSpacing: 4,
                color: accentColor),
          ),
          if(scrambled)
            spacer2(),
          actionButton('DONE', scrambled,false, () {
            Navigator.pop(context,{'hint': hintController.value.text.trim(), 'word': wordController.value.text.trim(), 'scramble':scrambledWord});
          }, context),
        ],
      ),
    );
  }
}

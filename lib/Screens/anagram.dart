import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:weave/Models/anagram_activity.dart';
import 'package:weave/Models/message.dart';
import 'package:weave/Util/colors.dart';
import 'package:weave/Util/helper_functions.dart';
import 'package:weave/Widgets/anagram_widget.dart';
import 'package:weave/Widgets/chat_widget.dart';

class Anagram extends StatelessWidget {
  final Function onFullScreen;

  const Anagram({Key key, this.onFullScreen}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if(!sampleAnagrams.last.userIsSender && sampleAnagrams.last.answered){
      sampleAnagrams.add(AnagramActivity(userIsSender: true,message: 'Hey, its your turn',date: sampleAnagrams.last.date));
    }

    Widget actionBar()=>Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: gameTypeWidget(type: 1, size: width*.035, context: context),
              ),
              Spacer(),
              IconButton(icon: Image.asset('assets/images/refresh.png',height: 14,color: Theme.of(context).secondaryHeaderColor.withOpacity(.6),), onPressed: (){}),
              IconButton(icon: Image.asset('assets/images/full_screen.png',height: 14,color: Theme.of(context).secondaryHeaderColor.withOpacity(.6),), onPressed: onFullScreen)
            ],
          ),
          Divider(height: 0,),
        ],
      ),
    );
    return Column(
      children: [
        actionBar(),
        SizedBox(height: 4,),
        Expanded(
          child: GroupedListView<AnagramActivity, String>(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            elements: sampleAnagrams,
            groupBy: (element) => element.date,
            groupSeparatorBuilder: (String groupByValue) => Align(
              alignment: Alignment.topCenter,
              child: Material(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).scaffoldBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      groupByValue,
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 12,
                          color: lightGrey.withOpacity(.5)),
                    ),
                  )),
            ),
            itemBuilder: (context, AnagramActivity element) => AnagramLayout(
              yourTurn: element.time == null,
              anagramActivity: element,
              previousIsSameSender: element.time == null ? false : sampleAnagrams.indexOf(element) != 0
                  ? sampleAnagrams[sampleAnagrams.indexOf(element) - 1]
                          .userIsSender ==
                      element.userIsSender && sampleAnagrams[sampleAnagrams.indexOf(element) - 1].date==element.date
                  : false,
            ),
            useStickyGroupSeparators: true,
            floatingHeader: true,
          ),
        ),

      ],
    );
  }
}


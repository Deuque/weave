import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:weave/Controllers/current_user_controller.dart';
import 'package:weave/Controllers/user_controller.dart';
import 'package:weave/Models/anagram_activity.dart';
import 'package:weave/Models/game.dart';
import 'package:weave/Models/invite.dart';
import 'package:weave/Models/message.dart';
import 'package:weave/Models/user.dart';
import 'package:weave/Util/colors.dart';
import 'package:weave/Util/helper_functions.dart';
import 'package:weave/Widgets/anagram_widget.dart';
import 'package:weave/Widgets/chat_widget.dart';
import 'package:flutter_riverpod/all.dart';

class Anagram extends StatelessWidget {
  final User opponent;
  final Invite invite;
  final List<AnagramActivity> anagrams;
  final Game game;
  final Function onFullScreen,onRestartGame;

  const Anagram({Key key, this.onFullScreen, this.opponent, this.game,this.invite,this.anagrams,this.onRestartGame}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // if ((anagrams.isEmpty &&
    //         widget.game.starter == context.read(userProvider.state).id) ||
    //     (!anagrams.last.userIsSender && anagrams.last.answered)) {
    //   anagrams.add(AnagramActivity(
    //       userIsSender: true,
    //       type: 'play',
    //       date: anagrams.isEmpty ? 'Today' : anagrams.last.date));
    // }


    if ((anagrams.isEmpty && invite.sender== context.read(userProvider.state).id) || (!anagrams.isEmpty && !anagrams[0].userIsSender && anagrams[0].answered)) {
      anagrams.removeWhere((element) => element.type=='play');
      anagrams.insert(0,AnagramActivity(
          userIsSender: true,
          type: 'play',
          date: anagrams.isEmpty ? 'Today' : anagrams.last.date));
    }else if(anagrams.isEmpty && invite.sender!= context.read(userProvider.state).id){
      anagrams.insert(0,AnagramActivity(
          userIsSender: false,
          type: 'play',
          word: 'Waiting for @${opponent.username} to start',
          date: anagrams.isEmpty ? 'Today' : anagrams.last.date));
    }

    onScrambleWord(AnagramActivity activity) async {
      //anagrams.removeWhere((element) => element.type=='play');
        activity.sender=context.read(userProvider.state).id;
        activity.index = anagrams.length;
        activity.parties = invite.parties;
        UserController().addAnagramGame(activity.toJson());
    }

    onGuessWord(String id, String answer) {
      AnagramActivity activity = anagrams.firstWhere((element) => element.id==id);
      activity.opponentAnswer=answer;
      activity.answered=true;

      UserController().editAnagramGame(activity.toJson());
    }

    Widget actionBar() => Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: gameTypeWidget(
                        type: 1, size: width * .035, context: context),
                  ),
                  Spacer(),
                  IconButton(
                      icon: Image.asset(
                        'assets/images/refresh.png',
                        height: 14,
                        color: Theme.of(context)
                            .secondaryHeaderColor
                            .withOpacity(.6),
                      ),
                      onPressed: onRestartGame),
                  IconButton(
                      icon: Image.asset(
                        'assets/images/full_screen.png',
                        height: 14,
                        color: Theme.of(context)
                            .secondaryHeaderColor
                            .withOpacity(.6),
                      ),
                      onPressed: onFullScreen)
                ],
              ),
              Divider(
                height: 0,
              ),
            ],
          ),
        );
    return Column(
      children: [
        actionBar(),
        SizedBox(
          height: 4,
        ),
        Expanded(
          child: GroupedListView<AnagramActivity, String>(
            sort: false,
            order: GroupedListOrder.DESC,
            reverse: true,
            padding: EdgeInsets.only(bottom: 15),
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            elements: anagrams,
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
              yourTurn: element.type == 'play',
              anagramActivity: element,
              previousIsSameSender: element.type == 'play'
                  ? false
                  : anagrams.indexOf(element) != 0
                      ? anagrams[anagrams.indexOf(element) - 1].userIsSender ==
                              element.userIsSender &&
                          anagrams[anagrams.indexOf(element) - 1].date ==
                              element.date
                      : false,
              onGuessWord: onGuessWord,
              onScrambleWord: onScrambleWord,
            ),
            // useStickyGroupSeparators: true,
            // floatingHeader: true,
          ),
        ),
      ],
    );
  }
}

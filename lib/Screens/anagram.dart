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
import 'package:weave/Util/colors.dart';
import 'package:weave/Util/helper_functions.dart';
import 'package:weave/Widgets/anagram_widget.dart';
import 'package:weave/Widgets/chat_widget.dart';
import 'package:flutter_riverpod/all.dart';

class Anagram extends StatefulWidget {
  final Invite invite;
  final List<AnagramActivity> anagramActivities;
  final Game game;
  final Function onFullScreen;

  const Anagram({Key key, this.onFullScreen, this.game,this.invite,this.anagramActivities}) : super(key: key);

  @override
  _AnagramState createState() => _AnagramState();
}

class _AnagramState extends State<Anagram> {
  List<AnagramActivity> anagrams = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    anagrams = widget.game.plays.map((e) {
      return AnagramActivity.fromMap(e)
        ..date = dateFormat2(DateTime.fromMillisecondsSinceEpoch(
            (e['timestamp'] as Timestamp).millisecondsSinceEpoch))
        ..userIsSender = e['sender'] == context.read(userProvider.state).id;
    }).toList();
  }

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


    if (widget.game.toPlay == context.read(userProvider.state).id && (anagrams.isEmpty || anagrams[anagrams.length-1].answered == true)) {
      anagrams.removeWhere((element) => element.type=='play');
      anagrams.add(AnagramActivity(
          userIsSender: true,
          type: 'play',
          date: anagrams.isEmpty ? 'Today' : anagrams.last.date));
    }

    onScrambleWord(AnagramActivity activity) async {
      anagrams.removeWhere((element) => element.type=='play');
        anagrams.add(activity..sender=context.read(userProvider.state).id);
      Game game = widget.game
        ..toPlay = widget.game.parties.firstWhere(
            (element) => element != context.read(userProvider.state).id)
        ..plays = anagrams.map((e) => e.toJson()).toList()
        ..seenLastPlay = false
        ..timestamp = Timestamp.now();

      game.id != null && game.id.isNotEmpty
          ? UserController().editGame(game)
          : UserController().addGame(game);
    }

    onGuessWord(String id, String answer) {
      anagrams = [
        for (final item in anagrams)
          if (item.id == id)
            item
              ..answered = true
              ..opponentAnswer = answer
              ..isCorrect = answer == item.word
          else if (item.type != 'play')
            item
      ];
      Game game = widget.game
        ..plays = anagrams.map((e) => e.toJson()).toList()
        ..seenLastPlay = false
        ..timestamp = Timestamp.now();

      UserController().editGame(game);
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
                      onPressed: () {}),
                  IconButton(
                      icon: Image.asset(
                        'assets/images/full_screen.png',
                        height: 14,
                        color: Theme.of(context)
                            .secondaryHeaderColor
                            .withOpacity(.6),
                      ),
                      onPressed: widget.onFullScreen)
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
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
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
            useStickyGroupSeparators: true,
            floatingHeader: true,
          ),
        ),
      ],
    );
  }
}

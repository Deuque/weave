import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:intl/intl.dart';
import 'package:weave/Controllers/current_user_controller.dart';
import 'package:weave/Controllers/streams_controller.dart';
import 'package:weave/Models/activity.dart';
import 'package:weave/Models/anagram_activity.dart';
import 'package:weave/Models/game.dart';
import 'package:weave/Models/invite.dart';
import 'package:weave/Models/message.dart';
import 'package:weave/Models/tictactoe_activity.dart';
import 'package:weave/Models/user.dart';
import 'package:weave/Screens/anagram.dart';
import 'package:weave/Screens/chat.dart';
import 'package:weave/Screens/tictactoe.dart';
import 'package:weave/Util/colors.dart';
import 'package:weave/Util/helper_functions.dart';

class PlayArea extends StatefulWidget {
  final Activity activity;

  PlayArea({Key key, this.activity}) : super(key: key);

  @override
  _PlayAreaState createState() => _PlayAreaState();
}

class _PlayAreaState extends State<PlayArea>
    with SingleTickerProviderStateMixin {
  int currentTab = 0;
  PageController pageController = new PageController();
  AnimationController controller;
  Animation<double> opacityAnimation;
  bool fullScreen = false;
  StreamController<int> unreadMessages = new StreamController();
  StreamController<int> unreadGameTurn = new StreamController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // controller =
    //     AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    // opacityAnimation = Tween<double>(begin: 1, end: 0)
    //     .animate(CurvedAnimation(parent: controller, curve: Curves.ease));
    //
    // controller.addListener(() {
    //   setState(() {
    //
    //   });
    // });
    unreadMessages.sink.add(0);
    unreadGameTurn.sink.add(0);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    unreadMessages?.close();
    unreadGameTurn?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;

    bool showFullscreen = currentTab == 1 && fullScreen;

    Widget tabsUnreadCount({Color color, int count}) =>
        Visibility(
          visible: count != 0,
          child: Container(
            margin: EdgeInsets.only(left: 5),
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            padding: const EdgeInsets.all(4.0),
            child: Text(
              '$count',
              style: TextStyle(
                  color: Theme
                      .of(context)
                      .scaffoldBackgroundColor,
                  fontSize: size.width * .028),
            ),
          ),
        );

    Widget tabControls() =>
        AnimatedContainer(
          height: !showFullscreen ? size.width * .1 : 0,
          duration: Duration(milliseconds: 700),
          curve: Curves.ease,
          padding: const EdgeInsets.all(1.5),
          margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            color: Theme
                .of(context)
                .backgroundColor
                .withOpacity(.3),
          ),
          child: Stack(
            children: [
              Row(
                children: [
                  {
                    'title': 'Chat',
                    'unseen': unreadMessages.stream,
                    'active': currentTab == 0,
                    'onPressed': () {
                      // setState(() => currentTab = 0);
                      pageController.animateToPage(
                        0,
                        curve: Curves.easeInOutCirc,
                        duration: Duration(milliseconds: 400),
                      );
                    }
                  },
                  {
                    'title': 'Game',
                    'unseen': unreadGameTurn.stream,
                    'active': currentTab == 1,
                    'onPressed': () {
                      //setState(() => currentTab = 1);
                      pageController.animateToPage(
                        1,
                        curve: Curves.easeInOutCirc,
                        duration: Duration(milliseconds: 400),
                      );
                    }
                  }
                ]
                    .map((e) =>
                    Expanded(
                      child: GestureDetector(
                        onTap: e['onPressed'],
                        child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          alignment: Alignment.center,
                          color: Colors.transparent,
                          child: StreamBuilder<int>(
                              stream: e['unseen'],
                              builder: (context, snapshot) {
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      e['title'],
                                      style: TextStyle(
                                          color: Theme
                                              .of(context)
                                              .secondaryHeaderColor
                                              .withOpacity(.3),
                                          fontWeight: FontWeight.w500,
                                          fontSize: size.width * .036),
                                    ),
                                    tabsUnreadCount(
                                        color: Theme
                                            .of(context)
                                            .secondaryHeaderColor
                                            .withOpacity(.3),
                                        count: snapshot.data ?? 0)
                                  ],
                                );
                              }),
                        ),
                      ),
                    ))
                    .toList(),
              ),
              AnimatedAlign(
                alignment: currentTab == 0
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                curve: Curves.ease,
                duration: Duration(milliseconds: 400),
                child: Container(
                  width: (size.width - 30) / 2,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      color: Theme
                          .of(context)
                          .scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(11)),
                  alignment: Alignment.center,
                  child: Text(
                    currentTab == 0 ? 'Chat' : 'Game',
                    style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.w500,
                        fontSize: size.width * .037),
                  ),
                ),
              )
            ],
          ),
        );

    return WillPopScope(
      onWillPop: () async {
        if (fullScreen) {
          setState(() {
            fullScreen = false;
          });
          return Future.value(false);
        } else
          return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: !showFullscreen ? null : 0,
          leading: backButton(
              onPressed: () => Navigator.pop(context),
              color: Theme
                  .of(context)
                  .secondaryHeaderColor
                  .withOpacity(.8)),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: size.width * .05,
                width: size.width * .05,
                decoration: BoxDecoration(
                  //borderRadius: BorderRadius.circular(15),
                  shape: BoxShape.circle,
                  color: Theme
                      .of(context)
                      .scaffoldBackgroundColor,
                  image: DecorationImage(
                      image: AssetImage(
                        'assets/user_dummies/img${1 + Random().nextInt(7)}.jpg',
                      ),
                      fit: BoxFit.cover),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                '@${widget.activity.opponent.username}',
                style: TextStyle(
                    color:
                    Theme
                        .of(context)
                        .secondaryHeaderColor
                        .withOpacity(.8),
                    fontWeight: FontWeight.w500,
                    fontSize: size.width * .035),
              ),
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: RotatedBox(
                  quarterTurns: 1,
                  child: Image.asset(
                    'assets/images/more.png',
                    height: 15,
                    color:
                    Theme
                        .of(context)
                        .secondaryHeaderColor
                        .withOpacity(.8),
                  ),
                ))
          ],
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
          children: [
            tabControls(),
            Expanded(
                child: PageView(
                  controller: pageController,
                  onPageChanged: (int page) =>
                      setState(() => currentTab = page),
                  children: [
                    Consumer(builder: (context, watch, _) {

                      //setup game stream count, since this is the first tab
                      Invite invite = context
                          .read(userStreamsProvider)
                          .myInvites
                          .firstWhere((element) =>
                      element.parties.contains(
                          widget.activity.opponentId) && element.accepted==true);
                      if(invite.gameType==1) {
                        List<AnagramActivity> games = watch(userStreamsProvider)
                            .myAnagramGames;
                          games = games
                              .where((element) =>
                              element.parties.contains(
                                  widget.activity.opponentId))
                              .toList();
                          games.sort((a, b) =>
                              b.index.compareTo(a.index));

                          if (games.isNotEmpty) {
                            if (games[0].sender !=
                                context
                                    .read(userProvider.state)
                                    .id &&
                                !games[0].seenByReceiver) {
                              unreadGameTurn.sink.add(1);
                            }
                          }

                      }else{
                        List<TictactoeActivity> games = watch(userStreamsProvider)
                            .myTttGames;
                        games = games
                            .where((element) =>
                            element.parties.contains(
                                widget.activity.opponentId))
                            .toList();
                        games.sort((a, b) =>
                            b.index.compareTo(a.index));

                        if (games.isNotEmpty) {
                          if (games[0].sender !=
                              context
                                  .read(userProvider.state)
                                  .id &&
                              !games[0].seenByReceiver) {
                            unreadGameTurn.sink.add(1);
                          }
                        }
                      }




                      //setup chat stream
                      List<Message> messages =
                          watch(userStreamsProvider).myMessages;
                      messages = messages
                          .where((element) =>
                          element.parties.contains(widget.activity.opponentId))
                          .toList();
                      messages.sort((a, b) =>
                          b.timestamp.compareTo(a.timestamp));
                      messages.map((e) {
                        e.date = dateFormat2(
                            DateTime.fromMillisecondsSinceEpoch(
                                e.timestamp.millisecondsSinceEpoch));
                        e.time = DateFormat('HH:mma')
                            .format(DateTime.fromMillisecondsSinceEpoch(
                            e.timestamp.millisecondsSinceEpoch))
                            .toLowerCase();
                        e.userIsSender =
                            e.sender == context
                                .read(userProvider.state)
                                .id;
                      }).toList();

                      int unread = messages
                          .where((element) =>
                      element.receiver ==
                          context
                              .read(userProvider.state)
                              .id &&
                          !element.seenByReceiver)
                          .toList()
                          .length;
                      unreadMessages.sink.add(unread);

                      return Chat(
                        opponentId: widget.activity.opponentId,
                        messages: messages,
                      );
                    }),
                    Consumer(builder: (context, watch, _) {

                      Invite invite = context
                          .read(userStreamsProvider)
                          .myInvites
                          .firstWhere((element) =>
                      element.parties.contains(
                          widget.activity.opponentId) && element.accepted==true);
                      List<AnagramActivity> anagramGames = [];
                      List<TictactoeActivity> tttGames=[];
                      if(invite.gameType==1){
                        anagramGames=watch(userStreamsProvider).myAnagramGames;
                        anagramGames = anagramGames
                            .where((element) =>
                            element.parties.contains(widget.activity.opponentId))
                            .toList();
                        anagramGames.sort((a,b)=>b.index.compareTo(a.index));
                        anagramGames = anagramGames.map((e) {
                          return e
                            ..isCorrect=!e.answered?false:e.opponentAnswer==e.word
                            ..date = dateFormat2(DateTime.fromMillisecondsSinceEpoch(
                                e.timestamp.millisecondsSinceEpoch))
                            ..userIsSender = e.sender == context.read(userProvider.state).id;
                        }).toList();
                      }else{
                        tttGames = watch(userStreamsProvider)
                            .myTttGames;
                        tttGames = tttGames
                            .where((element) =>
                            element.parties.contains(
                                widget.activity.opponentId))
                            .toList();
                        tttGames.sort((a, b) =>
                            b.index.compareTo(a.index));

                      }




                      return widget.activity.gameType == 0
                          ? TicTacToe(
                        key: tttGames.isEmpty?Key('key'):Key(tttGames[0].sender),
                          invite: invite,
                          tictactoeActivity: tttGames.isEmpty?null:tttGames[0],
                          onFullScreen: () {
                        setState(() {
                          fullScreen = !fullScreen;
                        });
                      })
                          : Anagram(
                        //game: myGame,
                        anagrams: anagramGames,
                        invite: invite,
                        onFullScreen: () {
                          setState(() {
                            fullScreen = !fullScreen;
                          });
                        },
                      );
                    })
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

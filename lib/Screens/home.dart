import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weave/Controllers/current_user_controller.dart';
import 'package:weave/Controllers/streams_controller.dart';
import 'package:weave/Models/activity.dart';
import 'package:weave/Models/anagram_activity.dart';
import 'package:weave/Models/invite.dart';
import 'package:weave/Models/message.dart';
import 'package:weave/Models/tictactoe_activity.dart';
import 'package:weave/Models/user.dart';
import 'package:weave/Screens/select_user.dart';
import 'package:weave/Screens/send_invite.dart';
import 'package:weave/Util/colors.dart';
import 'package:weave/Util/helper_functions.dart';
import 'package:weave/Widgets/activity_widget.dart';
import 'package:weave/Widgets/custom_tab_bar.dart';
import 'package:weave/Widgets/invite_widget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int tabIndex = 0;
  TabController _controller;
  StreamController<int> unreadInvites = new StreamController();
  StreamController<int> unreadActivities = new StreamController();
  String playAreaNotificationData='';
  String playAreaNotificationStamp='';
  String inviteNotificationData='';

  void configureFirebase() {
    try {
      FirebaseMessaging _firebaseMessaging = FirebaseMessaging()
        ..requestNotificationPermissions(
            const IosNotificationSettings(sound: true, badge: true, alert: true));

      _firebaseMessaging.configure(
        onMessage: (message) async {

          print(message);
          // showNotification(message['notification']['title'],
          //     message['notification']['body']);
        },
        onLaunch: (message) async {
          if(message['data']['id'] == 'chat' || message['data']['id'] == 'game') {

              setState(() {
                playAreaNotificationData = message['data']['extraData'];
                playAreaNotificationStamp = message['data']['google.sent_time'].toString();
              });

          }else if(message['data']['id'] == 'invite'){

              setState(() {
                inviteNotificationData = message['data']['extraData'];
                //playAreaNotificationStamp = message['data']['google.sent_time'].toString();
              });
            // WidgetsBinding.instance.addPostFrameCallback((_) {
            //   _controller.animateTo(1,duration: Duration(milliseconds: 200),curve: Curves.easeIn);
            // });
          }
        },
        onResume: (message) async {

          if(message['data']['id'] == 'chat' || message['data']['id'] == 'game') {

              setState(() {
                playAreaNotificationData = message['data']['extraData'];
                playAreaNotificationStamp = message['data']['google.sent_time'].toString();
              });

          }else if(message['data']['id'] == 'invite'){

              setState(() {
                inviteNotificationData = message['data']['extraData'];
              });
            // WidgetsBinding.instance.addPostFrameCallback((_) {
            //   _controller.animateTo(1,duration: Duration(milliseconds: 200),curve: Curves.easeIn);
            // });
          }
        },
      );
      print('configured messaging successfully');
    } catch (e) {
      print('could not configure firebase messaging: ' + e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: 2);
    _controller.addListener(() {
      if (_controller.index != tabIndex)
        setState(() {
          tabIndex = _controller.index;
        });
    });

    unreadInvites.sink.add(0);
    unreadActivities.sink.add(0);
    configureFirebase();
  }

  @override
  void dispose() {
    unreadInvites?.close();
    unreadActivities?.close();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget userImage() => Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).backgroundColor,
                    offset: Offset(1.3, 1.3),
                    spreadRadius: 1.6,
                    blurRadius: 2)
              ]),
          child: profileImage(
              context.read(userProvider.state).photo, size.width * .06, context,
              radius: 7),
        );

    Widget tabsUnreadCount({bool active, int count}) => Visibility(
          visible: count != 0,
          child: Container(
            margin: EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: active
                    ? primary
                    : Theme.of(context).secondaryHeaderColor.withOpacity(.3)),
            padding: const EdgeInsets.all(4.0),
            child: Text(
              '$count',
              style: TextStyle(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  //fontSize: size.width * .028
              ),
            ),
          ),
        );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          elevation: 0,
          leadingWidth: size.width * .5,
          leading: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 17.0),
                child: Text('Games',
                    style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontWeight: FontWeight.bold,
                        fontSize: size.width * .06)),
              )
              //child: logo(size: size.width * .06),
              ),
          actions: [
            Center(
                child: IconButton(
                    icon: Image.asset(
                      'assets/images/search.png',
                      height: size.width * .04,
                      color: Theme.of(context)
                          .secondaryHeaderColor
                          .withOpacity(.8),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        'selectUser',
                        arguments: [SelectUserType.single, <User>[], 'Find an opponent'],
                      ).then((value) {
                        if (value != null && (value as List).isNotEmpty) {
                          showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10))),
                              context: (context),
                              builder: (_) => SendInvite(
                                    invitees: value,
                                  ));
                        }
                      });
                    })),
            Center(
              child: IconButton(
                icon: userImage(),
                onPressed: () {},
              ),
            ),
            SizedBox(
              width: 10,
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabBar(
                isScrollable: true,

                // onTap: (index) {
                //   // Tab index when user select it, it start from zero
                //   setState(() {
                //     tabIndex = index;
                //   });
                // },
                controller: _controller,

                //indicatorPadding: EdgeInsets.all(10),
                labelPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),

                indicatorColor: Colors.transparent,

                // indicator: MD2Indicator(
                //   indicatorSize: MD2IndicatorSize.full,
                //   indicatorHeight: 3.0,
                //   indicatorColor: primary,
                // ),
                // labelColor: Theme.of(context).secondaryHeaderColor,
                // unselectedLabelColor:
                //     Theme.of(context).secondaryHeaderColor.withOpacity(.3),
                labelColor: Theme.of(context).primaryColor,

                unselectedLabelColor:
                    Theme.of(context).secondaryHeaderColor.withOpacity(.3),

                tabs: [
                  StreamBuilder<int>(
                      stream: unreadActivities.stream,
                      builder: (context, snapshot) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              right: 5.0, bottom: 8, top: 6),
                          child: Row(
                            children: [
                              Text(
                                'Ongoing',
                              ),
                              tabsUnreadCount(
                                  active: tabIndex == 0,
                                  count: snapshot?.data ?? 0)
                            ],
                          ),
                        );
                      }),
                  StreamBuilder<int>(
                      stream: unreadInvites.stream,
                      builder: (context, snapshot) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              right: 8.0, bottom: 8, top: 6),
                          child: Row(
                            children: [
                              Text(
                                'Invites',
                              ),
                              tabsUnreadCount(
                                  active: tabIndex == 1,
                                  count: snapshot?.data ?? 0)
                            ],
                          ),
                        );
                      }),
                ],
              ),
              Expanded(
                child: TabBarView(
                    physics: BouncingScrollPhysics(),
                    controller: _controller,
                    children: [
                      Consumer(builder: (context, watch, _) {
                        //stream of pending invites since this tab loads first
                        List<Invite> pendingInvites =
                            watch(userStreamsProvider).myInvites;
                        pendingInvites = pendingInvites
                            .where((element) => element.accepted == false)
                            .toList();
                        int unread = pendingInvites
                            .where((element) =>
                                !element.seenByReceiver &&
                                element.receiver ==
                                    context.read(userProvider.state).id)
                            .toList()
                            .length;
                        unreadInvites.sink.add(unread);

                        //stream of accepted invites
                        List<Invite> invites =
                            watch(userStreamsProvider).myInvites;
                        invites = invites
                            .where((element) => element.accepted == true)
                            .toList();

                        List<Message> messages =
                            watch(userStreamsProvider).myMessages;
                        messages
                            .sort((b, a) => a.timestamp.compareTo(b.timestamp));

                        List<Activity> activities = [];

                        invites.forEach((element) {
                          String opponent = element.parties.firstWhere(
                              (element) =>
                                  element !=
                                  context.read(userProvider.state).id);
                          //get messages of activity
                          List<Message> activityMessages = messages
                              .where((element) =>
                                  element.parties.contains(opponent))
                              .toList();

                          int unreadMessages = activityMessages
                              .where((element) =>
                                  element.parties.contains(opponent) &&
                                  element.receiver ==
                                      context.read(userProvider.state).id &&
                                  !element.seenByReceiver)
                              .toList()
                              .length;

                          // get games of activity
                          int unreadGame = 0;
                          Timestamp gamestamp;
                          if (element.gameType == 1) {
                            List<AnagramActivity> anagramGames =
                                watch(userStreamsProvider).myAnagramGames;
                            anagramGames = anagramGames
                                .where((element) =>
                                    element.parties.contains(opponent))
                                .toList();
                            anagramGames
                                .sort((a, b) => b.index.compareTo(a.index));
                            unreadGame = anagramGames.isEmpty
                                ? 0
                                : anagramGames[0].sender !=
                                            context
                                                .read(userProvider.state)
                                                .id &&
                                        !anagramGames[0].seenByReceiver
                                    ? 1
                                    : 0;
                            gamestamp = anagramGames.isEmpty
                                ? null
                                : anagramGames[0].timestamp;
                          } else {
                            List<TictactoeActivity> tttGames =
                                watch(userStreamsProvider).myTttGames;
                            tttGames = tttGames
                                .where((element) =>
                                    element.parties.contains(opponent))
                                .toList();
                            tttGames.sort((a, b) => b.index.compareTo(a.index));
                            unreadGame = tttGames.isEmpty
                                ? 0
                                : tttGames[0].sender !=
                                            context
                                                .read(userProvider.state)
                                                .id &&
                                        !tttGames[0].seenByReceiver
                                    ? 1
                                    : 0;
                            gamestamp =
                                tttGames.isEmpty ? null : tttGames[0].timestamp;
                          }

                          //most recent time between invite and chat
                          int largestTime = activityMessages.isEmpty
                              ? element.timestamp.millisecondsSinceEpoch
                              : max(
                                  element.timestamp.millisecondsSinceEpoch,
                                  activityMessages[0]
                                      .timestamp
                                      .millisecondsSinceEpoch);

                          //most recent time between recent from above and game
                          largestTime = gamestamp == null
                              ? largestTime
                              : max(largestTime,
                                  gamestamp.millisecondsSinceEpoch);

                          Activity activity = Activity(
                              opponentId: opponent,
                              gameType: element.gameType,
                              unreadChat: unreadMessages + unreadGame,
                              timestamp: Timestamp.fromMillisecondsSinceEpoch(
                                  largestTime));
                          activities.add(activity);
                        });

                        activities
                            .sort((a,b) => b.timestamp.compareTo(a.timestamp));
                        unreadActivities.sink.add(activities.fold(
                            0,
                            (previousValue, element) =>
                                previousValue + element.unreadChat));
                        return TabBody(
                          items: activities,
                          tabIndex: 0,
                          notificationData: playAreaNotificationData,
                          notificationStamp: playAreaNotificationStamp,
                        );
                      }),
                      Consumer(builder: (context, watch, _) {
                        List<Invite> invites =
                            watch(userStreamsProvider).myInvites;
                        invites = invites
                            .where((element) => element.accepted == false)
                            .toList();
                        invites.sort((a,b)=>b.timestamp.compareTo(a.timestamp));
                        return TabBody(
                          items: invites,
                          tabIndex: 1,
                          notificationData: inviteNotificationData,
                        );
                      }),
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TabBody extends StatelessWidget {
  final String notificationData,notificationStamp;
  final List items;
  final int tabIndex;

  const TabBody({Key key, this.items, this.tabIndex,this.notificationData,this.notificationStamp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return items.isEmpty
        ? emptyWidget(image: 'assets/images/empty2.png', size: width * .2)
        : tabIndex == 0
            ? ListView(
      key: Key(items[0].timestamp.toString()),
                padding: EdgeInsets.only(top: 10),
                physics: BouncingScrollPhysics(),
                children: items
                    .map((e) => ActivityLayout(
                  notificationData: notificationData,
                          notificationStamp: notificationStamp,
                          activity: e,
                        ))
                    .toList(),
              )
            : ListView(
      key: Key(items[0].timestamp.toString()),
                padding: EdgeInsets.only(top: 10),
                physics: BouncingScrollPhysics(),
                children: items
                    .map((e) => InviteLayout(
                          invite: e,
                  currentUser: context.read(userProvider.state),
                        ))
                    .toList(),
              );
  }
}

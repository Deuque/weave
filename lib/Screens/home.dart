import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:weave/Models/activity.dart';
import 'package:weave/Models/invite.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget userImage() => Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: Theme.of(context).scaffoldBackgroundColor,
              image: DecorationImage(
                image: AssetImage(
                  'assets/user_dummies/img5.jpg',
                ),
              ),
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).backgroundColor,
                    offset: Offset(1.3, 1.3),
                    spreadRadius: 1.6,
                    blurRadius: 2)
              ]),
        );

    Widget tabsUnreadCount({bool active, int count}) => Visibility(
          visible: count != 0,
          child: Container(
            margin: EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: active
                    ? Theme.of(context).secondaryHeaderColor.withOpacity(.8)
                    : Theme.of(context).secondaryHeaderColor.withOpacity(.3)),
            padding: const EdgeInsets.all(4.0),
            child: Text(
              '$count',
              style: TextStyle(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  fontSize: size.width * .028),
            ),
          ),
        );





    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          elevation: 0,
          leadingWidth: 150,
          leading: Center(
            child: logo(size: size.width * .06),
          ),
          actions: [
            Center(
                child: IconButton(
              icon: Image.asset(
                'assets/images/search.png',
                height: size.width * .04,
                color: Theme.of(context).secondaryHeaderColor.withOpacity(.8),
              ),
              onPressed: () {},
            )),
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
          padding:
              EdgeInsets.symmetric(vertical: 2, horizontal: size.width * .05),
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
                indicatorPadding: EdgeInsets.all(10),

                indicatorSize: TabBarIndicatorSize.label,
                labelPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                indicator: MD2Indicator(
                  indicatorSize: MD2IndicatorSize.full,
                  indicatorHeight: 3.0,
                  indicatorColor: primary,
                ),
                labelColor: Theme.of(context).secondaryHeaderColor,
                unselectedLabelColor:
                    Theme.of(context).secondaryHeaderColor.withOpacity(.3),
                tabs: [
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 8.0, bottom: 8, top: 6),
                    child: Row(
                      children: [
                        Text(
                          'Ongoing',
                        ),
                        tabsUnreadCount(
                            active: tabIndex == 0,
                            count: sampleActivities
                                .map((e) => e.unseenCount)
                                .toList()
                                .fold(
                                    0,
                                    (previousValue, element) =>
                                        previousValue + element))
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 8.0, bottom: 8, top: 6),
                    child: Row(
                      children: [
                        Text(
                          'Invites',
                        ),
                        tabsUnreadCount(active: tabIndex == 1, count: 0)
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                    physics: BouncingScrollPhysics(),
                    controller: _controller,
                    children: [
                      TabBody(
                        items: sampleActivities,
                        tabIndex: 0,
                      ),
                      TabBody(
                        items: sampleInvites,
                        tabIndex: 1,
                      ),
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
  final List items;
  final int tabIndex;

  const TabBody({Key key, this.items, this.tabIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return tabIndex == 0
        ? ListView(
            padding: EdgeInsets.only(top: 18),
            physics: BouncingScrollPhysics(),
            children: items
                .map((e) => ActivityLayout(
                      activity: e,
                    ))
                .toList(),
          )
        :ListView(
      padding: EdgeInsets.only(top: 18),
      physics: BouncingScrollPhysics(),
      children: items
          .map((e) => InviteLayout(
        invite: e,
      ))
          .toList(),
    );
  }
}

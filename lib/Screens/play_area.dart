import 'package:flutter/material.dart';
import 'package:weave/Models/activity.dart';
import 'package:weave/Models/user.dart';
import 'package:weave/Screens/chat.dart';
import 'package:weave/Util/colors.dart';
import 'package:weave/Util/helper_functions.dart';

class PlayArea extends StatefulWidget {
  final Activity activity;

  const PlayArea({Key key, this.activity}) : super(key: key);

  @override
  _PlayAreaState createState() => _PlayAreaState();
}

class _PlayAreaState extends State<PlayArea> {
  int currentTab = 0;
  PageController controller = new PageController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget tabControls() => Container(
      height: size.width*.1,
      padding: const EdgeInsets.all(1.5),
      margin: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        color: Theme.of(context).backgroundColor.withOpacity(.3),
      ),
      child: Stack(
        children: [
          Row(

            children: [
              {
                'title': 'Chat',
                'active': currentTab==0,
                'onPressed': (){
                  setState(() => currentTab = 0);
                  controller.animateToPage(0,  curve: Curves.easeInOutCirc,
                    duration: Duration(milliseconds: 400),);
                }
              },
              {
                'title': 'Game',
                'active': currentTab==1,
                'onPressed': (){
                  setState(() => currentTab = 1);
                  controller.animateToPage(1,  curve: Curves.easeInOutCirc,
                    duration: Duration(milliseconds: 400),);
                }
              }
            ]
                .map((e) => Expanded(
                      child: GestureDetector(
                        onTap: e['onPressed'],
                        child: Container(
                          height: double.infinity,width: double.infinity,
                          alignment: Alignment.center,
                          color: Colors.transparent,
                          child: Text(
                            e['title'],
                            style: TextStyle(
                                color: Theme.of(context)
                                        .secondaryHeaderColor
                                        .withOpacity(.3),
                                fontWeight: FontWeight.w500,
                                fontSize: size.width * .036),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          AnimatedAlign(
            alignment: currentTab==0?Alignment.centerLeft:Alignment.centerRight,
            curve: Curves.easeInOutCirc,
            duration: Duration(milliseconds: 400),
            child: Container(
              width: (size.width-30)/2,
              height: double.infinity,
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(11)),
              alignment: Alignment.center,
              child: Text(
                currentTab==0?'Chat':'Game',
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

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: backButton(
            onPressed: () => Navigator.pop(context),
            color: Theme.of(context).secondaryHeaderColor.withOpacity(.8)),
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
                color: Theme.of(context).scaffoldBackgroundColor,
                image: DecorationImage(
                    image: AssetImage(
                      widget.activity.image,
                    ),
                    fit: BoxFit.cover),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              widget.activity.username,
              style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor.withOpacity(.8),
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
                  color: Theme.of(context).secondaryHeaderColor.withOpacity(.8),
                ),
              ))
        ],
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          tabControls(),
          Expanded(child: PageView(
            controller: controller,
            onPageChanged: (int page)=>setState(()=>currentTab=page),
            children: [
              Chat(),Chat()
            ],
          ))
        ],
      ),
    );
  }
}

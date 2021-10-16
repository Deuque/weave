import 'package:flutter/material.dart';
import 'package:weave/Util/colors.dart';
import 'package:weave/Widgets/onboarding_detail_item.dart';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  List<Map> detailItems = [];
  PageController controller = new PageController();
  bool isCompleted = false;
  int currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    detailItems = [
      {
        'image': 'assets/images/obd1.png',
        'title': 'Play games together',
        'subtitle':
            'Send invites to friends and have fun with interesting words and board games'
      },
      // {
      //   'image': 'assets/images/play_together.png',
      //   'title': 'Play with anyone',
      //   'subtitle': 'Send invites to any of your friends and battle it out'
      // },
      {
        'image': 'assets/images/obd2.png',
        'title': 'Have fun and Chat',
        'subtitle':
            'Send teasing messages to your opponent even as you have fun together'
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool isEnd = currentIndex == detailItems.length - 1;
    updateIndex(int index) {
      setState(() {
        currentIndex = index;
        controller.jumpToPage(index);
      });
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        //toolbarHeight: size.height * .02,
        leading: Visibility(
          visible: currentIndex != 0,
          child: IconButton(
            onPressed: () => updateIndex(currentIndex - 1),
            icon: Icon(
              Icons.arrow_back_ios_sharp,
              color: Theme.of(context).secondaryHeaderColor,
              size: 17,
            ),
          ),
        ),
        actions: [
          FlatButton(
            onPressed: isEnd
                ? () => Navigator.pushReplacementNamed(context, 'auth')
                : () => updateIndex(detailItems.length - 1),
            child: Text(
              isEnd ? 'CONTINUE' : 'SKIP',
              style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor.withOpacity(.8),
                  fontSize: 15),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(
            left: size.width * .08,
            right: size.width * .08,
            bottom: size.width * .1),
        child: Column(
          children: [
            Expanded(
                child: PageView(
              physics: BouncingScrollPhysics(),
              controller: controller,
              children: detailItems
                  .map((e) => DetailItem(
                        item: e,
                        down: detailItems.indexOf(e).isOdd,
                      ))
                  .toList(),
              onPageChanged: (int current) {
                setState(() {
                  currentIndex = current;
                  if (currentIndex == detailItems.length - 1 &&
                      isCompleted == false) {
                    isCompleted = true;
                  } else {
                    isCompleted = false;
                  }
                });
              },
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                      detailItems.length,
                      (index) => AnimatedContainer(
                            curve: Curves.easeIn,
                            duration: Duration(milliseconds: 400),
                            height: 6.6,
                            width: index == currentIndex ? 10 : 6.6,
                            margin: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                color: index == currentIndex
                                    ? accentColor
                                    : Theme.of(context)
                                        .secondaryHeaderColor
                                        .withOpacity(.2),
                                borderRadius: BorderRadius.circular(10)),
                          )),
                ),
                if(!isEnd)
                  GestureDetector(
                    onTap: () => updateIndex(
                        currentIndex == detailItems.length - 1
                            ? 0
                            : currentIndex + 1),
                    child: Container(
                      decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 3),
                                spreadRadius: 1,
                                blurRadius: 2,
                                color: Theme.of(context).backgroundColor)
                          ]),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      alignment: Alignment.center,
                      child: Text(
                        'Next',
                        style: TextStyle(
                            color: Colors.white.withOpacity(.8), fontSize: 13),
                      ),
                    ),
                  )
              ],
            ),
            // SizedBox(
            //   height: size.height * .06,
            // ),
            // AnimatedContainer(
            //   curve: Curves.easeIn,
            //   duration: Duration(milliseconds: 400),
            //   decoration: BoxDecoration(
            //     color: isCompleted?primary:Colors.transparent,
            //     borderRadius: BorderRadius.vertical(top: Radius.circular(10))
            //   ),
            //   child: isCompleted
            //       ? GestureDetector(
            //     onTap: ()=>Navigator.pushReplacementNamed(context, 'auth'),
            //         child: Container(
            //             height: size.width * .14,
            //     decoration: BoxDecoration(
            //           color: primary,
            //           borderRadius: BorderRadius.vertical(top: Radius.circular(10))
            //     ),
            //             alignment: Alignment.center,
            //             child: Text(
            //               'GET STARTED',
            //               style: TextStyle(color:Colors.white.withOpacity(.6), fontSize: 16),
            //             ),
            //           ),
            //       )
            //       : Padding(
            //           padding: const EdgeInsets.all(4.0),
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               FlatButton(
            //                 onPressed: ()=>updateIndex(detailItems.length-1),
            //                 child: Text(
            //                   'SKIP',
            //                   style: TextStyle(
            //                       color: Theme.of(context).secondaryHeaderColor.withOpacity(.8),
            //                       fontSize: 16),
            //                 ),
            //               ),
            //               FlatButton(
            //                 onPressed: ()=>updateIndex(currentIndex==detailItems.length-1?0:currentIndex+1),
            //                 child: Text(
            //                   'NEXT',
            //                   style: TextStyle(
            //                       color:  Theme.of(context).secondaryHeaderColor.withOpacity(.8),
            //                       fontSize: 16),
            //                 ),
            //               )
            //             ],
            //           ),
            //         ),
            // )
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:weave/Screens/Onboarding/detail_item.dart';
import 'package:weave/Util/colors.dart';

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
        'image': 'assets/images/img1.png',
        'title': 'Chat and Pay',
        'subtitle':
            'Create amazing memories during conversations and still be able to share funds with your friends and loved ones'
      },
      {
        'image': 'assets/images/img2.png',
        'title': 'Grow in Groups',
        'subtitle':
            'Set and fund contributions in multiple wallets as you make memories in wonderful and exciting groups'
      },
      {
        'image': 'assets/images/img3.png',
        'title': 'Relax and Do Business',
        'subtitle':
            'As a business owner, keep your bank details to yourself, have your customers fund your wallets quickly and easily '
      },
      {
        'image': 'assets/images/img5.png',
        'title': 'No Money No Problem',
        'subtitle':
            'Don\'t be scared to ask when your wallet runs dry, utilize the request money feature anytime any day'
      }
    ];
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    updateIndex(int index){
      setState(() {
        currentIndex = index;
        controller.jumpToPage(index);
      });
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: size.height * .02,
      ),
      body: Column(
        children: [
          Expanded(
              child: PageView(
                physics: BouncingScrollPhysics(),
            controller: controller,
            children: detailItems
                .map((e) => DetailItem(
                      item: e,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                detailItems.length,
                (index) => AnimatedContainer(
                      curve: Curves.easeIn,
                      duration: Duration(milliseconds: 400),
                      height: 6.6,
                      width: index == currentIndex ? 24 : 6.6,
                      margin: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          color: index == currentIndex
                              ? primary
                              : Theme.of(context).secondaryHeaderColor.withOpacity(.2),
                          borderRadius: BorderRadius.circular(10)),
                    )),
          ),
          SizedBox(
            height: size.height * .06,
          ),
          AnimatedContainer(
            curve: Curves.easeIn,
            duration: Duration(milliseconds: 400),
            decoration: BoxDecoration(
              color: isCompleted?primary:Colors.transparent,
              borderRadius: BorderRadius.vertical(top: Radius.circular(10))
            ),
            child: isCompleted
                ? GestureDetector(
              onTap: ()=>Navigator.pushReplacementNamed(context, 'auth'),
                  child: Container(
                      height: size.width * .14,
              decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(10))
              ),
                      alignment: Alignment.center,
                      child: Text(
                        'GET STARTED',
                        style: TextStyle(color:Colors.white.withOpacity(.6), fontSize: 16),
                      ),
                    ),
                )
                : Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FlatButton(
                          onPressed: ()=>updateIndex(detailItems.length-1),
                          child: Text(
                            'SKIP',
                            style: TextStyle(
                                color: Theme.of(context).secondaryHeaderColor.withOpacity(.8),
                                fontSize: 16),
                          ),
                        ),
                        FlatButton(
                          onPressed: ()=>updateIndex(currentIndex==detailItems.length-1?0:currentIndex+1),
                          child: Text(
                            'NEXT',
                            style: TextStyle(
                                color:  Theme.of(context).secondaryHeaderColor.withOpacity(.8),
                                fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ),
          )
        ],
      ),
    );
  }
}

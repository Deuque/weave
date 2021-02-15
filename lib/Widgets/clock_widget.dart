import 'dart:math';

import 'package:flutter/material.dart';
import 'package:weave/Util/colors.dart';

class ClockWidget extends StatelessWidget {
  final double size;
  final Color colorOfCircle;
  final List<Widget> items;

  const ClockWidget({Key key, this.size, this.colorOfCircle, this.items}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double clockSize = size;

    List<Widget> rightSide = items.sublist(0,3).map((e){
      int index = items.indexOf(e);
      double halfWidth = clockSize/2;
      //print(halfWidth);
      return Positioned(
        top: index%3 == 0 ? (index * halfWidth / 3) :  (index * halfWidth / 3) - (halfWidth/5),
        right: index%3 == 0 ? halfWidth-3 :  ((3-index).abs() * halfWidth / 3) - (halfWidth/6),
        child: e,
      );
    }).toList();
    List<Widget> rightSide2 = items.sublist(3,6).map((e){
      int index = items.indexOf(e);
      double halfWidth = clockSize/2;
      print((halfWidth / 3));
      return Positioned(
        bottom: index%3 == 0 ? halfWidth-3 :  ((3-(index%3)) * halfWidth / 3) - (halfWidth/6),
        right: index%3 == 0 ? ((3-index).abs() * halfWidth / 3) : ((index%3) * halfWidth / 3) - (halfWidth/4.4),
        child: e,
      );
    }).toList();
    List<Widget> lSide = items.sublist(6,9).map((e){
      int index = items.indexOf(e);
      double halfWidth = clockSize/2;
      print(index);
      return Positioned(
        bottom: index%3 == 0 ? 0 : ((index%3) * halfWidth / 3) - (halfWidth/5),
        left: index%3 == 0 ? halfWidth+3 :  ((3-index%3) * halfWidth / 3) - (halfWidth/6),
        child: e,
      );
    }).toList();
    List<Widget> lSide2 = items.sublist(9,12).map((e){
      int index = items.indexOf(e);
      double halfWidth = clockSize/2;
      print((halfWidth / 3));
      return Positioned(
        top: index%3 == 0 ? halfWidth-3 :  ((3-(index%3)) * halfWidth / 3) - (halfWidth/6),
        left: index%3 == 0 ? 0 : ((index%3) * halfWidth / 3) - (halfWidth/4.4),
        child: e,
      );
    }).toList();
    // List<Widget> leftSide = items.map((e){
    //   int index = items.indexOf(e);
    //   double halfWidth = clockSize/2;
    //   print(halfWidth);
    //   return Positioned(
    //     bottom: index%3 == 0 ? (index * halfWidth / 3) : index < 3 ? (index * halfWidth / 3) - (halfWidth/5) : (index * halfWidth / 3) + (halfWidth/10),
    //     left: index%3 == 0 ? ((3-index).abs() * halfWidth / 3) : index < 3 ? ((3-index).abs() * halfWidth / 3) - (halfWidth/5) : ((3-index).abs() * halfWidth / 3) - (halfWidth/3),
    //     child: e,
    //   );
    // }).toList();


    return Center(
        child: Stack(
          children: [
            Container(
              height: clockSize, width: clockSize,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colorOfCircle, width: 1)
              ),
            ),

            for(final item in rightSide)
              item,
            for(final item in rightSide2)
              item,
            for(final item in lSide)
              item,
            for(final item in lSide2)
              item,

          ],
        ));
  }
}

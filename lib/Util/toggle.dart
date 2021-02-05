
import 'package:flutter/material.dart';

import 'colors.dart';

class ZAnimatedToggle extends StatefulWidget {
  final bool isChecked;
  final onToggleCallback;
  final Color checkedColor,uncheckedColor;
  ZAnimatedToggle({
    Key key,
    @required this.isChecked,
    @required this.checkedColor,
    @required this.uncheckedColor,
    @required this.onToggleCallback,
  }) : super(key: key);

  @override
  _ZAnimatedToggleState createState() => _ZAnimatedToggleState();
}

class _ZAnimatedToggleState extends State<ZAnimatedToggle> {
  bool isChecked;
  @override
  void initState() {
    isChecked = widget.isChecked;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {

        setState(() {
          isChecked = !isChecked;
        });
        widget.onToggleCallback(isChecked);
      },
      child: Container(
//      width: width * .7,
//      height: width * .13,
    padding: const EdgeInsets.symmetric(vertical:2.0,horizontal: 5),
      width: 40.5,
        height: 32,
        child: Stack(
          children: [
            Center(
              child: Container(
                width: 40.5,
                height: 13,
                decoration: ShapeDecoration(
                    color: isChecked?widget.checkedColor.withOpacity(.25):widget.uncheckedColor.withOpacity(.25),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),

              ),
            ),
            AnimatedAlign(
              alignment: isChecked
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              duration: Duration(milliseconds: 350),
              curve: Curves.ease,
              child: Container(
                alignment: Alignment.center,
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                    // boxShadow: [
                    //   BoxShadow(
                    //     blurRadius: 25,
                    //     color: lightGrey,
                    //     offset: Offset(0,3)
                    //   )
                    // ],
                    color: isChecked? widget.checkedColor:widget.uncheckedColor,),
                //child: Icon(Icons.check,color:isChecked? white:Colors.transparent,size: 13,),
              ),
            )
          ],
        ),
      ),
    );
  }
}
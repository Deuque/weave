import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weave/Util/colors.dart';

class CustomBottomBarItem {
  CustomBottomBarItem({this.iconData, this.text});

  String iconData;
  String text;
}

class CustomBottomBar extends StatefulWidget {
  CustomBottomBar({
    this.items,
    this.height: 50.0,
    this.iconSize: 19.0,
    this.backgroundColor,
    this.color,
    this.selectedColor,
    this.notchedShape,
    this.onTabSelected,
  });


  final List<CustomBottomBarItem> items;
  final double height;
  final double iconSize;
  final Color backgroundColor;
  final Color color;
  final Color selectedColor;
  final NotchedShape notchedShape;
  final ValueChanged<int> onTabSelected;

  @override
  State<StatefulWidget> createState() => FABBottomAppBarState();
}

class FABBottomAppBarState extends State<CustomBottomBar> {
  int _selectedIndex = 0;

  _updateIndex(int index) {
    widget.onTabSelected(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabItem(
        item: widget.items[index],
        index: index,
        onPressed: _updateIndex,
      );
    });

    Widget _buildBottomIndicators(int index) {
      double dotHeight = 5;
      return Container(
        padding:  EdgeInsets.symmetric(horizontal: ((width/3)/2 - dotHeight/2),),
        child: AnimatedAlign(
          alignment: index == 0
              ? Alignment.centerLeft
              : index == 1
              ? Alignment.center
              : Alignment.centerRight,
          curve: Curves.easeInOutCirc,
          duration: Duration(milliseconds: 400),
          child: Image.asset(
            'assets/images/dot.png',
            color: accentColor,
            height: dotHeight,
          ),
        ),
      );
    }

    return BottomAppBar(
      notchMargin: 0,
      shape: widget.notchedShape,
      //color: widget.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: items,
            ),
            SizedBox(height: 5,),
            _buildBottomIndicators(_selectedIndex),

          ],
        ),
      ),
    );
  }



  Widget _buildTabItem({
    CustomBottomBarItem item,
    int index,
    ValueChanged<int> onPressed,
  }) {
    Color color = _selectedIndex == index ? widget.selectedColor : widget.color;
    return Expanded(
      child: GestureDetector(
        onTap: () => onPressed(index),
        child: Container(
          color: Colors.transparent,
          // height: widget.height,
          alignment: Alignment.center,
          child: item.iconData.isEmpty
              ? Container()
              : Image.asset(
                  item.iconData,
                  color: color,
                  height: widget.iconSize,
                  width: widget.iconSize,
                ),
        ),
      ),
    );
  }
}

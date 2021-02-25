import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:weave/Models/anagram_activity.dart';
import 'package:weave/Models/message.dart';
import 'package:weave/Util/colors.dart';
import 'package:weave/Util/helper_functions.dart';
import 'package:weave/Widgets/anagram_widget.dart';
import 'package:weave/Widgets/chat_widget.dart';

class TicTacToe extends StatefulWidget {
  final Function onFullScreen;

  const TicTacToe({Key key, this.onFullScreen}) : super(key: key);

  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  List<int> edges = [0, 2, 6, 8];
  List<Map<String, dynamic>> occupiedIndexes = [];
  String currentDrag = '';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // occupiedIndexes.sort((a, b) =>
    //     int.parse(a['valueParameter'].replaceAll(',', '')).compareTo(
    //         int.parse(b['valueParameter'].replaceAll(',', ''))));

    Widget actionBar() => Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: gameTypeWidget(
                        type: 0, size: width * .035, context: context),
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

    print(occupiedIndexes.asMap());

    Widget draggableWidget(String value) => Draggable(
          data: value,
          onDraggableCanceled: (v, o) {
            setState(() {
              currentDrag = '';
            });
          },
          childWhenDragging: Container(
            height: height * .04,
            width: height * .04,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(height * .07),
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).backgroundColor,
                      offset: Offset(-1.1, 1.1),
                      spreadRadius: 1,
                      blurRadius: 1)
                ]),
          ),
          child: currentDrag == value
              ? Container(
                  height: height * .04,
                  width: height * .04,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(height * .07),
                      color: Theme.of(context).scaffoldBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).backgroundColor,
                            offset: Offset(-1.1, 1.1),
                            spreadRadius: 1,
                            blurRadius: 1)
                      ]),
                )
              : Container(
                  height: height * .07,
                  width: height * .07,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(height * .07),
                      color: Colors.pink,
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).backgroundColor,
                            offset: Offset(-1.1, 1.1),
                            spreadRadius: 1,
                            blurRadius: 1)
                      ]),
                ),
          feedback: Container(
            height: height * .07,
            width: height * .07,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(height * .07),
              color: Colors.pink,
            ),
          ),
        );

    List unSelectedIndexes = [0, 1, 2];
    unSelectedIndexes.removeWhere((element) => occupiedIndexes
        .map((e) => e['value'])
        .toList()
        .contains('id' + element.toString()));

    List<String> selections =
        unSelectedIndexes.map((e) => 'id' + e.toString()).toList();
    List<Widget> selectionWidgets = selections
        .map((e) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: draggableWidget(e),
            ))
        .toList();

    String positionIsUsed(index) {
      for (final item in occupiedIndexes)
        if (item['position'] == index) return item['value'];
      return null;
    }

    dragTargetBackground(int index) => AnimatedContainer(
          duration: Duration(milliseconds: 400),
          curve: Curves.easeIn,
          height: height * .07,
          width: height * .07,
          margin: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).backgroundColor,
                    offset: Offset(-1.1, 1.1),
                    spreadRadius: 1,
                    blurRadius: 1)
              ]),
          alignment: Alignment.center,
          child: DragTarget(
            builder: (context, List<String> candidateData, rejectedData) {
              print('cand: $index ' + candidateData.asMap().toString());
              String valueOfPosition = positionIsUsed(index);
              return valueOfPosition != null
                  ? draggableWidget(valueOfPosition)
                  : Container();
            },
            onWillAccept: (data) {
              return occupiedIndexes
                  .where((element) => element['position'] == index)
                  .toList()
                  .isEmpty;
            },
            onAccept: (data) {
              setState(() {
                currentDrag = '';
                occupiedIndexes.add({'value': data, 'position': index});
                if (selectionWidgets.length == 1) {
                  // doneSelecting=true;
                  // selectionWidgets=[];
                }
              });
            },
            onLeave: (data) {
              setState(() {
                occupiedIndexes.removeWhere((element) =>
                    element['position'] == index && element['value'] == data);
              });
            },
            onMove: (details) {
              setState(() {
                currentDrag = details.data;
              });
            },
          ),
        );

    List<Widget> dragTargets =
        List.generate(9, (index) => dragTargetBackground(index));

    return Column(
      children: [
        actionBar(),
        Container(
          height: height * .07,
          child: Row(
            children: selectionWidgets,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Container(
          width: height * .4,
          padding: EdgeInsets.all(10),
          child: GridView.count(
            crossAxisCount: 3,
            children: dragTargets,
            shrinkWrap: true,
          ),
        )
      ],
    );
  }
}

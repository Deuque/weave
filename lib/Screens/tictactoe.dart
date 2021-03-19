import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:weave/Controllers/current_user_controller.dart';
import 'package:weave/Controllers/user_controller.dart';
import 'package:weave/Models/anagram_activity.dart';
import 'package:weave/Models/invite.dart';
import 'package:weave/Models/message.dart';
import 'package:weave/Models/tictactoe_activity.dart';
import 'package:weave/Models/user.dart';
import 'package:weave/Util/colors.dart';
import 'package:weave/Util/helper_functions.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:weave/Widgets/chat_clipper.dart';

class TicTacToe extends StatefulWidget {
  final Invite invite;
  final TictactoeActivity tictactoeActivity;
  final User opponent;
  final Function onFullScreen;
  final Function onRestartGame;

  const TicTacToe(
      {Key key,
      this.onFullScreen,
        this.onRestartGame,
      this.invite,
      this.tictactoeActivity,
      this.opponent})
      : super(key: key);

  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  List<Map<String, dynamic>> prevOccupiedIndexes = [];
  List<Map<String, dynamic>> occupiedIndexes = [];
  String id = '';
  String currentDrag = '';
  String creatorElement = 'assets/images/x.png';
  String inviteeElement = 'assets/images/o.png';
  List<int> winPositions = [];
  bool toPlay = false;
  int prevIndexesLength = 0;
  String whoWon='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.tictactoeActivity != null)
      occupiedIndexes.addAll(widget.tictactoeActivity.plays);
    id = context.read(userProvider.state).id;

  }

  // check if user play is valid
  userPlayIsValid() {
    List<Map<String, dynamic>> plays =
        widget.tictactoeActivity == null ? [] : widget.tictactoeActivity.plays;
    int currentUserPlayLength =
        occupiedIndexes.where((element) => element['id'] == id).toList().length;
    int prevUserPlayLength =
        plays.where((element) => element['id'] == id).toList().length;
    print('$currentUserPlayLength $prevIndexesLength');
    if (currentUserPlayLength != 3 &&
        (currentUserPlayLength == prevUserPlayLength)) {
      Fluttertoast.showToast(msg: 'You should move a new piece');
      setState(() {
        occupiedIndexes = [];
        occupiedIndexes.addAll(plays);
      });
      return false;
    } else if (currentUserPlayLength < prevUserPlayLength) {
      Fluttertoast.showToast(msg: 'You should make a valid move');
      setState(() {
        occupiedIndexes = [];
        occupiedIndexes.addAll(plays);
      });
      return false;
    }else if (currentUserPlayLength > prevUserPlayLength) {
      return true;
    }  else {
      for (final item in occupiedIndexes) {
        for (final item2 in plays) {
          if (item['value'] == item2['value']) {
            if (item['position'] != item2['position']) {
              return true;
            }
          }
        }
      }
      Fluttertoast.showToast(msg: 'You haven\'t moved a piece');
      return false;
    }
  }

  // upload user play
  uploadPlay() async {
    if (!userPlayIsValid()) return;
    TictactoeActivity tictactoeActivity =
        widget.tictactoeActivity ?? TictactoeActivity()
          ..parties = widget.invite.parties
          ..index = 0
          ..sender = id
          ..seenByReceiver = false
          ..plays = occupiedIndexes
          ..timestamp = Timestamp.now();
    widget.tictactoeActivity == null
        ? await UserController().addTttGame(tictactoeActivity)
        : await UserController().editTttGame(tictactoeActivity);
    if (widget.opponent.receiveGameNotifications && widget.opponent.token.isNotEmpty)
      await UserController().sendNotification(
          title: '@${context.read(userProvider.state).username} - TicTacToe',
          body: 'Your turn!',
          token: widget.opponent.token,
          id: 'game',
          extraData: widget.opponent.id,
          imageUrl: UserController().tttImage());
  }

  //check difference between occupiedIndex and previous plays
  List<Map<String, dynamic>> diff() {
    var plays =
        widget.tictactoeActivity == null ? [] : widget.tictactoeActivity.plays;
    List<Map<String, dynamic>> diff = [];
    for (final item in occupiedIndexes) {
      bool found = false;
      for (final item2 in plays) {
        if (item['value'] == item2['value']) {
          found = true;
          if (item['position'] != item2['position']) {
            diff.add(item);
          }
        }
      }
      if (!found) diff.add(item);
    }

    return diff;
  }

  // check if position of dragTarget is occupied
  Map<String, dynamic> positionIsUsed(index) {
    //List<Map<String,dynamic>> plays = widget.tictactoeActivity==null?[]:widget.tictactoeActivity.plays;
    for (final item in occupiedIndexes)
      if (item['position'] == index)
        return {'value': item['value'], 'id': item['id']};
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    //double dragObjectWidth = width * .07;
    double imageWidth = width * .1;

    winPositions=[];
    toPlay = widget.tictactoeActivity == null
        ? widget.invite.sender == id
        : widget.tictactoeActivity.sender != id;

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
                      onPressed: widget.onRestartGame),
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

    // draggable widget sample to be moved around the drag targets
    Widget draggableWidget(Map<String, dynamic> data, {bool won}) {
      return AbsorbPointer(
        absorbing: (winPositions.isNotEmpty && toPlay && whoWon!=id)||
            !toPlay ||
            data['id'] != id ||
            (diff().isNotEmpty && diff()[0]['value'] != data['value']),
        child: Draggable(
          data: data,
          onDraggableCanceled: (v, o) {
            setState(() {
              currentDrag = '';
            });
          },
          childWhenDragging: Container(
            height: imageWidth,
            width: imageWidth,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(imageWidth),
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).backgroundColor,
                      offset: Offset(-1.1, 1.1),
                      spreadRadius: 1,
                      blurRadius: 1)
                ]),
          ),
          child: currentDrag == data['value']
              ? Container(
                  height: imageWidth,
                  width: imageWidth,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
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
                  height: imageWidth,
                  width: imageWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(imageWidth),
                  ),
                  alignment: Alignment.center,
                  child: Image.asset(
                    data['id'] == widget.invite.sender
                        ? creatorElement
                        : inviteeElement,
                    height: imageWidth,
                    width: imageWidth,
                    color: won != null && won
                        ? Theme.of(context).scaffoldBackgroundColor
                        : primary,
                  ),
                ),
          feedback: Container(
            height: imageWidth,
            width: imageWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
            ),
            alignment: Alignment.center,
            child: Image.asset(
              data['id'] == widget.invite.sender
                  ? creatorElement
                  : inviteeElement,
              height: imageWidth,
              width: imageWidth,
              color: primary,
            ),
          ),
        ),
      );
    }

    //  create selections the user can pick from that haven't been moved
    List defIndexes = [0, 1, 2];
    defIndexes.removeWhere((element) {
      return occupiedIndexes
          .where((element2) =>
              element2['value'] == '$id$element' && element2['id'] == id)
          .toList()
          .isNotEmpty;
    });

    List<Map<String, dynamic>> selections =
        defIndexes.map((e) => {'value': '$id$e', 'id': id}).toList();
    List<Widget> selectionWidgets = selections
        .map((e) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: draggableWidget(e),
            ))
        .toList();

    // check if there is a winning play
    bool resolvePositions(List<int> indexes) {
      int a = indexes[0] >= 3
          ? indexes[0] >= 6
              ? 9
              : 6
          : 3;
      int b = indexes[1] >= 3
          ? indexes[1] >= 6
              ? 9
              : 6
          : 3;
      int c = indexes[2] >= 3
          ? indexes[2] >= 6
              ? 9
              : 6
          : 3;
      //print('$a $b $c');
      if ((b == c && b == a) || (a == b && a == c) || (a != b && b != c)) {
        return true;
      }
      return false;
    }

    List myPositions =
        occupiedIndexes.where((element) => element['id'] == id).toList();
    List<int> myPositionIndexes =
        myPositions.map((e) => (e['position'] as int)).toList();
    myPositionIndexes.sort((a, b) => a.compareTo(b));
    if (myPositionIndexes.length == 3 &&
        (myPositionIndexes[1] - myPositionIndexes[0] ==
            myPositionIndexes[2] - myPositionIndexes[1]) &&
        resolvePositions(myPositionIndexes)) {
      winPositions = myPositionIndexes;
      whoWon = id;
    } else {

      List oppPositions =
          occupiedIndexes.where((element) => element['id'] != id).toList();
      List<int> oppPositionIndexes =
          oppPositions.map((e) => (e['position'] as int)).toList();
      oppPositionIndexes.sort((a, b) => a.compareTo(b));
      if (oppPositionIndexes.length == 3 &&
          (oppPositionIndexes[1] - oppPositionIndexes[0] ==
              oppPositionIndexes[2] - oppPositionIndexes[1]) &&
          resolvePositions(oppPositionIndexes)) {
        winPositions = oppPositionIndexes;
        whoWon = widget.opponent.id;
      }
    }

    // dragTarget sample widget
    dragTargetBackground(int index) => AnimatedContainer(
          duration: Duration(milliseconds: 400),
          curve: Curves.easeIn,
          // height: dragObjectWidth,
          // width: dragObjectWidth,
          margin: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: winPositions.contains(index)
                  ? success.withOpacity(.8)
                  : Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).backgroundColor,
                    offset: Offset(-1.1, 1.1),
                    spreadRadius: 1,
                    blurRadius: 1)
              ]),
          alignment: Alignment.center,
          child: DragTarget(
            builder: (context, List<Map<String, dynamic>> candidateData,
                rejectedData) {
              Map<String, dynamic> positionData = positionIsUsed(index);
              return positionData != null
                  ? draggableWidget(positionData,
                      won: winPositions.contains(index))
                  : Container();
            },
            onWillAccept: (data) {
              return occupiedIndexes
                      .where((element) => element['position'] == index)
                      .toList()
                      .isEmpty &&
                  diff().length < 1;
            },
            onAccept: (data) {
              setState(() {
                currentDrag = '';

                occupiedIndexes.add({
                  'value': data['value'],
                  'position': index,
                  'id': data['id']
                });
                if (selectionWidgets.length == 1) {
                  // doneSelecting=true;
                  // selectionWidgets=[];
                }
              });
            },
            onLeave: (data) {
              setState(() {
                occupiedIndexes.removeWhere((element) =>
                    element['position'] == index &&
                    element['value'] == (data as Map)['value'] &&
                    element['id'] == (data as Map)['id']);
              });
            },
            onMove: (details) {
              setState(() {
                currentDrag = details.data['value'];
              });
            },
          ),
        );

    // list of drag Target sample widgets, play area
    List<Widget> dragTargets =
        List.generate(9, (index) => dragTargetBackground(index));

    turnWidget(bool userTurn) => Padding(
          padding: const EdgeInsets.only(top: 15.0, right: 15,left: 15,bottom: 30),
          child: Align(
            alignment: userTurn ? Alignment.centerRight : Alignment.centerLeft,
            child: ClipPath(
                clipper: ChatClipper(leftSide: !userTurn, clip: true),
                child: Container(
                  padding: EdgeInsets.only(
                      top: 7,
                      bottom: 10,
                      right: userTurn ? 23 : 10,
                      left: userTurn ? 10 : 23),
                  color: lightGrey.withOpacity(.15),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                          userTurn
                              ? 'Your turn'
                              : '@${widget.opponent.username} is playing',
                          style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context)
                                  .secondaryHeaderColor
                                  .withOpacity(.6))),
                      SizedBox(
                        width: 5,
                      ),
                      Image.asset(
                        userTurn ? widget.invite.sender == id
                            ? creatorElement
                            : inviteeElement : widget.invite.sender == widget.opponent.id
                            ? creatorElement
                            : inviteeElement,
                        height: 10,
                        color: primary,
                      )
                    ],
                  ),
                )),
          ),
        );
    winWidget()=> Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/confetti.png',height: width*.06,),
          SizedBox(width: 10,),
          Text(
            '${whoWon==id?'You':'@${widget.opponent.username}'} won',
            style: TextStyle(
                color: Theme
                    .of(context)
                    .secondaryHeaderColor
                    .withOpacity(.8),
                fontSize: width*.045),
          )
        ],
        ),
    );
    
    

    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        actionBar(),
        if(winPositions.isEmpty || (winPositions.isNotEmpty && toPlay && whoWon==id))turnWidget(toPlay),
        Container(
          height: imageWidth + imageWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: selectionWidgets,
          ),
        ),
        if(winPositions.isNotEmpty && (!toPlay || (toPlay && whoWon!=id)))winWidget(),
        Container(
          width: width * .7,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(horizontal: width*.1),
          child: GridView.count(
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            children: dragTargets,
            shrinkWrap: true,
          ),
        ),

        if(winPositions.isEmpty || (winPositions.isNotEmpty && toPlay && whoWon==id))Padding(
          padding: EdgeInsets.only(
              left: width * .1, right: width * .1, bottom: 15,top: 10),
          child: actionButton('PLAY', toPlay, false, uploadPlay, context),
        ),

      ],
    );
  }
}

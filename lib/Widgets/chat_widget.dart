import 'package:flutter/material.dart';
import 'package:weave/Controllers/current_user_controller.dart';
import 'package:weave/Controllers/user_controller.dart';
import 'package:weave/Models/message.dart';
import 'package:weave/Util/colors.dart';
import 'package:weave/Widgets/chat_clipper.dart';
import 'package:flutter_riverpod/all.dart';

class ChatLayout extends StatefulWidget {
  final Message message;
  final bool previousIsSameSender;

  const ChatLayout({Key key, this.message, this.previousIsSameSender}) : super(key: key);

  @override
  _ChatLayoutState createState() => _ChatLayoutState();
}

class _ChatLayoutState extends State<ChatLayout> {
  bool userIsSender;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userIsSender = widget.message.userIsSender;
    updateReceiverSeen();
  }

  updateReceiverSeen()async{
    if(widget.message.receiver==context.read(userProvider.state).id && !widget.message.seenByReceiver){
      UserController().editMessage(widget.message..seenByReceiver=true);
    }
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width*.7,
      alignment: userIsSender?Alignment.centerRight:Alignment.centerLeft,
      margin: EdgeInsets.only(top: widget.previousIsSameSender?0:10,bottom: 2, left: userIsSender?size.width*.15 : 10,right: userIsSender?10:size.width*.15),
      child: ClipPath(
          clipper: ChatClipper(leftSide: !userIsSender,clip: !widget.previousIsSameSender),
          child: Container(
            color: userIsSender
                ? primary.withOpacity(.8)
                : lightGrey.withOpacity(.15),
            padding: EdgeInsets.only(top: 7,bottom: 10,right: userIsSender?23:10,left: userIsSender?10:23),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: userIsSender
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  widget.message.time,
                  style:
                      TextStyle(fontSize: 11, color: Theme.of(context)
                          .secondaryHeaderColor.withOpacity(.4)),
                ),
                SizedBox(height: 4,),
                Text(
                  widget.message.message,
                  style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context)
                          .secondaryHeaderColor
                          .withOpacity(.78)),
                ),
              ],
            ),
          )),
    );
  }
}


